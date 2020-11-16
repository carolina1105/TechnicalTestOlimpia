//
//  ThemeView.swift
//  TechnicalTestOlimpia
//
//  Created by Laddy Diaz Lamus on 15/11/20.
//

import SwiftUI

struct ThemeView: View {
    
    private let heigthSpacer: CGFloat = 0.1
    private let animationOpacity: Double = 0.5
    private let border: CGFloat = 1.0
    private let imageWidth: CGFloat = 0.9
    private let imageHeight: CGFloat = 0.3
    private let cornerRadius: CGFloat = 10
    private let paddingVertical: CGFloat = 6
    private let paddingHorizontal: CGFloat = 10
    private let frameWidthButton: CGFloat = 0.85
    private let frameHeightButton: CGFloat = UIDevice.current.hasNotch ? 0.24 : 0.28
    private let frameHeightImage: CGFloat = 0.35
    private let lightTheme: CGFloat = 1
    private let darkTheme: CGFloat = 2
    
    var defaults = DefaultsConfig.shared
    var segue = SegueConfig.shared
    
    @ObservedObject var themeVM = ThemeViewModel.shared
    @State var title: String = ""
    @State var isOpacity: Bool = false
    @State var isPreviewTheme: Bool = false
    @State var themeType: String = "1"
    
    var body: some View {
        return GeometryReader { geometry in
            ZStack {
                VStack(spacing: .zero) {
                    Image("preview-" + self.themeType)
                        .resizable()
                        .scaledToFill()
                        .fixedSize()
                        .cornerRadius(self.cornerRadius)
                        .padding()
                    
                    ScrollView {
                        VStack(spacing: .zero) {
                            HStack {
                                Text("TEXT_SECTION_SYSTEM_THEMES".localized.uppercased())
                                    .font(name: FontConfig.default.robotoRegular,
                                          size: FontSizeConfig.default.text)
                                    .foregroundColor(Color.primaryText)
                                Spacer()
                            }.padding(.vertical, 10)
                            .padding(.horizontal, 25)
                            .background(Color.section)
                            BtnThemeView(title: ThemeType.systemOne.rawValue,
                                         width: geometry.size.width,
                                         height: geometry.size.height,
                                         selected: self.themeType == ThemeAppType.systemOne.rawValue,
                                         action: {
                                            self.themeType = ThemeAppType.systemOne.rawValue
                                            self.segue.getWindow()?.overrideUserInterfaceStyle = .light
                                            self.defaults.set(value: self.lightTheme,
                                                              for: DefaultsConfig.shared.keyThemeType)
                                            self.defaults.set(value: self.themeType,
                                                              for: DefaultsConfig.shared.keyTheme)
                                            self.themeVM.reload()
                                         })
                            BtnThemeView(title: ThemeType.systemTwo.rawValue,
                                         width: geometry.size.width,
                                         height: geometry.size.height,
                                         selected: self.themeType == ThemeAppType.systemTwo.rawValue,
                                         action: {
                                            self.themeType = ThemeAppType.systemTwo.rawValue
                                            self.segue.getWindow()?.overrideUserInterfaceStyle = .dark
                                            self.defaults.set(value: self.darkTheme,
                                                              for: DefaultsConfig.shared.keyThemeType)
                                            self.defaults.set(value: self.themeType,
                                                              for: DefaultsConfig.shared.keyTheme)
                                            self.themeVM.reload()
                                         })
                            
                            //                            VStack(spacing: .zero) {
                            //                                SectionSpacerView(width: geometry.size.width,
                            //                                                  heigth: geometry.size.width * self.heigthSpacer,
                            //                                                  text: "TEXT_SECTION_DARK_THEMES".localized)
                            //                                    .background(ColorConfig.shared.section)
                            //                                BtnThemeView(title: ThemeType.darkOne.rawValue,
                            //                                             width: geometry.size.width,
                            //                                             height: geometry.size.height,
                            //                                             selected: self.themeType == ThemeAppType.darkOne.rawValue,
                            //                                             action: {
                            //                                                self.themeType = ThemeAppType.darkOne.rawValue
                            //                                                self.segue.window.overrideUserInterfaceStyle = .dark
                            //                                })
                            //                                BtnThemeView(title: ThemeType.darkTwo.rawValue,
                            //                                             width: geometry.size.width,
                            //                                             height: geometry.size.height,
                            //                                             selected: self.themeType == ThemeAppType.darkTwo.rawValue,
                            //                                             action: {
                            //                                                self.themeType = ThemeAppType.darkTwo.rawValue
                            //                                                self.segue.window.overrideUserInterfaceStyle = .dark
                            //                                })
                            //                                BtnThemeView(title: ThemeType.darkThree.rawValue,
                            //                                             width: geometry.size.width,
                            //                                             height: geometry.size.height,
                            //                                             selected: self.themeType == ThemeAppType.darkThree.rawValue,
                            //                                             action: {
                            //                                                self.themeType = ThemeAppType.darkThree.rawValue
                            //                                                self.segue.window.overrideUserInterfaceStyle = .dark
                            //                                })
                            //                            }
                            //                            VStack(spacing: .zero) {
                            //                                SectionSpacerView(width: geometry.size.width,
                            //                                                  heigth: geometry.size.width * self.heigthSpacer,
                            //                                                  text: "TEXT_SECTION_LIGHT_THEMES".localized)
                            //                                    .background(ColorConfig.shared.section)
                            //                                BtnThemeView(title: ThemeType.lightOne.rawValue,
                            //                                             width: geometry.size.width,
                            //                                             height: geometry.size.height,
                            //                                             selected: self.themeType == ThemeAppType.lightOne.rawValue,
                            //                                             action: {
                            //                                                self.themeType = ThemeAppType.lightOne.rawValue
                            //                                                self.segue.window.overrideUserInterfaceStyle = .light
                            //                                })
                            //                                BtnThemeView(title: ThemeType.lightTwo.rawValue,
                            //                                             width: geometry.size.width,
                            //                                             height: geometry.size.height,
                            //                                             selected: self.themeType == ThemeAppType.lightTwo.rawValue,
                            //                                             action: {
                            //                                                self.themeType = ThemeAppType.lightTwo.rawValue
                            //                                                self.segue.window.overrideUserInterfaceStyle = .light
                            //                                })
                            //                                BtnThemeView(title: ThemeType.LightThree.rawValue,
                            //                                             width: geometry.size.width,
                            //                                             height: geometry.size.height,
                            //                                             selected: self.themeType == ThemeAppType.LightThree.rawValue,
                            //                                             action: {
                            //                                                self.themeType = ThemeAppType.LightThree.rawValue
                            //                                                self.segue.window.overrideUserInterfaceStyle = .light
                            //                                })
                            //                            }
                            Spacer()
                        }
                    }
                }
            }.frame(minWidth: .zero,
                    maxWidth: .infinity,
                    minHeight: .zero,
                    maxHeight: .infinity)
            .background(self.themeVM.background)
            .edgesIgnoringSafeArea(.bottom)
            .navigationBarColor(UIColor.primary)
            .navigationBarTitle(Text(self.title), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                if !self.themeVM.isSelected(theme: self.themeType) {
                    self.defaults.set(value: self.themeType,
                                      for: DefaultsConfig.shared.keyTheme)
                    self.themeVM.reload()
                    if self.segue.window.overrideUserInterfaceStyle == .light {
                        self.defaults.set(value: self.lightTheme,
                                          for: DefaultsConfig.shared.keyThemeType)
                    } else {
                        self.defaults.set(value: self.darkTheme,
                                          for: DefaultsConfig.shared.keyThemeType)
                    }
                }
            }) {
                if !self.themeVM.isSelected(theme: self.themeType) {
                    Text("TEXT_APPLY".localized)
                        .font(name: FontConfig.default.robotoBold, size: FontSizeConfig.default.text)
                        .foregroundColor(Color.primaryText)
                        .padding(.vertical, self.paddingVertical)
                        .padding(.horizontal, self.paddingHorizontal)
                        .background(Color.fourth)
                        .cornerRadius(self.cornerRadius)
                }
            })
            .onAppear {
                self.themeType = (self.defaults.get(for: DefaultsConfig.shared.keyTheme) ?? "1") as! String
                self.title = "TEXT_COLOR_SCHEME".localized
            }
        }
    }
}

struct BtnThemeView: View {
    var title: String
    var width: CGFloat
    var height: CGFloat
    var selected: Bool
    var widthView: CGFloat = 0.9
    var heightView: CGFloat = 0.08
    var action: () -> Void
    
    @ObservedObject var themeVM = ThemeViewModel.shared
    
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
                                .foregroundColor(self.themeVM.primaryText)
                            Spacer()
                        }
                    }
                    CheckBoxUtility(isOn: self.selected)
                        .padding()
                }
                .foregroundColor(self.themeVM.secondary)
                .frame(width: width * widthView,
                       height: height * heightView)
                VStack {
                    Spacer()
                    Rectangle()
                        .frame(width: width,
                               height: 1)
                        .foregroundColor(self.themeVM.secondary)
                }
            }
        }.frame(width: width,
                height: height * heightView)
    }
}

struct ThemeView_Previews: PreviewProvider {
    static var previews: some View {
        ThemeView()
    }
}

