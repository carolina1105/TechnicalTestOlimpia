//
//  ReqDTO.swift
//  TechnicalTestOlimpia
//
//  Created by Laddy Diaz Lamus on 14/11/20.
//

import Foundation
import UIKit

struct ReqDTO: Codable {
    static func toJSON<T: Codable>(request: T) -> [String : Any]? {
        do {
            let encoder = JSONEncoder()
            let json = try encoder.encode(request, options: .allowFragments)
            return (json as! [String : Any])
        } catch {
            return nil
        }
    }
}
