//
//  ErrorDTO.swift
//  TechnicalTestOlimpia
//
//  Created by Laddy Diaz Lamus on 14/11/20.
//

import Foundation

struct ErrorDTO: Codable {
    
    var error: String
    var code: Int?
    
    static func toDTO(data: Data?) -> ErrorDTO? {
        do {
            if data!.count > 0 {
                let decoder = JSONDecoder()
                return try decoder.decode(ErrorDTO.self, from: data!)
            }else{
                return ErrorDTO(error: "TEXT_ERROR_CONNECTION".localized)
            }
            
        } catch {
            print(error)
            return nil
        }
    }
    
}

