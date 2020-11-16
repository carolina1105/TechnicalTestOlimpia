//
//  AppearanceSettingsView.swift
//  TechnicalTestOlimpia
//
//  Created by Laddy Diaz Lamus on 15/11/20.
//

import SwiftUI

struct AppearanceSettingsView: View {
    
    let themeTag = 1
    let nameTag = 2
    let languageTag = 3
    let heightLanguage: CGFloat = 0.5
    let animation = 0.5
    let zIndex = 1.0
    let heigthItemTwoText: CGFloat = 0.22
    let seconds: Double = 0.5
    
    var defaults = DefaultsConfig.shared
    
    @ObservedObject var appearanceSettingsVM = AppearanceSettingsViewModel.shared
    @State var title: String = ""
    @State var isActive: Bool = false
    @State var isLanguage: Bool = false
    @State var showAlert: Bool = false

    
    
    
    var segue = SegueConfig.shared
    
    var body: some View {
        return GeometryReader { geometry in
            ZStack {
                VStack(spacing: 0) {
                    NavigationLink(destination: ThemeView(),
                                   isActive: self.$isActive) {
                                    SettingCellView(icon: "paintbrush",
                                                    text: "TEXT_COLOR_SCHEME".localized,
                                                    textTint: self.appearanceSettingsVM.theme,
                                                    spacerLine: true,
                                                    iconAction: "chevron.right"){
                                                        self.title = ""
                                                        self.isActive = true
                                    }
                    }
                    
                    
                    SettingCellView(icon: "globe",
                                    text: "TEXT_LANGUAGE".localized,
                                    textTint: self.appearanceSettingsVM.language,
                                    spacerLine: true,
                                    iconAction: "pencil"){
                                        self.animateInLanguage()
                    }
                    Spacer()
                }.frame(minWidth: 0,
                        maxWidth: .infinity,
                        minHeight: 0,
                        maxHeight: .infinity)
                    .background(Color.background)
                    .edgesIgnoringSafeArea(.bottom)
                    .navigationBarColor(UIColor.primary)
                    .navigationBarTitle(Text(self.title), displayMode: .inline)
                    .onAppear {
                        self.appearanceSettingsVM.load()
                        self.title = self.appearanceSettingsVM.title
                }
                
                if self.$isLanguage.wrappedValue {
                    LanguageView(isLanguage: self.$isLanguage) {
                                    self.appearanceSettingsVM.load()
                                    self.title = self.appearanceSettingsVM.title
                                    self.appearanceSettingsVM.updateLanguage()
                    }.edgesIgnoringSafeArea(.all)
                }
            }
        }
    }
    func animateInLanguage() {
        withAnimation {
            self.isLanguage.toggle()
        }
    }
}

struct BtnAppearanceView: View {
    
    let btnWidth = CGFloat(0.9)
    let btnHeight = CGFloat(0.12)
    
    @ObservedObject var appearanceSettingsVM = AppearanceSettingsViewModel.shared
    @Binding var title: String
    @Binding var subtitle: String
    var width: CGFloat
    var height: CGFloat
    var action: () -> Void
    
    var body: some View {
        Button(action: {
            self.action()
        }) {
            ZStack {
                HStack {
                    VStack {
                        HStack {
                            Text(title)
                                .font(name: FontConfig.default.robotoBold,
                                      size: FontSizeConfig.default.text)
                                .foregroundColor(Color.secondaryText)
                            Spacer()
                        }
                        if !subtitle.isEmpty {
                            HStack {
                                Text(subtitle)
                                    .font(name: FontConfig.default.robotoRegular,
                                          size: FontSizeConfig.default.text)
                                    .foregroundColor(Color.tint)
                                Spacer()
                            }
                        }
                    }
                    Image(systemName: "chevron.right")
                        .font(name: FontConfig.default.robotoBold,
                              size: FontSizeConfig.default.title)
                        .foregroundColor(Color.icon)
                }
                .foregroundColor(Color.secondary)
                .frame(width: width * btnWidth,
                       height: height * btnHeight)
                VStack {
                    Spacer()
                    Rectangle()
                        .frame(width: width,
                               height: 1)
                        .foregroundColor(Color.secondary)
                }
            }
        }.frame(width: width,
                height: height * btnHeight)
    }
}

struct AppearanceSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        AppearanceSettingsView()
    }
}
