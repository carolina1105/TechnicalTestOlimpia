//
//  StringExtension.swift
//  TechnicalTestOlimpia
//
//  Created by Laddy Diaz Lamus on 14/11/20.
//

import Foundation
import LanguagesManager

extension String {
    
    static let empty = ""
    
    var localized: String {
        return LanguagesManager.sharedInstance().localizedString(forKey: self, value: "")
    }
    
    var localizedLanguageDevice: String {
        return NSLocalizedString(self, comment: "")
    }
    
    // this function is used to get the Localizable.strings when they have extra parameters
    func localizeWith(arguments: CVarArg...) -> String {
        let localizedValue = self.localized
        return String(format: localizedValue, arguments: arguments)
    }
    
    func height(by width: CGFloat,
                font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(by height: CGFloat,
               font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
}

extension String {
    func appendingPathComponent(_ string: String) -> String {
        return URL(fileURLWithPath: self).appendingPathComponent(string).path
    }
}
