//
//  TextFieldStyle.swift
//  TechnicalTestOlimpia
//
//  Created by Laddy Diaz Lamus on 13/11/20.
//

import SwiftUI

enum TextFieldStatusType {
    case `default`
    case error
    case success
}

struct CustomTextFieldStyle: TextFieldStyle {

    let padding: CGFloat = 10
    let cornerRadius: CGFloat = 6
    let lineWidth: CGFloat = 1

    var status: TextFieldStatusType = .default
    func _body(configuration: TextField<_Label>) -> some View {
        configuration
            .padding(padding)
            .background(RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(getColor(), lineWidth: lineWidth))
            .textFont()
    }
    
    func getColor() -> Color {
        switch status {
        case .error:
             return Color.nThird
        case .success:
            return Color.nFourth
        default:
            return Color.nSecondaryDark
        }
    }
}
