//
//  DeviceExtension.swift
//  TechnicalTestOlimpia
//
//  Created by Laddy Diaz Lamus on 13/11/20.
//

import UIKit
import AVFoundation

public extension UIDevice {
    private static let standarScale: CGFloat = 2.0
    
    var hasNotch: Bool {
        let initialWindow = 0
        let bottom = UIApplication.shared.windows[initialWindow].safeAreaInsets.bottom
        
        return bottom > 0
    }
    
    var notchSize: CGFloat {
        if UIApplication.shared.windows.count == .zero {
            return .zero
        }
        let initialWindow = 0
        let bottom = UIApplication.shared.windows[initialWindow].safeAreaInsets.bottom
        return bottom
    }
    
    func hasNotch(by window: UIWindow) -> Bool {
        let bottom = window.safeAreaInsets.bottom
        return bottom > 0
    }
    
    var isZoomed: Bool {
        return (UIScreen.main.nativeScale > UIDevice.standarScale)
    }
    
    static func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
}
