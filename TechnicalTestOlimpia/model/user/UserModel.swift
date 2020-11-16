//
//  UserModel.swift
//  TechnicalTestOlimpia
//
//  Created by Laddy Diaz Lamus on 14/11/20.
//

import Firebase

struct UserModel: Codable {
    
//    static let empty = ""
    
    var id: Int64
    var name: String
    var identification: Int
    var address: String
    var avatar: String
    var city: String
    var country: String
    var cellphone: String
    var geolocation: String
    
    
    init(id: Int64 = 0,
         name: String = "",
         identification: Int = 0,
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
    
    
//    static func toModel(dto: RegisterUserResDTO) -> UserModel {
//        let model = UserModel(id: dto.id ?? 0,
//                              firebaseId: empty,
//                              nickname: dto.nickname ?? empty,
//                              name: dto.name ?? empty,
//                              avatar: empty,
//                              language: dto.language ?? empty,
//                              pin: dto.pin ?? empty,
//                              confirm: dto.confirm ?? empty,
//                              state: empty,
//                              status: dto.status ?? empty,
//                              lastseen: 0,
//                              secretKey: dto.secretKey,
//                              created: dto.created,
//                              type: dto.type)
//        return model
//    }
//    
//    static func toModel(dto: UpdateInfoUserResDTO) -> UserModel {
//        let model = UserModel(id: 0,
//                              firebaseId: empty,
//                              nickname: empty,
//                              name: dto.name ?? empty,
//                              avatar: dto.avatar ?? empty,
//                              language: empty,
//                              pin: empty,
//                              confirm: empty,
//                              state: dto.state ?? empty,
//                              status: dto.status ?? empty,
//                              lastseen: dto.lastseen ?? 0)
//        return model
//    }
    
    func toDTO(model: UserModel) -> RegisterUserReqDTO {
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
                             identification: .zero, 
                             address: "", 
                             avatar: "", 
                             city: "", 
                             country: "", 
                             cellphone: "", 
                             geolocation: "")
}
