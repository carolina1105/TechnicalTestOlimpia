//
//  LanguageRepository.swift
//  TechnicalTestOlimpia
//
//  Created by Laddy Diaz Lamus on 15/11/20.
//

import Foundation

class LanguageRepository {
    
    let bundle = Bundle.main
    let langKey = "language"
    let langExt = "json"
    
    static let shared = LanguageRepository()
    
    func getLanguages() -> [LanguageModel] {
        return try! JSONDecoder().decode([LanguageModel].self, from: getLanguagesJson())
    }
    
    func getLanguagesJson() -> Data {
        let path = bundle.path(forResource: langKey, ofType: langExt)!
        return try! Data(contentsOf: URL(fileURLWithPath: path))
    }
    
}
