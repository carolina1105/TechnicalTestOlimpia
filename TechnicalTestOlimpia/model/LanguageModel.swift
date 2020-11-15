//
//  LanguageModel.swift
//  TechnicalTestOlimpia
//
//  Created by Laddy Diaz Lamus on 14/11/20.
//

import SwiftUI

struct LanguageModel: Identifiable, Codable {
    var id: String
    var iso: String
    var key: String
    var language: String
    var icon: String
    
    init(id: String,
         iso: String,
         key: String,
         language: String,
         icon: String) {
        self.id = id
        self.iso = iso
        self.key = key
        self.language = language
        self.icon = icon
    }
    
}
