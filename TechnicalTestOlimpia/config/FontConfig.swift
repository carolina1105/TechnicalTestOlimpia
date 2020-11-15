//
//  FontConfig.swift
//  TechnicalTestOlimpia
//
//  Created by Laddy Diaz Lamus on 14/11/20.
//

import UIKit

fileprivate let defRobotoBold       = "Roboto-Bold"
fileprivate let defRobotoItalic     = "Roboto-Italic"
fileprivate let defRobotoBoldItalic = "Roboto-BoldItalic"
fileprivate let defRobotoLight      = "Roboto-Light"
fileprivate let defRobotoMedium     = "Roboto-Medium"
fileprivate let defRobotoRegular    = "Roboto-Regular"

fileprivate let defBigTitle: CGFloat   = 25.0
fileprivate let defTitle: CGFloat      = 20.0
fileprivate let defText: CGFloat       = 16.0
fileprivate let defMediumText: CGFloat = 14.0
fileprivate let defSmallText: CGFloat  = 12.0

struct FontConfig {
    let robotoBold:    String
    let robotoItalic:  String
    let robotoBoldItalic: String
    let robotoLight:   String
    let robotoMedium:  String
    let robotoRegular: String
    
    static let `default` = FontConfig(robotoBold: defRobotoBold,
                                      robotoItalic: defRobotoItalic,
                                      robotoBoldItalic: defRobotoBoldItalic,
                                      robotoLight: defRobotoLight,
                                      robotoMedium: defRobotoMedium,
                                      robotoRegular: defRobotoRegular)
}

struct FontSizeConfig {
    let bigTitle:  CGFloat
    let title: CGFloat
    let text:  CGFloat
    let smallText:  CGFloat
    let mediumText: CGFloat
    
    static let `default` = FontSizeConfig(bigTitle: defBigTitle,
                                          title: defTitle,
                                          text: defText,
                                          smallText: defSmallText,
                                          mediumText: defMediumText)
}
