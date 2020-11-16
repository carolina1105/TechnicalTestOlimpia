//
//  LanguageCellView.swift
//  TechnicalTestOlimpia
//
//  Created by Laddy Diaz Lamus on 15/11/20.
//

import SwiftUI

struct LanguageCellView: View {
    
    let size = UIScreen.main.bounds.width * 0.275
    let border = CGFloat(1.0)
    let corner = CGFloat(10.0)
    let marging = CGFloat(4.0)
    let iconSize = UIScreen.main.bounds.width * 0.125
        
    var language: LanguageModel
    var selected: Bool
    var action: (() -> Void)
    
    init(language: LanguageModel,
         selected: Bool,
         action: @escaping (() -> Void)) {
        self.language = language
        self.selected = selected
        self.action = action
    }
    
    var body: some View {
        VStack {
            Button(action: {
                self.action()
            }, label: {
                VStack {
                    HStack {
                        Spacer()
                        CheckBoxUtility(isOn: selected,
                                        isZoomed: true)
                            .padding(.top, marging)
                            .padding(.trailing, marging)
                    }
                    Image(language.icon)
                        .renderingMode(.original)
                        .resizable()
                        .frame(width: iconSize, height: iconSize)
                        .scaledToFit()
                    HStack() {
                        HStack(alignment: .center) {
                            Text("\(language.language.localized)")
                                .font(name: FontConfig.default.robotoRegular, size: FontSizeConfig.default.text)
                                .foregroundColor(Color.secondaryText)
                        }
                    }
                }
            })
        }
        .frame(width: size, height: size)
        .overlay(
            RoundedRectangle(cornerRadius: corner)
                .stroke(Color.secondary, lineWidth: border)
                )
        .background(Color.backgroundDialog)
    }

}

struct LanguageCellView_Previews: PreviewProvider {
    static var previews: some View {
        LanguageCellView(language: LanguageModel(id: "3",
                                                 iso: "es",
                                                 key: "es",
                                                 language: "SPANISH_TITLE".localized,
                                                 icon: "Espanol"),
                         selected: true) {
            
                        }
    }
}

