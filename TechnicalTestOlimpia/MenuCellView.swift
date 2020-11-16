//
//  MenuCellView.swift
//  TechnicalTestOlimpia
//
//  Created by Laddy Diaz Lamus on 15/11/20.
//

import SwiftUI

struct MenuCellView: View {
    
    let spacing: CGFloat = 15
    let iconSize: CGFloat = 20
    var item: MenuItemModel
    var action: (() -> Void)?
    
    init(item: MenuItemModel,
         action: @escaping (() -> Void)) {
        self.item = item
        self.action = action
    }
    
    var body: some View {
        VStack {
            Button(action: {
                self.action!()
            }, label: {
                HStack(spacing: spacing) {
                    Image(systemName: item.icon)
                        .font(name: FontConfig.default.robotoRegular,
                              size: iconSize)
                        .foregroundColor(Color.nPrimaryText)
                    Text(item.name.localized)
                        .font(name: FontConfig.default.robotoRegular,
                              size: FontSizeConfig.default.text)
                        .foregroundColor(Color.nPrimaryText)
                    Spacer()
                }
            })
        }
    }
}

struct MenuCellView_Previews: PreviewProvider {
    static var previews: some View {
        MenuCellView(item: MenuItemModel(id: "1",
                                         tag: 1,
                                         name: "Profile",
                                         icon: "person.fill")) {
            
        }
    }
}
