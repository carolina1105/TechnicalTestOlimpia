//
//  Constant.swift
//  TechnicalTestOlimpia
//
//  Created by Laddy Diaz Lamus on 14/11/20.
//

import Foundation

fileprivate let defServerUrl                   = "http://localhost:8000"

// Request Configurations
fileprivate let defLanguageIso                 = "languageIso"
fileprivate let defApiAuthKey                  = "X-API-Key"

// End-points
fileprivate let defUsers                       = "/user/get"
fileprivate let defRegisterUser                = "/user/add"


//KeyDisplayNameKey
struct Constant {
    let serverUrl                   : String
    let languageIso                 : String
    let apiAuthKey                  : String
    let users                       : String
    let registerUser                : String


    static let `default` = Constant(serverUrl                   : defServerUrl,
                                    languageIso                 : defLanguageIso,
                                    apiAuthKey                  : defApiAuthKey,
                                    users                       : defUsers,
                                    registerUser                : defRegisterUser)
}
