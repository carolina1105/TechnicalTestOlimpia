//
//  ResultResDTO.swift
//  TechnicalTestOlimpia
//
//  Created by Laddy Diaz Lamus on 14/11/20.
//

import Foundation

struct ResultResDTO: Codable {
    var result: Bool
    private enum CodingKeys: String, CodingKey {
        case result = "success"
    }
}
