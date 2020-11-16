//
//  LanguageView.swift
//  TechnicalTestOlimpia
//
//  Created by Laddy Diaz Lamus on 15/11/20.
//

import SwiftUI

struct LanguageView: View {
    
    private let height = UIScreen.main.bounds.size.height * 0.45
    private let dragClose: CGFloat = -100
    private let opacity: Double = 0.4
    private let iconSize = CGFloat(20.0)
    private let frmIconSize = CGFloat(40.0)
    private let primaryText = UIColor.primaryText
    private let corner = CGFloat(25.0)
    private let padding: CGFloat = 20
    private let duration: Double = 0.5
    
    let langKey = LanguageConfig.shared.getLanguage()
    
    @ObservedObject var languageVM = LanguageViewModel()
    @State private var txtSelectLang: String = "TEXT_SELECT_LANGUAGE".localized
    
    @State var isOpacity: Bool = false
    @Binding var isLanguage: Bool
    var didChangeLanguage: () -> Void
    
    var body: some View {
        let drag = DragGesture()
            .onEnded {
                if $0.translation.height > self.dragClose {
                    self.animateOut()
                }
            }
        return ZStack {
            if self.$isOpacity.wrappedValue {
                Color.black.opacity(self.opacity)
                    .ignoresSafeArea(.all)
            }
            VStack {
                Spacer()
                VStack {
                    HStack {
                        Spacer()
                        Text(txtSelectLang)
                            .font(name: FontConfig.default.robotoBold,
                                  size: FontSizeConfig.default.title)
                            .foregroundColor(Color.primaryText)
                        Spacer()
                    }.overlay(
                        Button(action: {
                            self.animateOut()
                        }, label: {
                            Image(systemName: "xmark")
                                .font(.system(size: iconSize))
                                .foregroundColor(Color.primaryText)
                                .frame(width: frmIconSize, height: frmIconSize)
                                .padding(.trailing)
                        }).buttonStyle(PlainButtonStyle()), alignment: .trailing)
                    .padding(.top)
                    Spacer()
                    
                    if languageVM.languages.count > .zero {
                        VStack(spacing: self.padding) {
                            HStack(spacing: self.padding) {
                                LanguageCellView(language: languageVM.languages[0],
                                                 selected: self.languageVM.isSelected(language: languageVM.languages[0], key: self.langKey),
                                                 action: {
                                                    LanguageConfig.shared.setLanguage(language: self.languageVM.languages[0])
                                                    self.didChangeLanguage()
//                                                    GlobalList.destroy()
                                                    self.animateOut()
                                                 })
                                LanguageCellView(language: languageVM.languages[1],
                                                 selected: self.languageVM.isSelected(language: languageVM.languages[1], key: self.langKey),
                                                 action: {
                                                    LanguageConfig.shared.setLanguage(language: self.languageVM.languages[1])
                                                    self.didChangeLanguage()
//                                                    GlobalList.destroy()
                                                    self.animateOut()
                                                 })
                                LanguageCellView(language: languageVM.languages[2],
                                                 selected: self.languageVM.isSelected(language: languageVM.languages[2], key: self.langKey),
                                                 action: {
                                                    LanguageConfig.shared.setLanguage(language: self.languageVM.languages[2])
                                                    self.didChangeLanguage()
//                                                    GlobalList.destroy()
                                                    self.animateOut()
                                                 })
                            }
                            HStack(spacing: self.padding) {
                                LanguageCellView(language: languageVM.languages[3],
                                                 selected: self.languageVM.isSelected(language: languageVM.languages[3], key: self.langKey),
                                                 action: {
                                                    LanguageConfig.shared.setLanguage(language: self.languageVM.languages[3])
                                                    self.didChangeLanguage()
//                                                    GlobalList.destroy()
                                                    self.animateOut()
                                                 })
                                LanguageCellView(language: languageVM.languages[4],
                                                 selected: self.languageVM.isSelected(language: languageVM.languages[4], key: self.langKey),
                                                 action: {
                                                    LanguageConfig.shared.setLanguage(language: self.languageVM.languages[4])
                                                    self.didChangeLanguage()
//                                                    GlobalList.destroy()
                                                    self.animateOut()
                                                 })
                                LanguageCellView(language: languageVM.languages[5],
                                                 selected: self.languageVM.isSelected(language: languageVM.languages[5], key: self.langKey),
                                                 action: {
                                                    LanguageConfig.shared.setLanguage(language: self.languageVM.languages[5])
                                                    self.didChangeLanguage()
//                                                    GlobalList.destroy()
                                                    self.animateOut()
                                                 })
                            }
                        }
                    }
                    Spacer()
                }
                .frame(height: height)
                .background(Color.backgroundDialog)
                .cornerRadius(radius: corner, corners: [.topLeft, .topRight])
                .edgesIgnoringSafeArea(.bottom)
                .onAppear {
                    self.animateIn()
                }
            }
        }
        .gesture(drag)
    }
    
    private func animateOut() {
        isOpacity.toggle()
        withAnimation {
            self.isLanguage.toggle()
        }
    }
    
    private func animateIn() {
        withAnimation(.easeIn(duration: duration)) {
            self.isOpacity.toggle()
        }
    }
    
}

struct LanguageView_Previews: PreviewProvider {
    static var previews: some View {
        LanguageView(isLanguage: .constant(true)) {
        }
    }
}
