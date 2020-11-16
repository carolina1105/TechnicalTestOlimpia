//
//  CheckBoxUtility.swift
//  TechnicalTestOlimpia
//
//  Created by Laddy Diaz Lamus on 15/11/20.
//

import SwiftUI

struct CheckBoxUtility: View {
    var isOn: Bool = false
    var isZoomed: Bool = false
    var colorOn: Color = Color.tint
    
    var body: some View {
        ZStack {
            if isOn {
                if isZoomed {
                    CheckBoxOnZoomed(colorOn: colorOn)
                } else {
                    CheckBoxOn(colorOn: colorOn)
                }
            } else {
                CheckBoxOff()
            }
        }
    }
}

struct CheckBoxOnZoomed: View {
    var colorOn: Color = Color.tint
    let dimension: CGFloat = 22
    
    var body: some View {
        return Image(systemName: "checkmark.circle.fill")
            .renderingMode(.template)
            .foregroundColor(colorOn)
            .font(name: FontConfig.default.robotoRegular,
                  size: dimension)
            .scaledToFit()
    }
}

struct CheckBoxOn: View {
    var colorOn: Color = Color.tint
    
    var body: some View {
        return Image(systemName: "checkmark.circle.fill")
            .renderingMode(.template)
            .foregroundColor(colorOn)
    }
}

struct CheckBoxOff: View {
    var body: some View {
        return Image(systemName: "circle")
            .renderingMode(.template)
            .foregroundColor(Color.secondary)
    }
}
