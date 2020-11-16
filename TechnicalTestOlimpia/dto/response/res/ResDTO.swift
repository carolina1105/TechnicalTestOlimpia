//
//  ResDTO.swift
//  TechnicalTestOlimpia
//
//  Created by Laddy Diaz Lamus on 14/11/20.
//

import Foundation

struct ResDTO: Codable {
    static func toDTO<T: Codable>(data: Data?) -> T? {
        guard let data = data else { return nil }
        
        do {
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(T.self, from: data)
            
            return decodedData
        } catch {
            print(error)
            print("Failed to decode \(T.self) from ToDTO")
            return nil
        }
    }
    
    static func toDTO<T: Codable>(data: Data?) -> [T] {
        guard let dto = toDTO(data: data) as [T]? else {
            return []
        }
        
        return dto
    }
}
