//
//  ColorConfig.swift
//  TechnicalTestOlimpia
//
//  Created by Laddy Diaz Lamus on 14/11/20.
//

import SwiftUI
import UIKit

extension Color {
    static let background = Color("Background")
    static let backgroundLight = Color("BackgroundLight")
    static let backgroundDialog = Color("BackgroundDialog")
    static let fourth = Color("Fourth")
    static let icon = Color("Icon")
    static let iconDark = Color("IconDark")
    static let iconLight = Color("IconLight")
    static let primary = Color("Primary")
    static let primaryDark = Color("PrimaryDark")
    static let primaryLight = Color("PrimaryLight")
    static let primaryText = Color("PrimaryText")
    static let secondary = Color("Secondary")
    static let secondaryDark = Color("SecondaryDark")
    static let secondaryLight = Color("SecondaryLight")
    static let secondaryText = Color("SecondaryText")
    static let section = Color("Section")
    static let third = Color("Third")
    static let tint = Color("Tint")
    static let pause = Color("Paused")
}

extension UIColor {
    static let background = UIColor(named: "Background")
    static let backgroundLight = UIColor(named: "BackgroundLight")
    static let backgroundDialog = UIColor(named: "BackgroundDialog")
    static let fourth = UIColor(named: "Fourth")
    static let icon = UIColor(named: "Icon")
    static let iconDark = UIColor(named: "IconDark")
    static let iconLight = UIColor(named: "IconLight")
    static let primary = UIColor(named: "Primary")
    static let primaryDark = UIColor(named: "PrimaryDark")
    static let primaryLight = UIColor(named: "PrimaryLight")
    static let primaryText = UIColor(named: "PrimaryText")
    static let secondary = UIColor(named: "Secondary")
    static let secondaryDark = UIColor(named: "SecondaryDark")
    static let secondaryLight = UIColor(named: "SecondaryLight")
    static let secondaryText = UIColor(named: "SecondaryText")
    static let section = UIColor(named: "Section")
    static let third = UIColor(named: "Third")
    static let tint = UIColor(named: "Tint")
    static let pause = Color("Paused")
}


enum ThemeAppType: String {
    case systemOne = "1"
    case systemTwo = "2"
    case darkOne = "3"
    case darkTwo = "6"
    case darkThree = "7"
    case lightOne = "4"
    case lightTwo = "5"
    case LightThree = "8"
}

struct AppTheme {
    
    private static let theme = "Theme"
    private static let deftheme = "1"
    
    static func getTheme() -> String {
        let defaults = DefaultsConfig.shared
        let theme = defaults.get(for: AppTheme.theme) as? String ?? AppTheme.deftheme
        return "-" + theme
    }
    
}
