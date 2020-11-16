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
    @Published var user: UserModel = .empty
    var repository = UserRepository.shared
//    var repositoryPokemonDetail = PokemonDetailRepository.shared
    private var nextPage: Int = 0    
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
//    @Published var pokemon: [PokemonModel] = []
//    @Published var isLoading: Bool = false
//    @Published var activeSection: Int? = nil
//    @Published var namePokemon: String = ""
//    @Published var pokemonDetail: PokemonDetailModel = .empty
    @Published var showAlert: Bool = false
    @Published var messageAlert: String = ""
    @Published var titleMessage: String = ""

    func pokemonList() {
//        isLoading = true
//        pokemon = []
//        repository.pokemonList(page: nil) { data in
//            for row in data.results {
//                self.count = self.count + 1
//                self.poke.append(PokemonModel(id: self.count, name: row.name , url: row.url))
//            }
//            self.pokemon.append(contentsOf: self.poke)
//            self.nextPage = self.charArray(text: data.next) 
//            self.isLoading = false
//        } failure: { error in
//            self.isLoading = false
//            self.showAlert = true
//            self.titleMessage = "Advertencia"
//            self.messageAlert = "Se ha producido un error"
//        }
    }
    
    func getPokemonByPage()  {

    }
    
    func charArray(text: String) -> Int {
        let array =  text.components(separatedBy: "=")
        let array2 = array[1].components(separatedBy: "&")
        return Int(array2[0]) ?? .zero
    } 
    
    func pokemonDetail(success: @escaping () -> Void) {
       
    }
}
