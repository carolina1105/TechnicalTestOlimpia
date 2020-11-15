//
//  GalleryView.swift
//  TechnicalTestOlimpia
//
//  Created by Laddy Diaz Lamus on 14/11/20.
//

import SwiftUI
import Photos
import CropViewController

struct GalleryView: UIViewControllerRepresentable {
    private(set) var isInBatchSelectMode = true
    private(set) var isPickingAsDocument = false
    
    var cropType: CropViewControllerAspectRatioPreset = .preset3x2
    var didSendPhoto: (String, String) -> Void

    func makeUIViewController(context: UIViewControllerRepresentableContext<GalleryView>) -> UINavigationController {
        let gallery = GalleryViewController(cropType: self.cropType)
        gallery.delegate = self
        let navigation = UINavigationController(rootViewController: gallery)
        return navigation
    }

    func updateUIViewController(_ uiViewController: UINavigationController,
                                context: UIViewControllerRepresentableContext<GalleryView>) {
    }
}

extension GalleryView: GalleryControllerDelegate {
    func did(photo: String, message: String) {
        didSendPhoto(photo, message)
    }
    func didCompleteSelection(_ picker: GalleryViewController) {}
    func didCancel(_ picker: GalleryViewController) {}

    func isAssetSelected(_ picker: GalleryViewController, asset: PHAsset) -> Bool { return true }
    func didSelectAsset(_ picker: GalleryViewController, asset: PHAsset, data: Data?, url: URL?, uti: String) {}
    func didDeselectAsset(_ picker: GalleryViewController, asset: PHAsset) {}
 
    func canSelectMoreItems(_ picker: GalleryViewController) -> Bool { return true }
    func didTryToSelectTooMany(_ picker: GalleryViewController) {}
}

struct GalleryView_Previews: PreviewProvider {
    static var previews: some View {
        GalleryView { _, _ in
        }
    }
}
