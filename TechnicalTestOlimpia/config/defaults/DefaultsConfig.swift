//
//  DefaultsConfig.swift
//  TechnicalTestOlimpia
//
//  Created by Laddy Diaz Lamus on 14/11/20.
//

import Foundation

let dateRefreshKey = "DateRefresh"
class DefaultsConfig {
    
    static let shared = DefaultsConfig()
    
    let keyFirebaseId            : String = "FirebaseId"
    
    let keyTheme                 : String = "Theme"
    let keyLanguage              : String = "NapoleonLanguage"
    let keyThemeType                    : String = "ThemeType"

    let keyUser                  : String = "user"
    let keyToken                 : String = "token"
    let keyNapoleon              : String = "Napoleon"
    let keyGoogleToken           : String = "GoogleToken"
    let keyIsLoginGoogle         : String = "IsLoginGoogle"
    let keyDateRefresh           : String = "DateRefresh"
    
    // Appearance
    let KeyTimeFormat            : String = "TimeFormat"
    
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
