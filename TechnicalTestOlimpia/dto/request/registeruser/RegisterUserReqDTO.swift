//
//  RegisterUserResDTO.swift
//  TechnicalTestOlimpia
//
//  Created by Laddy Diaz Lamus on 14/11/20.
//

import Foundation

struct RegisterUserReqDTO: Codable {
    var id: Int64
    var name: String
    var identification: String
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
