//
//  UserDataViewModel.swift
//  TechnicalTestOlimpia
//
//  Created by Laddy Diaz Lamus on 15/11/20.
//

import Foundation
import SwiftUI

class UserDataViewModel: ObservableObject {
    static let shared = UserDataViewModel()
    
    var count = 0
    var repository = UserRepository.shared
    private var nextPage: Int = 0  
    @Published var activeSection: Int? = nil
    @Published var user: UserModel = .empty
    @Published var users: [UserModel] = [.empty]
    @Published var name: String = "" {
        didSet {
            user.name = self.name
        }
    }
    @Published var identification: String = "" {
        didSet {
            user.identification = self.identification
        }
    }
    @Published var address: String = "" {
        didSet {
            user.address = self.address
        }
    }
    @Published var city: String = "" {
        didSet {
            user.city = self.city
        }
    }
    @Published var country: String = "" {
        didSet {
            user.country = self.country
        }
    }
    @Published var avatar: String = "" {
        didSet {
            user.avatar = self.avatar
        }
    }
    @Published var geolocation: String = "" {
        didSet {
            user.geolocation = self.geolocation
        }
    }
    @Published var cellphone: String = "" {
        didSet {
            user.cellphone = self.cellphone
        }
    }
    @Published var showAlert: Bool = false
    @Published var messageAlert: String = ""
    @Published var titleMessage: String = ""
    
    func getUser() {
        users = []
        repository.getUser { users in
            print("User count.. \(users.count)")
            self.users = users
        } failure: { message in
            self.showAlert = true
            self.titleMessage = "TEXT_ALERT_FAILURE".localized
            self.messageAlert = message
        }
    }
    
    func registerUser() {
        self.user.id = Int64(Double.random(in: 1...100))
        if validData(user: self.user) {
            repository.registerUser(user: .empty) { 
                print("succes Register")
                self.showAlert = true
                self.titleMessage = "TEXT_ALERT_SUCCESS".localized
                self.messageAlert = "TEXT_REQUEST_SUCCESS".localized
                self.cleanData()
            } failure: { message in
                self.showAlert = true
                self.titleMessage = "TEXT_ALERT_FAILURE".localized
                self.messageAlert = message
                
            }
        }  else {
            showAlert = true
            titleMessage = "TEXT_ALERT_FAILURE".localized
            messageAlert = "TEXT_ALERT_REGISTER".localized
        }
    }
    
    func validData(user: UserModel) -> Bool {
        return user.name == "" || user.identification == "" || user.address == "" || user.city == "" || user.country == "" || user.cellphone == "" || user.avatar == "" || user.geolocation == "" ? false : true
    }
    
    func cleanData() {
        self.user = .empty
        self.name = ""
        self.identification = ""
        self.address = ""
        self.city = ""
        self.country = ""
        self.avatar = ""
        self.geolocation = ""
        self.cellphone = ""
    }
}
