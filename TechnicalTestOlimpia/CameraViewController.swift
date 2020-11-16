//
//  CameraViewController.swift
//  TechnicalTestOlimpia
//
//  Created by Laddy Diaz Lamus on 14/11/20.
//

import UIKit
import Photos
import Lottie
import PureLayout
import CropViewController

protocol CameraViewDelegate {
    func did(photo: String, message: String)
}

class CameraViewController: UIViewController {
    private let one: CGFloat = 1
    private let two: CGFloat = 2
    private let padding: CGFloat = 16
    private let zoomSize: CGSize = CGSize(width: 150, height: 30)
    private let totalZoom: CGFloat = 100
    private let sizeImage = CGSize(width: 2, height: 3)
    private let playFocus: CGFloat = 1.0
    private let startFocus: CGFloat = 0.9
    
    var controller: CameraController!
    var delegate: CameraViewDelegate!
    lazy var defaults: DefaultsConfig = {
        return DefaultsConfig.shared
    }()
    
    var lastFocusPoint: CGPoint?
    var location: CGPoint?
    
    var tapToFocusLeftConstraint: NSLayoutConstraint!
    var tapToFocusTopConstraint: NSLayoutConstraint!
    func positionTapToFocusView(center: CGPoint) {
        tapToFocusLeftConstraint.constant = center.x
        tapToFocusTopConstraint.constant = center.y
    }
    
    private var croppingStyle = CropViewCroppingStyle.default
    private var croppedRect = CGRect.zero
    private var croppedAngle = 0
    private let imageView = UIImageView()

    @IBOutlet weak var preview: UIView!
    @IBOutlet weak var close: UIButton!
    @IBOutlet weak var flash: UIButton!
    @IBOutlet weak var camera: UIButton!
    @IBOutlet weak var gallery: UIButton!
    @IBOutlet weak var capture: UIButton!
    @IBOutlet weak var zoom: UISlider!

    var flashMode = AVCaptureDevice.FlashMode.off
    var photo: UIImage!
    var cropType: CropViewControllerAspectRatioPreset = .presetSquare
    
    lazy var tapToFocusView: AnimationView = {
        let view = AnimationView(name: "focus")
        view.animationSpeed = 1
        view.backgroundBehavior = .forceFinish
        view.contentMode = .scaleAspectFit
        view.autoSetDimensions(to: CGSize(width: 150,
                                          height: 150))
        view.setContentHuggingPriority(.required, for: .horizontal)
        view.setContentHuggingPriority(.required, for: .vertical)
        return view
    }()
}

extension CameraViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        controller = CameraController()
        controller.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(focus(gesture:)))
        preview.addGestureRecognizer(tap)
        
        zoom.transform = CGAffineTransform(rotationAngle: CGFloat.pi / -two)
        
        style()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let navigation = self.navigationController else {
            return
        }
        navigation.navigationBar.isHidden = true
    }
    
    func configure() {
        controller.prepare { error in
            if let error = error {
                print(error)
            }
            do {
                try self.controller.displayPreview(on: self.preview)
            } catch {
                print(error)
            }
        }
        
        view.addSubview(tapToFocusView)
        tapToFocusView.isUserInteractionEnabled = false
        tapToFocusLeftConstraint = tapToFocusView.centerXAnchor.constraint(equalTo: view.leftAnchor)
        tapToFocusLeftConstraint.isActive = true
        tapToFocusTopConstraint = tapToFocusView.centerYAnchor.constraint(equalTo: view.topAnchor)
        tapToFocusTopConstraint.isActive = true
    }
    
    func style() {
        capture.layer.borderColor = UIColor.nTint?.cgColor
        capture.layer.borderWidth = two
        capture.layer.cornerRadius = min(capture.frame.width,
                                         capture.frame.height) / two
    }
    
    func completeFocusAnimation(forFocusPoint focusPoint: CGPoint) {
        guard let lastFocusPoint = lastFocusPoint else {
            return
        }
        
        guard lastFocusPoint.within(0.005, of: focusPoint) else {
            print("focus completed for obsolete focus point. User has refocused.")
            return
        }
        
        tapToFocusView.play(toProgress: playFocus)
    }
    
    @objc func focus(gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: view)
        guard let point = controller.previewLayer?.captureDevicePointConverted(fromLayerPoint: location) else {
            return
        }
        
        controller.focus(with: .autoFocus,
                         exposureMode: .autoExpose,
                         at: point,
                         monitorSubjectAreaChange: true)
        
        // If the user taps near the capture button, it's more likely a mis-tap than intentional.
        // Skip the focus animation in that case, since it looks bad.
        let origin = capture.superview!.convert(capture.frame.origin, to: view)
        guard location.y < origin.y else {
            print("Skipping animation for bottom row on iPhone")
            
            // Finish any outstanding focus animation, otherwise it will remain in an
            // uncompleted state.
            if let lastFocusPoint = lastFocusPoint {
                completeFocusAnimation(forFocusPoint: lastFocusPoint)
            }
            return
        }
        
        lastFocusPoint = point
        do {
            let convertedPoint = tapToFocusView.superview!.convert(location, from: view)
            positionTapToFocusView(center: convertedPoint)
            tapToFocusView.superview?.layoutIfNeeded()
            startFocusAnimation()
        }
    }
    
    func startFocusAnimation() {
        tapToFocusView.stop()
        tapToFocusView.play(fromProgress: .zero, toProgress: startFocus)
    }
}

extension CameraViewController {
    @IBAction func close(_ sender: UIButton) {
        dismiss(animated: true,
                completion: nil)
    }
    
    @IBAction func toggleFlash(_ sender: UIButton) {
        if flashMode == .on {
            flashMode = .off
            flash.setImage(UIImage(systemName: "bolt.slash.fill"), for: .normal)
        } else {
            flashMode = .on
            flash.setImage(UIImage(systemName: "bolt.fill"), for: .normal)
        }
    }
    
    @IBAction func toggleCamera(_ sender: UIButton) {
        controller.switchCamera(on: preview)
    }
    
    @IBAction func openGallery(_ sender: UIButton) {
        
    }
    
    @IBAction func capture(_ sender: UIButton) {
        controller.capturePhoto(flash: flashMode) { photo, error in
            guard let photo = photo else {
                print(error ?? "Image capture error")
                return
            }
            self.photo = photo
            self.imageView.image = photo
            let crop = CropViewController(croppingStyle: self.croppingStyle,
                                          image: self.imageView.image!)
            if self.cropType == .presetSquare {
                crop.aspectRatioPreset = self.cropType
            } else if self.cropType == .preset3x2 {
                crop.aspectRatioPreset = self.cropType
            } else {
                crop.aspectRatioPreset = .presetCustom
                crop.customAspectRatio = self.sizeImage
            }
            crop.aspectRatioLockEnabled = true
            crop.aspectRatioPickerButtonHidden = true
            crop.resetButtonHidden = true
            crop.delegate = self
            
            self.present(crop, animated: true, completion: nil)
        }
    }
    
    @IBAction func zoom(_ sender: Any) {
        let percent = ((two * CGFloat(zoom.value)) / totalZoom) + one
        controller.updateZoom(zoom: percent)
    }
}

extension CameraViewController: CameraDelegate {
    func didCompleteFocusing(atPoint: CGPoint) {
        completeFocusAnimation(forFocusPoint: atPoint)
    }
}

extension CameraViewController: CropViewControllerDelegate {
    func cropViewController(_ cropViewController: CropViewController,
                            didCropToImage image: UIImage,
                            withRect cropRect: CGRect,
                            angle: Int) {
        croppedRect = cropRect
        croppedAngle = angle
        updateImage(image, controller: cropViewController)
    }
    
    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: true, completion: {
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropImageToRect rect: CGRect, angle: Int) {
        croppedRect = rect
        croppedAngle = angle
        updateImage(imageView.image!, controller: cropViewController)
    }
    
    private func updateImage(_ image: UIImage, controller: CropViewController) {
        imageView.image = image
        layoutImageView()
        imageView.isHidden = true
        controller.dismissAnimatedFrom(self,
                                       withCroppedImage: image,
                                       toView: imageView,
                                       toFrame: .zero,
                                       setup: {
                                        self.layoutImageView()
        }) {
            self.imageView.isHidden = false
            guard let data: Data = self.imageView.image?.jpegData(compressionQuality: 0.25) else {
                return
            }
            let base64 = data.base64EncodedString()
            self.delegate.did(photo: base64, message: "")
            self.imageView.image = nil
        }
    }
    
    private func layoutImageView() {
        guard photo != nil else { return }
        var viewFrame = self.view.bounds
        viewFrame.size.width -= (padding * 2.0)
        viewFrame.size.height -= ((padding * 2.0))
        
        var imageFrame = CGRect.zero
        imageFrame.size = imageView.image!.size;
        
        if imageView.image!.size.width > viewFrame.size.width || imageView.image!.size.height > viewFrame.size.height {
            let scale = min(viewFrame.size.width / imageFrame.size.width, viewFrame.size.height / imageFrame.size.height)
            imageFrame.size.width *= scale
            imageFrame.size.height *= scale
            imageFrame.origin.x = (self.view.bounds.size.width - imageFrame.size.width) * 0.5
            imageFrame.origin.y = (self.view.bounds.size.height - imageFrame.size.height) * 0.5
            imageView.frame = imageFrame
        } else {
            self.imageView.frame = imageFrame;
            self.imageView.center = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY)
        }
    }
}
