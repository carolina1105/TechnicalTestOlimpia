//
//  ContentViewModel.swift
//  TechnicalTestOlimpia
//
//  Created by Laddy Diaz Lamus on 16/11/20.
//

import Foundation
import SwiftUI
import Firebase

class ContentViewModel: ObservableObject {
        
    var defaults = DefaultsConfig.shared
    
    init() {
        SegueConfig.shared.window = UIApplication.shared.windows.first
        selectTheme()
    }
    
    func selectTheme() {
        let darkTheme = 2
        guard let window = SegueConfig.shared.window else {
                    return
                }
                guard let type = defaults.get(for: defaults.keyThemeType) as? Int else {
                    window.overrideUserInterfaceStyle = .light
                    return
                }
                switch type {
                case darkTheme:
                    window.overrideUserInterfaceStyle = .dark
                default:
                    window.overrideUserInterfaceStyle = .light
                }
    }
}
