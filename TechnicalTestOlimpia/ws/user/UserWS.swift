//
//  UserWS.swift
//  TechnicalTestOlimpia
//
//  Created by Laddy Diaz Lamus on 14/11/20.
//

import Foundation

class UserWS {
    
    static let shared = UserWS()
    private let manager = ManagerWS.shared
    private let manager2 = ManagerWS.shared

    private let endPoints = Constant.default
    
    func getUser(completion: @escaping ([RegisterUserResDTO], RegisterUserErrorResDTO?, Error?) -> Void) {
        let url = endPoints.serverUrl + endPoints.users
        
        manager.make(url: url,
                     method: .get,
                     encrypted: false,
                     success: { data in
                        let user: [RegisterUserResDTO] = ResDTO.toDTO(data: data)
                        if user.count > .zero {
                            completion(user, nil, nil)
                            return
                        }
                        let error: RegisterUserErrorResDTO? = ResDTO.toDTO(data: data)
                        completion([], error, nil)
                     }) { data, error in
            completion([], nil, error)
        }
    }
    
    func registerUser(by request: RegisterUserReqDTO,
                      completion: @escaping (Bool, RegisterUserErrorResDTO?, Error?) -> Void) {
        
        let parameters = ReqDTO.toJSON(request: request)
        let url = endPoints.serverUrl + endPoints.registerUser
        
        manager.make(url: url,
                     method: .post,
                     parameters: parameters,
                     encrypted: false,
                     success: { data in
                        completion(true, nil, nil)
                     }) { data, error in
            completion(false, nil, error)
        }
    }
}
