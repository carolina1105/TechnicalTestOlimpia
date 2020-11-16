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
    private let endPoints = Constant.default
    
    func registerUser(by request: RegisterUserReqDTO,
                      completion: @escaping (RegisterUserResDTO?, RegisterUserErrorResDTO?, Error?) -> Void) {
        let parameters = ReqDTO.toJSON(request: request)
        let url = endPoints.serverUrl + endPoints.users
        
        manager.make(url: url,
                     method: .post,
                     parameters: parameters,
                     encrypted: false,
                     success: { data in
                        let user: RegisterUserResDTO? = ResDTO.toDTO(data: data)
                        if user != nil {
                            completion(user, nil, nil)
                            return
                        }
                        let error: RegisterUserErrorResDTO? = ResDTO.toDTO(data: data)
                        completion(nil, error, nil)
                     }) { data, error in
            completion(nil, nil, error)
        }
    }
//    func registerUser(by request: RegisterUserReqDTO,
//                      completion: @escaping (RegisterUserResDTO?, RegisterUserErrorResDTO?, ErrorDTO?) -> Void) {
//        let url = endPoints.serverUrl + endPoints.users
//        manager.make(url: url,
//                     method: .post,
//                     parameters: request,
//                     encrypted: false,
//                     completion: completion)
//    }
    
//    func signInGoogle(by request: SignInGoogleReqDTO,
//                      completion: @escaping (RegisterUserResDTO?, RegisterUserErrorResDTO?, ErrorDTO?) -> Void) {
//        let parameters = ReqDTO.toJSON(request: request)
//        let url = endPoints.serverUrl + endPoints.userSignInGoogle
//        
//        manager.make(url: url,
//                     method: .post,
//                     parameters: parameters,
//                     encrypted: false,
//                     success: { data in
//                        let user: RegisterUserResDTO? = ResDTO.toDTO(data: data)
//                        if user != nil {
//                            completion(user, nil, nil)
//                            return
//                        }
//                        let error: RegisterUserErrorResDTO? = ResDTO.toDTO(data: data)
//                        completion(nil, error, nil)
//                     }) { data, error in
//            completion(nil, nil, error)
//        }
//    }
}
