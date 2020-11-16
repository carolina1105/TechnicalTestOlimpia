//
//  SettingCellView.swift
//  TechnicalTestOlimpia
//
//  Created by Laddy Diaz Lamus on 15/11/20.
//

import SwiftUI

struct SettingCellView: View {
    
    var systemIcon: String = ""
    var icon: String = ""
    let text: String
    let textTint: String
    let spacerLine: Bool
    let iconAction: String
    let spacingHStack: CGFloat = 18
    let spacingVStack: CGFloat = 5
    let widthText: CGFloat = 0.64
    let widthIcon: CGFloat = 0.18
    let colorPlaceholder: UIColor = .lightGray
    var action: () -> Void
    
    var body: some View {
        
        Button(action: {
            self.action()
        }) {
            VStack(spacing: .zero) {
                HStack(alignment: .center, spacing: .zero) {
                    if icon != "" {
                    Image(systemName: self.icon)
                        .font(name: FontConfig.default.robotoBold,
                              size: FontSizeConfig.default.title)
                        .foregroundColor(Color.icon)
                        .frame(width: 40)
                        .padding(.horizontal, 10)
                    } else {
                        Image(self.systemIcon)
                            .renderingMode(.template)
                            .font(name: FontConfig.default.robotoBold,
                                  size: FontSizeConfig.default.title)
                            .foregroundColor(Color.icon)
                            .frame(width: 40)
                            .padding(.horizontal, 10)
                    }
                    VStack(alignment: .leading, spacing: self.spacingVStack) {
                        Text(self.text)
                            .font(name: FontConfig.default.robotoBold,
                                  size: FontSizeConfig.default.text)
                            .foregroundColor(Color.primaryText)
                            .fixedSize(horizontal: false, vertical: true)
                        if !self.textTint.isEmpty {
                            Text(self.textTint)
                                .font(name: FontConfig.default.robotoRegular,
                                      size: FontSizeConfig.default.text)
                                .foregroundColor(self.textTint != "TEXT_DISPLAY_NAME".localized ? Color.tint : Color(colorPlaceholder))
                        }
                    }.frame(minHeight: 50)
                    .padding(.vertical, 15)
                    Spacer()
                    Image(systemName: self.iconAction)
                        .font(name: FontConfig.default.robotoBold,
                              size: FontSizeConfig.default.title)
                        .foregroundColor(Color.icon)
                        .frame(width: 40)
                        .padding(.horizontal, 10)
                }
                if spacerLine {
                    Divider()
                }
            }
            .background(Color.background)
        }
    }
}

struct SettingCellView_Previews: PreviewProvider {
    static var previews: some View {
        SettingCellView(icon: "person",
                       text: "algo para mostrar dsdsdsdsd sdsdsd sdsdsd sdsd ssds sdsd sdsd sdsds sdsd",
                       textTint: "texto secundario",
                       spacerLine: true,
                       iconAction: "pencil", action: {
                        
        })
    }
}

