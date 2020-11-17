//
//  UserCellView.swift
//  TechnicalTestOlimpia
//
//  Created by Laddy Diaz Lamus on 17/11/20.
//

import SwiftUI

struct UserCellView: View {
    var user: UserModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(user.name)
                .titleFont(color: Color.primaryText, 
                           decoration: .bold)
                .foregroundColor(Color.primaryText)
            Text(user.cellphone)
                .textFont(color: Color.tint)
        }
        .padding(.vertical, 5)
        .padding(.horizontal)
    }
}

struct UserCellView_Previews: PreviewProvider {
    static var previews: some View {
        UserCellView(user: .empty)
    }
}
