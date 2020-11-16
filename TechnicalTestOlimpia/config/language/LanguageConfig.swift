//
//  LanguageConfig.swift
//  TechnicalTestOlimpia
//
//  Created by Laddy Diaz Lamus on 14/11/20.
//

import Foundation
import LanguagesManager

class LanguageConfig {
    
    static let shared = LanguageConfig()
    let languageDefault = "es"
    
    var language: [LanguageModel] = Bundle.main.readJSON(fileName: "language")
    
    lazy var manager: LanguagesManager = {
        return LanguagesManager.sharedInstance()
    }()
    
    lazy var defaults: DefaultsConfig = {
        return DefaultsConfig.shared
    }()
    
    func checkDefault() {
        let `default` = getLanguage()
        let model = language.first { $0.key == `default` }
        guard let selected = model else {
            defaults.set(value: languageDefault, for: defaults.keyLanguage)
            manager.setLanguage(languageDefault)
            return
        }
        defaults.set(value: selected.iso, for: defaults.keyLanguage)
    }
    
    func getLanguage() -> String {
        guard let `default` = manager.getDefaultLanguage() else {
            return languageDefault
        }
        return `default`
    }
    
    func setLanguage(language: LanguageModel) {
        manager.setLanguage(language.key)
        defaults.set(value: language.iso, for: defaults.keyLanguage)
    }
    
}
