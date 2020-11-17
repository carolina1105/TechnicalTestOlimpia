//
//  UsersListView.swift
//  TechnicalTestOlimpia
//
//  Created by Laddy Diaz Lamus on 16/11/20.
//

import SwiftUI

struct UsersListView: View {
    @ObservedObject var userVM = UserDataViewModel.shared

    var body: some View {
        ZStack {
            if self.userVM.users.count > .zero {
                List {
                    ForEach(self.userVM.users) { value in
                        UserCellView(user: value)
                    }
                }
                .navigationBarColor(UIColor.primary)
                .navigationBarTitle(Text("TEXT_LIST_USERS".localized), 
                                    displayMode: .inline)
            }
        }
    }
}

struct UsersListView_Previews: PreviewProvider {
    static var previews: some View {
        UsersListView()
    }
}
