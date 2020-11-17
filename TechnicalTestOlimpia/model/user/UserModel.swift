//
//  UserModel.swift
//  TechnicalTestOlimpia
//
//  Created by Laddy Diaz Lamus on 14/11/20.
//

import Firebase

struct UserModel: Codable, Identifiable {
        
    var id: Int64
    var name: String
    var identification: String
    var address: String
    var avatar: String
    var city: String
    var country: String
    var cellphone: String
    var geolocation: String
    
    
    init(id: Int64 = 0,
         name: String = "",
         identification: String = "",
         address: String = "",
         avatar: String = "",
         city: String = "",
         country: String = "",
         cellphone: String = "",
         geolocation: String = "") {
        self.id = id
        self.name = name
        self.identification = identification
        self.address = address
        self.avatar = avatar
        self.city = city
        self.country = country
        self.cellphone = cellphone
        self.geolocation  = geolocation
    }
    
    
    static func toModel(dto: RegisterUserResDTO) -> UserModel {
        let model = UserModel(id: dto.id ?? .zero, 
                              name: dto.name, 
                              identification: dto.identification, 
                              address: dto.address, 
                              avatar: dto.avatar, 
                              city: dto.city, 
                              country: dto.country, 
                              cellphone: dto.cellphone, 
                              geolocation: dto.geolocation)
        return model
    }
    
    static func toModels(dto: [RegisterUserResDTO]) -> [UserModel] {
        return dto.map {
            toModel(dto: $0)
        }
    }
    
    static func toReqDTO(model: UserModel) -> RegisterUserReqDTO {
        let request = RegisterUserReqDTO(id: model.id , 
                                         name: model.name , 
                                         identification: model.identification , 
                                         address: model.address , 
                                         avatar: model.avatar , 
                                         city: model.city , 
                                         country: model.country , 
                                         cellphone: model.cellphone , 
                                         geolocation: model.geolocation )
        return request
    }
    
}

extension UserModel {
    static var empty = UserModel(id: .zero, 
                             name: "", 
                             identification: "", 
                             address: "", 
                             avatar: "", 
                             city: "", 
                             country: "", 
                             cellphone: "", 
                             geolocation: "")
}
