//
//  ContentView.swift
//  TechnicalTestOlimpia
//
//  Created by Laddy Diaz Lamus on 13/11/20.
//

import SwiftUI

struct ContentView: View {
    @StateObject var contentVM = ContentViewModel()

    var body: some View {
        ZStack {
            UserDataView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
