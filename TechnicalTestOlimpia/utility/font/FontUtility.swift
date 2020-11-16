//
//  FontUtility.swift
//  TechnicalTestOlimpia
//
//  Created by Laddy Diaz Lamus on 13/11/20.
//

import Foundation
import SwiftUI

struct FontUtility: ViewModifier {
    @Environment(\.sizeCategory) var sizeCategory
    var name: String
    var size: CGFloat

    func body(content: Content) -> some View {
        let scaledSize = UIFontMetrics.default.scaledValue(for: size)
        return content.font(.custom(name, size: scaledSize))
    }
}

@available(iOS 13, macCatalyst 13, tvOS 13, watchOS 6, *)
extension View {
    func font(name: String, size: CGFloat) -> some View {
        return self.modifier(FontUtility(name: name, size: size))
    }
}
