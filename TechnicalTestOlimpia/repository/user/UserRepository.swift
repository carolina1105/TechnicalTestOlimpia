//
//  UserRepository.swift
//  TechnicalTestOlimpia
//
//  Created by Laddy Diaz Lamus on 14/11/20.
//

import Foundation
import Firebase

class UserRepository {
    
    static let shared = UserRepository()
    private let error403: Int = 403
    private let error401: Int = 401
    private let addDay: Int = 1
    private let languageConfig = LanguageConfig.shared    
    private var manager = UserWS.shared
    private var errorUtility = ErrorUtility.shared
    private var defaults = DefaultsConfig.shared
    private var segue = SegueConfig.shared
    
    lazy var firebaseId: String = ""
    
    func getUser(success: @escaping ([UserModel]) -> Void,
                      failure: @escaping (String) -> Void) {

        manager.getUser() { userRes, userError, error in
            if error != nil {
                failure(userError.debugDescription)
                return
            }
            if userRes.count > 0 {
                var users: [UserModel] = []
                for dto in userRes {
                    let user = UserModel.toModel(dto: dto)
                    users.append(user)
                }
                success(users)
                return
            }
            failure("error")
        }
    }
    
    func registerUser(user: UserModel,
                      success: @escaping () -> Void,
                      failure: @escaping (String) -> Void) {
        let request: RegisterUserReqDTO = UserModel.toReqDTO(model: user)

        manager.registerUser(by: request) { userRes, userError, error in
            if error != nil {
                failure(userError.debugDescription)
                return
            }
            if userRes {
                success()
                return
            }
            failure("ERROR")
        }
    }
}
