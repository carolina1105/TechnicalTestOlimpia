//
//  MenuView.swift
//  TechnicalTestOlimpia
//
//  Created by Laddy Diaz Lamus on 15/11/20.
//

import SwiftUI
import SDWebImageSwiftUI

struct MenuView: View {
    
    private let widthViewMenu: CGFloat = 0.65
    private let heightViewMenu: CGFloat = 0.4
    private let heightViewTop: CGFloat = 0.24
    private let opacity: Double = 0.4
    private let spacing: CGFloat = 0
    private let cellSize: CGFloat = 44
    private let top: CGFloat = 20
    private let maxTop: CGFloat = 30
    
    @Binding var isOpacity: Bool
    @ObservedObject var menuVM = MenuViewModel.shared
    
    var close: () -> Void
    var openSection: (Int) -> Void
    
    var body: some View {
        let tap = TapGesture()
            .onEnded {
                self.close()
            }
        return GeometryReader { geometry in
            ZStack {
                if self.$isOpacity.wrappedValue {
                    Color.black.opacity(self.opacity)
                        .edgesIgnoringSafeArea(.vertical)
                }
            }.gesture(tap)
            ZStack {
                VStack(spacing: self.spacing) {
                    MenuUserTop(widthViewMenu: geometry.size.width * self.widthViewMenu,
                                heightViewTop: geometry.size.height * self.heightViewTop,
                                openSection: self.openSection)
                        .frame(width: geometry.size.width * self.widthViewMenu,
                               height: geometry.size.height * self.heightViewMenu)
                    MenuContent(openSection: self.openSection)
                        .frame(width: geometry.size.width * self.widthViewMenu,
                               height: geometry.size.height * (1 - self.heightViewMenu))
                }
                .frame(width: geometry.size.width * self.widthViewMenu,
                       height: geometry.size.height)
                .background(Color.nBackgroundDialog)
            }
        }
        .frame(minWidth: .zero,
               maxWidth: .infinity,
               minHeight: .zero,
               maxHeight: .infinity)
        .edgesIgnoringSafeArea(UIDevice.current.hasNotch ? .all : .bottom)
        .statusBar(hidden: UIDevice.current.hasNotch ? true : false)
    }
}

struct MenuUserTop: View {
    
    let widthViewMenu: CGFloat
    let heightViewTop: CGFloat
    private let avatarSize: CGFloat = 0.60
    private let strokeLineWidth: CGFloat = 2
    private let paddingLeadingUser: CGFloat = 20
    private let lineLimit: Int = 2
    private let spacerHeight: CGFloat = UIDevice.current.hasNotch ? 40 : 25
    private let duration: Double = 0.5
    private let heightText: CGFloat = 30
    
    @ObservedObject var menuVM = MenuViewModel.shared
    
    var openSection: (Int) -> Void
    
    var body: some View {
        Button(action: {
            self.openSection(0)
        }) {
            ZStack(alignment: .center) {
                Image("users")
                    .resizable()
                    .renderingMode(.original)
                    .scaledToFill()
                    .frame(width: widthViewMenu)
                    .padding()
            }
            .clipped()
            .foregroundColor(Color.nSecondaryText)
        }
    }
}

struct MenuContent: View {
    let paddingListItems: CGFloat = 8
    let paddingContent: CGFloat = 20
    
    @ObservedObject var menuVM = MenuViewModel.shared
    
    var openSection: (Int) -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(menuVM.menuItems) { item in
                MenuCellView(item: item) {
                    self.openSection(item.tag)
                }.padding(self.paddingListItems)
            }.padding(.leading, 15)
            Spacer()
        }
        .padding(.top, paddingContent)
    }
}


struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(isOpacity: .constant(true),
                 close: { }) { tag in
        }
    }
}

