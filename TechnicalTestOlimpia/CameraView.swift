//
//  CameraView.swift
//  TechnicalTestOlimpia
//
//  Created by Laddy Diaz Lamus on 14/11/20.
//

import SwiftUI
import CropViewController

struct CameraView: UIViewControllerRepresentable {
    let storyboard = "Camera"
    let controller = "CameraViewController"
    
    var isProfile: Bool = false
    var cropType: CropViewControllerAspectRatioPreset = .preset3x2
    var didSendPhoto: (String, String) -> Void

    func makeUIViewController(context: UIViewControllerRepresentableContext<CameraView>) -> CameraViewController {
        let camera = UIStoryboard(name: storyboard,
                                  bundle: nil)
            .instantiateViewController(withIdentifier: controller) as! CameraViewController
        camera.delegate = self
        camera.cropType = self.cropType
        return camera
    }

    func updateUIViewController(_ uiViewController: CameraViewController,
                                context: UIViewControllerRepresentableContext<CameraView>) {
    }
}

extension CameraView: CameraViewDelegate {
    func did(photo: String, message: String) {
        didSendPhoto(photo, message)
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView { _, _ in
        }
    }
}
