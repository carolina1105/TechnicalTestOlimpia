//
//  ThemeViewModel.swift
//  TechnicalTestOlimpia
//
//  Created by Laddy Diaz Lamus on 15/11/20.
//

import SwiftUI

enum ThemeType: String {
    case systemOne = "Light Napoleon"
    case systemTwo = "Dark Napoleon"
    case darkOne = "Black Gold Alloy"
    case darkTwo = "Cold Ocean"
    case darkThree = "Camouflage"
    case lightOne = "Purple Bluebonnets"
    case lightTwo = "Pink Dream"
    case LightThree = "Clear Sky"
}

class ThemeViewModel: ObservableObject {
    
    static let shared = ThemeViewModel()
    var defaults = DefaultsConfig.shared
    var segue = SegueConfig.shared
    
    @Published var background: Color = Color.background
//    @Published var secondaryText: Color = Color.secondaryText
    @Published var primaryText: Color = Color.primaryText
    @Published var secondary: Color = Color.secondary
    @Published var fourth: Color = Color.fourth

    func isSelected(theme: String) -> Bool {
        let defTheme = defaults.get(for: DefaultsConfig.shared.keyTheme) as? String ?? "1"
        if theme == defTheme {
            return true
        }
        return false
    }
    
    func reload() {
        
//        ColorConfig.destroy()
//        UIColorConfig.destroy()
//        PinViewModel.destroy()
        background = Color.background
        primaryText = Color.primaryText
        secondary = Color.secondary
        fourth = Color.fourth
        UITableView.appearance().backgroundColor = UIColor.background
    }
    
}
