//
//  ContentView.swift
//  TechnicalTestOlimpia
//
//  Created by Laddy Diaz Lamus on 13/11/20.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var bleManager = BLEManager()
    @StateObject var contentVM = ContentViewModel()

    var body: some View {
        ZStack {
            UserDataView()
        }.onAppear{
            if bleManager.isSwitchedOn {
                print("Bluetooth is switched on")
            }
            else {
                print("Bluetooth is NOT switched on")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
