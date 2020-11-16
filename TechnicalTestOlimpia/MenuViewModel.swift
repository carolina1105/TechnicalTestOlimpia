//
//  MenuViewModel.swift
//  TechnicalTestOlimpia
//
//  Created by Laddy Diaz Lamus on 15/11/20.
//

import Foundation
import SwiftUI

class MenuViewModel: ObservableObject {
    
    static let shared = MenuViewModel()
    
    @Published var menuItems: [MenuItemModel] =
        [MenuItemModel(id: "1",
                        tag: 1,
                        name: "TEXT_APPEARANCE_SETTINGS_TITLE",
                        icon: "paintbrush.fill")
    ]
}
