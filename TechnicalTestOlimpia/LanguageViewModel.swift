//
//  LanguageViewModel.swift
//  TechnicalTestOlimpia
//
//  Created by Laddy Diaz Lamus on 15/11/20.
//

import SwiftUI

class LanguageViewModel: ObservableObject {

    @Published var languages: [LanguageModel] = Bundle.main.readJSON(fileName: "language")
    
    func isSelected(language: LanguageModel, key: String) -> Bool {
        if language.key == key {
            return true
        }
        return false
    }
    
}
