//
//  BundleExtension.swift
//  TechnicalTestOlimpia
//
//  Created by Laddy Diaz Lamus on 14/11/20.
//

import Foundation

extension Bundle {
    var versionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
    var versionNumberPretty: String {
        return "v\(versionNumber ?? "1.0.0")"
    }
}

extension Bundle {
    func readJSON<T: Codable>(fileName: String) -> T {
        guard let url = self.url(forResource: fileName, withExtension: "json") else {
            fatalError("\(fileName) could not be loaded!")
        }
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(fileName) from bundle")
        }
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "y-MM-dd"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        guard let decodedData = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode \(fileName) from bundle")
        }
        return decodedData
    }
}
