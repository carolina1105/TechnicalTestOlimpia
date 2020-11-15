//
//  CameraController.swift
//  TechnicalTestOlimpia
//
//  Created by Laddy Diaz Lamus on 14/11/20.
//

import AVFoundation
import UIKit

protocol CameraDelegate {
    func didCompleteFocusing(atPoint: CGPoint)
}

class CameraController: NSObject {
    let one: CGFloat = 1
    let prepare = "prepare"
    let animation: Double = 0.5
    private let sessionQueue = DispatchQueue(label: "PhotoCapture.sessionQueue")
    private let minimumZoom: CGFloat = 1.0
    private let maximumZoom: CGFloat = 3.0
    private var zoomFactor: CGFloat = 1.0
    
    lazy var videoDataOutput = AVCaptureVideoDataOutput()
    var focusObservation: NSKeyValueObservation?
    var captureSession: AVCaptureSession?
    var delegate: CameraDelegate!
    
    var currentCameraPosition: CameraPosition?
    var currentCaptureInput: AVCaptureDeviceInput?
    var currentCamera: AVCaptureDevice?
    private(set) var desiredPosition: AVCaptureDevice.Position = .back
    
    var photoOutput: AVCapturePhotoOutput?
    var audioDeviceInput: AVCaptureDeviceInput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    var photoCaptureCompletionBlock: ((UIImage?, Error?) -> Void)?
    var hasCaptureStarted = false
    
    private var _captureOrientation: AVCaptureVideoOrientation = .portrait
    var captureOrientation: AVCaptureVideoOrientation {
        get {
            return _captureOrientation
        }
        set {
            _captureOrientation = newValue
        }
    }
    
    func setupPhotoCapture(success: @escaping () -> Void) {
        guard let session = captureSession else {
            return
        }
        // If the session is already running, we're good to go.
        if !session.isRunning {
            self.hasCaptureStarted = true
        }
        
        startVideoCapture(success: success)
    }
    
    func configurePhotoOutput() throws {
        guard let captureSession = self.captureSession else { throw CameraControllerError.captureSessionIsMissing }
        
        self.photoOutput = AVCapturePhotoOutput()
        self.photoOutput!.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.jpeg])], completionHandler: nil)

        if captureSession.canAddOutput(self.photoOutput!) { captureSession.addOutput(self.photoOutput!) }
    }
    
    deinit {
        captureSession = nil
        currentCameraPosition = nil
        currentCaptureInput = nil
        currentCamera = nil
        photoOutput = nil
        previewLayer = nil
        photoCaptureCompletionBlock = nil
    }
}

extension CameraController {
    func prepare(completionHandler: @escaping (Error?) -> Void) {
        func createCaptureSession() {
            self.captureSession = AVCaptureSession()
        }
        
        DispatchQueue(label: prepare).async {
            createCaptureSession()
            self.setupPhotoCapture {
                DispatchQueue.main.async {
                    do {
                        guard let session = self.captureSession else {
                            return
                        }
                        session.startRunning()
                        try self.configurePhotoOutput()
                        completionHandler(nil)
                    } catch {
                        completionHandler(error)
                    }
                }
            }
        }
    }
    
    public func startVideoCapture(success: @escaping () -> Void) {
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(orientationDidChange),
                                               name: UIDevice.orientationDidChangeNotification,
                                               object: UIDevice.current)
        let initialCaptureOrientation = AVCaptureVideoOrientation(deviceOrientation: UIDevice.current.orientation) ?? .portrait
        
        sessionQueue.async { [weak self] in
            guard let strongSelf = self else { return }
            guard let session = strongSelf.captureSession else {
                return
            }
            
            session.beginConfiguration()
            defer { session.commitConfiguration() }
            
            strongSelf.captureOrientation = initialCaptureOrientation
            session.sessionPreset = .high
            
            do {
                try strongSelf.updateCurrentInput(position: .back)
            } catch {
                print(error.localizedDescription)
            }
            
            strongSelf.currentCameraPosition = .rear
            
            let video = strongSelf.videoDataOutput
            guard session.canAddOutput(video) else {
                return
            }
            session.addOutput(video)
            guard let connection = video.connection(with: .video) else {
                return
            }
            connection.videoOrientation = strongSelf.captureOrientation
            if connection.isVideoStabilizationSupported {
                connection.preferredVideoStabilizationMode = .auto
            }
            strongSelf.hasCaptureStarted = true
            success()
        }
    }
    
    public func updateCurrentInput(position: AVCaptureDevice.Position) throws {
        guard let session = captureSession else {
            throw CameraControllerError.captureSessionIsMissing
        }
        
        guard let device = videoDevice(position: position) else {
            throw CameraControllerError.inputsAreInvalid
        }
        self.currentCamera = device
        
        let newInput = try AVCaptureDeviceInput(device: device)

        if let oldInput = self.currentCaptureInput {
            session.removeInput(oldInput)
            NotificationCenter.default.removeObserver(self, name: .AVCaptureDeviceSubjectAreaDidChange, object: oldInput.device)
        }
        session.addInput(newInput)
        NotificationCenter.default.addObserver(self, selector: #selector(subjectAreaDidChange), name: .AVCaptureDeviceSubjectAreaDidChange, object: newInput.device)

        if let focusObservation = focusObservation {
            focusObservation.invalidate()
        }
        self.focusObservation = newInput.observe(\.device.isAdjustingFocus,
                                                 options: [.old, .new]) { [weak self] _, change in
                                                    guard let self = self else { return }

                                                    guard let oldValue = change.oldValue else {
                                                        return
                                                    }

                                                    guard let newValue = change.newValue else {
                                                        return
                                                    }

                                                    if oldValue == true && newValue == false {
                                                        self.didCompleteFocusing()
                                                    }
        }

        currentCaptureInput = newInput

        resetFocusAndExposure()
    }
    
    func didCompleteFocusing() {
        guard let currentCaptureInput = currentCaptureInput else {
            return
        }

        let focusPoint = currentCaptureInput.device.focusPointOfInterest

        DispatchQueue.main.async {
            self.delegate.didCompleteFocusing(atPoint: focusPoint)
        }
    }

    func videoDevice(position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        return AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: position)
    }
    
    func displayPreview(on view: UIView) throws {
        guard let captureSession = self.captureSession, captureSession.isRunning else { throw CameraControllerError.captureSessionIsMissing }
        self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.previewLayer?.connection?.videoOrientation = .portrait
        
        view.layer.insertSublayer(self.previewLayer!, at: .zero)
        self.previewLayer?.frame = view.frame
    }
    
    public func switchCamera(on view: UIView) {
        let newPosition: AVCaptureDevice.Position
        switch desiredPosition {
        case .front:
            newPosition = .back
        case .back:
            newPosition = .front
        case .unspecified:
            newPosition = .front
        @unknown default:
            print("Unexpected enum value.")
            newPosition = .front
            break
        }
        desiredPosition = newPosition

        guard let session = self.captureSession else {
            return
        }
        
        UIView.transition(with: view,
                          duration: self.animation,
                          options: [.transitionFlipFromRight],
                          animations: nil) { _ in
        }
        
        sessionQueue.async { [weak self] in
            do {
                guard let `self` = self else { return }
                session.beginConfiguration()
                defer { session.commitConfiguration() }
                try self.updateCurrentInput(position: newPosition)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func capturePhoto(flash mode: AVCaptureDevice.FlashMode,
                      completion: @escaping (UIImage?, Error?) -> Void) {
        guard let captureSession = captureSession, captureSession.isRunning else { completion(nil, CameraControllerError.captureSessionIsMissing); return }
        
        let settings = AVCapturePhotoSettings()
        settings.flashMode = mode
        
        self.photoOutput?.capturePhoto(with: settings, delegate: self)
        self.photoCaptureCompletionBlock = completion
    }
    
    @objc
    private func subjectAreaDidChange(notification: NSNotification) {
       resetFocusAndExposure()
    }
    
    public func resetFocusAndExposure() {
        let devicePoint = CGPoint(x: 0.5, y: 0.5)
        focus(with: .continuousAutoFocus, exposureMode: .continuousAutoExposure, at: devicePoint, monitorSubjectAreaChange: false)
    }
    
    @objc
    public func orientationDidChange(notification: Notification) {
        guard let captureOrientation = AVCaptureVideoOrientation(deviceOrientation: UIDevice.current.orientation) else {
            return
        }
        
        sessionQueue.async {
            guard captureOrientation != self.captureOrientation else {
                return
            }
            DispatchQueue.main.async {
                self.captureOrientation = captureOrientation
            }
        }
    }
}

extension CameraController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photo: AVCapturePhoto,
                     error: Error?) {
        if error != nil {
            self.photoCaptureCompletionBlock?(nil, error)
        }
        let data = photo.fileDataRepresentation()
        
        if data == nil {
            self.photoCaptureCompletionBlock?(nil, CameraControllerError.unknown)
            return
        }
        let image = UIImage(data: data!)
        self.photoCaptureCompletionBlock?(image, nil)
    }
}

extension CameraController {
    // MARK: - Zoom
    public func updateZoom(zoom: CGFloat) {
        sessionQueue.async {
            self.updateZoom(factor: zoom)
        }
    }
    
    public func updateZoom(scaleFromPreviousZoomFactor scale: CGFloat) {
        sessionQueue.async {
            guard let capture = self.currentCamera else {
                return
            }
            
            let zoomFactor = self.clampZoom(scale * self.zoomFactor, device: capture)
            self.updateZoom(factor: zoomFactor)
        }
    }
    
    public func completeZoom(scaleFromPreviousZoomFactor scale: CGFloat) {
        sessionQueue.async {
            guard let capture = self.currentCamera else {
                return
            }
            
            let zoomFactor = self.clampZoom(scale * self.zoomFactor, device: capture)
            
            print("ended with scaleFactor: \(zoomFactor)")
            
            self.zoomFactor = zoomFactor
            self.updateZoom(factor: zoomFactor)
        }
    }
    
    private func updateZoom(factor: CGFloat) {
        guard let capture = self.currentCamera else {
            return
        }
        
        do {
            try capture.lockForConfiguration()
            capture.videoZoomFactor = factor
            capture.unlockForConfiguration()
        } catch {
            print("error: \(error)")
        }
    }
    
    private func clampZoom(_ factor: CGFloat, device: AVCaptureDevice) -> CGFloat {
        return min(factor.clamp(minimumZoom, maximumZoom), device.activeFormat.videoMaxZoomFactor)
    }
}

extension CameraController {
    public func focus(with focusMode: AVCaptureDevice.FocusMode,
                      exposureMode: AVCaptureDevice.ExposureMode,
                      at devicePoint: CGPoint,
                      monitorSubjectAreaChange: Bool) {
        sessionQueue.async {
            print("focusMode: \(focusMode), exposureMode: \(exposureMode), devicePoint: \(devicePoint), monitorSubjectAreaChange:\(monitorSubjectAreaChange)")
            guard let device = self.currentCamera else {
                return
            }
            do {
                try device.lockForConfiguration()
                
                if device.isFocusPointOfInterestSupported && device.isFocusModeSupported(focusMode) {
                    device.focusPointOfInterest = devicePoint
                    device.focusMode = focusMode
                }
                
                if device.isExposurePointOfInterestSupported && device.isExposureModeSupported(exposureMode) {
                    device.exposurePointOfInterest = devicePoint
                    device.exposureMode = exposureMode
                }
                
                device.isSubjectAreaChangeMonitoringEnabled = monitorSubjectAreaChange
                device.unlockForConfiguration()
            } catch {
                print("error: \(error)")
            }
        }
    }
}

extension CameraController {
    enum CameraControllerError: Swift.Error {
        case captureSessionAlreadyRunning
        case captureSessionIsMissing
        case inputsAreInvalid
        case invalidOperation
        case noCamerasAvailable
        case unknown
    }
    
    public enum CameraPosition {
        case front
        case rear
    }
}

extension AVCaptureVideoOrientation {
    init?(deviceOrientation: UIDeviceOrientation) {
        switch deviceOrientation {
        case .unknown:
            return nil
        case .portrait: self = .portrait
        case .portraitUpsideDown: self = .portraitUpsideDown
        case .landscapeLeft: self = .landscapeRight
        case .landscapeRight: self = .landscapeLeft
        case .faceUp:
            return nil
        case .faceDown:
            return nil
        @unknown default:
            return nil
        }
    }
    
    init?(interfaceOrientation: UIInterfaceOrientation) {
        switch interfaceOrientation {
        case .unknown:
            return nil
        case .portrait: self = .portrait
        case .portraitUpsideDown: self = .portraitUpsideDown
        case .landscapeLeft: self = .landscapeLeft
        case .landscapeRight: self = .landscapeRight
        @unknown default:
            return nil
        }
    }
}

extension AVCaptureVideoOrientation: CustomStringConvertible {
    public var description: String {
        switch self {
        case .portrait:
            return "AVCaptureVideoOrientation.portrait"
        case .portraitUpsideDown:
            return "AVCaptureVideoOrientation.portraitUpsideDown"
        case .landscapeRight:
            return "AVCaptureVideoOrientation.landscapeRight"
        case .landscapeLeft:
            return "AVCaptureVideoOrientation.landscapeLeft"
        @unknown default:
            return "AVCaptureVideoOrientation.unknownDefault"
        }
    }
}

extension UIDeviceOrientation: CustomStringConvertible {
    public var description: String {
        switch self {
        case .unknown:
            return "UIDeviceOrientation.unknown"
        case .portrait:
            return "UIDeviceOrientation.portrait"
        case .portraitUpsideDown:
            return "UIDeviceOrientation.portraitUpsideDown"
        case .landscapeLeft:
            return "UIDeviceOrientation.landscapeLeft"
        case .landscapeRight:
            return "UIDeviceOrientation.landscapeRight"
        case .faceUp:
            return "UIDeviceOrientation.faceUp"
        case .faceDown:
            return "UIDeviceOrientation.faceDown"
        @unknown default:
            return "UIDeviceOrientation.unknownDefault"
        }
    }
}

extension UIInterfaceOrientation: CustomStringConvertible {
    public var description: String {
        switch self {
        case .unknown:
            return "UIInterfaceOrientation.unknown"
        case .portrait:
            return "UIInterfaceOrientation.portrait"
        case .portraitUpsideDown:
            return "UIInterfaceOrientation.portraitUpsideDown"
        case .landscapeLeft:
            return "UIInterfaceOrientation.landscapeLeft"
        case .landscapeRight:
            return "UIInterfaceOrientation.landscapeRight"
        @unknown default:
            return "UIInterfaceOrientation.unknownDefault"
        }
    }
}
