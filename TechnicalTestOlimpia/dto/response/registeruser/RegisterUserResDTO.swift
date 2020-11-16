//
//  RegisterUserResDTO.swift
//  TechnicalTestOlimpia
//
//  Created by Laddy Diaz Lamus on 16/11/20.
//

import Foundation

struct RegisterUserResDTO: Codable {
    var id: Int64
    var name: String
    var identification: Int
    var address: String
    var avatar: String
    var city: String
    var country: String
    var cellphone: String
    var geolocation: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name 
        case identification 
        case address 
        case avatar
        case city
        case country
        case cellphone 
        case geolocation
    }
}

struct RegisterUserErrorResDTO: Codable {
    var pinErrors: [String]?
    var nickErrors: [String]?
    var nameErrors: [String]?
    var languageErrors: [String]?
    var idErrors: [String]?
    
    private enum CodingKeys: String, CodingKey {
        case pinErrors = "password"
        case nickErrors = "nick"
        case nameErrors = "fullname"
        case languageErrors = "language_iso"
        case idErrors = "firebase_id"
    }
}

extension RegisterUserErrorResDTO {
    func allValuesRegisterUser() throws -> [String] {

        var result: [String] = []

        let mirror = Mirror(reflecting: self)

        guard let style = mirror.displayStyle, style == .struct || style == .class else {
            throw NSError()
        }

        for (_, value) in mirror.children {
            guard let value = value as? [String] else {
                continue
            }
            result.append(contentsOf: value)
        }

        return result
    }
}
