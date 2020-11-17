//
//  DefaultsConfig.swift
//  TechnicalTestOlimpia
//
//  Created by Laddy Diaz Lamus on 14/11/20.
//

import Foundation

class DefaultsConfig {
    
    static let shared = DefaultsConfig()
    
    let keyFirebaseId            : String = "FirebaseId"
    
    let keyTheme                 : String = "Theme"
    let keyLanguage              : String = "OlimpiaLanguage"
    let keyThemeType             : String = "ThemeType"
    
    func set(value: Any, for key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    func get(for key: String) -> Any? {
        UserDefaults.standard.value(forKey: key)
    }
    
    func delete(for key: String) -> Any? {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
