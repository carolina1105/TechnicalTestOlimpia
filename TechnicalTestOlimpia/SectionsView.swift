//
//  SectionsView.swift
//  TechnicalTestOlimpia
//
//  Created by Laddy Diaz Lamus on 16/11/20.
//

import SwiftUI

struct SectionView: View {
    var title: String
    @Binding var username: String
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("*")
                    .titleFont(color: username != "" ? Color.fourth : Color.third, 
                               decoration: .bold)
                Text(title + ":")
                    .titleFont()
            }
            TextField(title, text: $username)
                .textFieldStyle(CustomTextFieldStyle(status: .default))
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
}

struct SectionPhoto: View {
    var title: String
    var didCaptureImage: () -> Void
    private let sizeIconSmall: CGFloat = 25
    private let paddingBottonIcon:CGFloat = 35
    @ObservedObject var userVM = UserDataViewModel.shared
    
    var body: some View {
        HStack {
            HStack {
                Text("*")
                    .titleFont(color: userVM.avatar != "" ? Color.fourth : Color.third, 
                               decoration: .bold)
                Text(title + ":")
                    .titleFont()
            }
            Spacer()
            Button(action: {
                self.didCaptureImage()
            }) {
                Image(systemName: "photo.fill")
                    .font(name: FontConfig.default.robotoBold,
                          size: sizeIconSmall)
                    .foregroundColor(Color.tint)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
}

struct SectionLocation: View {
    var title: String
    var didCaptureLocation: () -> Void
    private let sizeIconSmall: CGFloat = 25
    private let paddingBottonIcon:CGFloat = 35
    @ObservedObject var userVM = UserDataViewModel.shared
    
    var body: some View {
        HStack {
            HStack {
                Text("*")
                    .titleFont(color: userVM.geolocation != "" ? Color.fourth : Color.third, 
                               decoration: .bold)
                Text(title + ":")
                    .titleFont()
            }
            Spacer()
            Button(action: {
                self.didCaptureLocation()
            }) {
                Image(systemName: "location.circle.fill")
                    .font(name: FontConfig.default.robotoBold,
                          size: sizeIconSmall)
                    .foregroundColor(Color.tint)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
}

struct SectionBluetooth: View {
    @ObservedObject var bleManager = BLEManager()

    var body: some View {
        HStack {
            Text("Bluetooth" + ":")
                .titleFont()
            Text(bleManager.isSwitchedOn ? "TEXT_BLUETOOTH_ON".localized : "TEXT_BLUETOOTH_OFF".localized)
                .textFont()
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
}
