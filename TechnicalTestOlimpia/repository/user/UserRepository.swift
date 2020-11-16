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
    private let avatarKey = "avatar"
    private let filename: String = "%ld.jpeg"
    
    private var manager = UserWS.shared
    private var errorUtility = ErrorUtility.shared
    private var defaults = DefaultsConfig.shared
    private var segue = SegueConfig.shared
    
    lazy var firebaseId: String = ""
    
    func registerUser(user: UserModel,
                      success: @escaping () -> Void,
                      failure: @escaping (String) -> Void) {
        let request: RegisterUserReqDTO = user.toDTO(model: user)
//        let iso: String = languageConfig.getLanguageId(iso: self.defaults.get(for: self.defaults.keyLanguage) as! String)
//        request.languageId = iso
        manager.registerUser(by: request) { userRes, userError, error in
            if error != nil {
//                failure(error!.error)
                return
            }
            if userRes != nil {
                self.defaults.set(value: "", for: self.defaults.keyIsLoginGoogle)
//                self.defaults.token = TokenModel.toModel(dto: userRes!)
//                self.defaults.user = UserModel.toModel(dto: userRes!)
//                KeychainConfig.shared.set(value: user.password!, for: self.defaults.keyNapoleon)
//                self.setLastRefreshTokenTime()
                success()
                return
            }
            let errors = try? userError!.allValuesRegisterUser()
            let message = self.errorUtility.getMessage(by: errors!)
            failure(message)
        }
    }
    
    func signInGoogle(user: UserModel,
                      success: @escaping () -> Void,
                      failure: @escaping (String) -> Void) {
//        var request: SignInGoogleReqDTO = user.toDTO(model: user)
//        let iso: String = languageConfig.getLanguageId(iso: self.defaults.get(for: self.defaults.keyLanguage) as! String)
//        request.languageId = iso
//        manager.signInGoogle(by: request) { userRes, userError, error in
//            if error != nil {
//                failure(error!.error)
//                return
//            }
//            if userRes != nil {
//                self.defaults.set(value: "X", for: self.defaults.keyIsLoginGoogle)
//                self.defaults.set(value: self.defaults.user?.googleToken ?? "", for: self.defaults.keyGoogleToken)
//                self.defaults.token = TokenModel.toModel(dto: userRes!)
//                self.defaults.user = UserModel.toModel(dto: userRes!)
//                self.setLastRefreshTokenTime()
//                success()
//                return
//            }
//            let errors = try? userError!.allValuesRegisterUser()
//            let message = self.errorUtility.getMessage(by: errors!)
//            failure(message)
//        }
    }
}
