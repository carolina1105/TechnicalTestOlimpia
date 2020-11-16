//
//  AppearanceSettingsViewModel.swift
//  TechnicalTestOlimpia
//
//  Created by Laddy Diaz Lamus on 15/11/20.
//

import SwiftUI

class AppearanceSettingsViewModel: ObservableObject {
    
    static let shared = AppearanceSettingsViewModel()
    
    let lightTheme = "1"

    var languageRepository = LanguageRepository.shared
    var userRepository = UserRepository.shared
    var defaults = DefaultsConfig.shared
    let fileManager = FileManager.default
    let segue = SegueConfig.shared
    
    @Published var title: String = ""
    @Published var theme: String = ""
    @Published var language: String = ""
    @Published var isBackground: Bool = false

    func load() {
        title = "TEXT_APPEARANCE_SETTINGS_TITLE".localized
        loadTheme()
        loadLanguage()
    }
    
    func loadTheme() {
        let defTheme = defaults.get(for: DefaultsConfig.shared.keyTheme) as? String ?? lightTheme
        
        switch defTheme {
        case ThemeAppType.systemOne.rawValue:
            theme = ThemeType.systemOne.rawValue
        case ThemeAppType.systemTwo.rawValue:
            theme = ThemeType.systemTwo.rawValue
        case ThemeAppType.darkOne.rawValue:
            theme = ThemeType.darkOne.rawValue
        case ThemeAppType.darkTwo.rawValue:
            theme = ThemeType.darkTwo.rawValue
        case ThemeAppType.darkThree.rawValue:
            theme = ThemeType.darkThree.rawValue
        case ThemeAppType.lightOne.rawValue:
            theme = ThemeType.lightOne.rawValue
        case ThemeAppType.lightTwo.rawValue:
            theme = ThemeType.lightTwo.rawValue
        case ThemeAppType.LightThree.rawValue:
            theme = ThemeType.LightThree.rawValue
        default:
            theme = ThemeType.systemOne.rawValue
        }
    }
    
    func loadLanguage() {
        let langKey = LanguageConfig.shared.getLanguage()
        let languages = languageRepository.getLanguages()
        for lang in languages {
            if lang.key == langKey {
                language = lang.language.localized
                return
            }
        }
    }

    func updateLanguage() {
        let language = defaults.get(for: defaults.keyLanguage) as? String ?? LanguageConfig.shared.languageDefault
//        var info = userRepository.user()
//        info.language = language
//        userRepository.updateInfo(user: info,
//                                  success: {
//        }) { message in
//            print(message)
//        }
    }
}

