//
//  NavigationBarModifier.swift
//  TechnicalTestOlimpia
//
//  Created by Laddy Diaz Lamus on 13/11/20.
//

import SwiftUI

struct NavigationBarModifier: ViewModifier {
    
    var backgroundColor: UIColor?
    var textColor: UIColor
    
    init(backgroundColor: UIColor?,
         textColor: UIColor) {
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithTransparentBackground()
        coloredAppearance.backgroundColor = .clear
        coloredAppearance.titlePositionAdjustment = UIOffset(horizontal: -(UIScreen.main.bounds.size.width * 0.35),
                                                   vertical: 0)
        coloredAppearance.titleTextAttributes = [.foregroundColor: textColor]
        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: textColor]
        
        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
        UINavigationBar.appearance().tintColor = textColor
    }
    
    func body(content: Content) -> some View {
        ZStack{
            content
            VStack {
                GeometryReader { geometry in
                    Color(self.backgroundColor ?? .clear)
                        .frame(height: geometry.safeAreaInsets.top)
                        .edgesIgnoringSafeArea(.top)
                    Spacer()
                }
            }
        }
    }
}

extension View {
    func navigationBarColor(_ backgroundColor: UIColor?, textColor: UIColor = UIColor.nSecondary!) -> some View {
        self.modifier(NavigationBarModifier(backgroundColor: backgroundColor,
                                            textColor: textColor))
    }
}
