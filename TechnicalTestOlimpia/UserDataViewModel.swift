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
    @Published var name: String = "" {
        didSet {
            user.name = self.name
        }
    }
    @Published var identification: Int = 0 {
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
            user.cellphone = self.geolocation
        }
    }
    @Published var showAlert: Bool = false
    @Published var messageAlert: String = ""
    @Published var titleMessage: String = ""

    func registerUser() {
//        isLoading = true

    }
    
}
