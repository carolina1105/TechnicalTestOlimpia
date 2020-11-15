//
//  LocationView.swift
//  TechnicalTestOlimpia
//
//  Created by Laddy Diaz Lamus on 14/11/20.
//

import SwiftUI
import MapKit

struct LocationView: View {
    private let empty: String = ""
    private let seconds: Double = 0.1
    private let alertTypeOne: Int = 1
    private let width = UIScreen.main.bounds.size.width
    private let iconSize = CGFloat(20.0)
    private let frmIconSize = CGFloat(40.0)
    private let searchHeight = CGFloat(44.0)
    private let opacity = Double(0.7)
    private let trailing = CGFloat(10.0)
    private let bottom = CGFloat(20.0)
    private let sideWidth: CGFloat = 0.15
    private let btnHeight: CGFloat = 40.0
    private let corner: CGFloat = 20.0
    private let loading: CGFloat = 150.0
    private let spacing: CGFloat = 0.25
    private let cellSize: CGFloat = 44.0
    private let bottomHeight = CGFloat(22.0)
    private let degrees: Double = 45
    
    @ObservedObject var locationVM = LocationViewModel()
    var didLocation: (LocationModel) -> Void
    
    var body: some View {
        return GeometryReader { geometry in
            ZStack {
                NavigationView {
                    ZStack {
                        ZStack {
                            VStack(spacing: .zero) {
                                MapView(region: self.$locationVM.region,
                                        annotation: self.$locationVM.annotation,
                                        location: self.$locationVM.location,
                                        isRemoveAnnotations: self.$locationVM.isRemoveAnnotations,
                                        selectLocation: { location in
                                            self.locationVM.selectLocation(location: location)
                                }) { location in
                                    UIApplication.shared.endEditing(true)
                                    SegueConfig.shared.dismiss()
                                    self.didLocation(location)
                                }
                            }
                            VStack(spacing: .zero) {
                                Spacer()
                                HStack(spacing: .zero) {
                                    Spacer()
                                    Button(action: {
                                        self.locationVM.showCurrentLocation()
                                    }) {
                                        ZStack {
                                            Circle()
                                                .foregroundColor(Color.primary)
                                                .opacity(self.opacity)
                                            Image(systemName: "location")
                                                .foregroundColor(Color.secondaryLight)
                                                .font(name: FontConfig.default.robotoRegular,
                                                      size: FontSizeConfig.default.bigTitle)
                                        }
                                        .frame(width: self.frmIconSize,
                                               height: self.frmIconSize)
                                    }
                                    .padding(.trailing, self.trailing)
                                    .padding(.bottom, UIDevice.current.notchSize + self.bottom + self.locationVM.bottomLocation)
                                }
                            }
                            if self.$locationVM.searching.wrappedValue {
                                if self.locationVM.locations.count > .zero {
                                    VStack(spacing: .zero) {
                                        Spacer().frame(height: self.searchHeight)
                                        List (self.locationVM.locations) { location in
                                            LocationCellView(location: location) {
                                                self.locationVM.search = self.empty
                                                UIApplication.shared.endEditing(true)
                                                DispatchQueue.main.asyncAfter(deadline: .now() + self.seconds) {
                                                    self.locationVM.location = location
                                                    self.locationVM.showCoordinates(location.coordinate)
                                                }
                                            }
                                            .frame(height: self.cellSize)
                                        }.onAppear {
                                            TableViewConfig.shared.themeMenu()
                                        }
                                    }
                                } else {
                                    VStack(alignment: .center,
                                           spacing: .zero) {
                                            LoadingView(color: UIColor.tint,
                                                        dimension: self.loading,
                                                        type: .ballRotateChase,
                                                        background: .clear)
                                                .frame(width: self.loading,
                                                       height: self.loading)
                                            Spacer()
                                                .frame(height: geometry.size.height * self.spacing)
                                    }
                                    .frame(width: geometry.size.width,
                                           height: geometry.size.height)
                                        .background(Color.backgroundDialog)
                                }
                            }
                            if self.$locationVM.isLocation.wrappedValue {
                                VStack(spacing: .zero) {
                                    Spacer()
                                    ZStack {
                                        VStack(spacing: .zero) {
                                            Spacer()
                                                .frame(height: self.locationVM.bottomLocation - self.bottomHeight)
                                            Rectangle()
                                                .foregroundColor(Color.primary)
                                                .frame(width: geometry.size.width,
                                                       height: self.bottomHeight)
                                        }
                                        VStack(spacing: .zero) {
                                            HStack {
                                                Text(self.locationVM.address).foregroundColor(Color.primaryText)
                                                Button(action: {
                                                    guard let location = self.locationVM.location else {
                                                        return
                                                    }
                                                    UIApplication.shared.endEditing(true)
                                                    SegueConfig.shared.dismiss()
                                                    self.didLocation(location)
                                                }) {
                                                    ZStack {
                                                        Circle()
                                                            .foregroundColor(Color.primaryText)
                                                            .frame(width: geometry.size.width * self.sideWidth,
                                                                   height: self.btnHeight)
                                                        Image(systemName: "paperplane.fill")
                                                            .rotationEffect(.degrees(self.degrees),
                                                                            anchor: .center)
                                                            .font(name: FontConfig.default.robotoRegular,
                                                                  size: FontSizeConfig.default.title)
                                                    }
                                                }
                                                .foregroundColor(Color.primary)
                                            }
                                            .frame(width: geometry.size.width,
                                                   height: self.locationVM.bottomLocation)
                                            Spacer()
                                                .frame(height: UIDevice.current.notchSize)
                                        }
                                        .background(Color.primary)
                                        .cornerRadius(self.corner)
                                    }
                                }
                                .transition(.asymmetric(insertion: .move(edge: .bottom),
                                                        removal: .move(edge: .bottom)))
                            }
                        }
                        .frame(minWidth: .zero,
                               maxWidth: .infinity,
                               minHeight: .zero,
                               maxHeight: .infinity)
                            .edgesIgnoringSafeArea(.bottom)
                            .background(Color.primary)
                        VStack(spacing: .zero) {
                            SearchAddress(locationVM: self.locationVM,
                                          onCommit: {}) {}
                                .frame(width: geometry.size.width,
                                       height: self.searchHeight)
                                .background(Color.primary)
                            Spacer()
                        }
                    }
                    .alert(isPresented: self.$locationVM.showAlert) {
                        if self.$locationVM.alertType.wrappedValue == self.alertTypeOne {
                            return Alert(title: Text("TEXT_TITLE_FAIL".localized),
                                         message: Text(self.locationVM.failMessage),
                                         primaryButton: .default(Text("TEXT_OPEN_SETTINGS".localized),
                                                                 action: {
                                                                    UIApplication.shared.openSystemSettings()
                                         }), secondaryButton: .default(Text("TEXT_CLOSE".localized)))
                        }
                        return Alert(title: Text("TEXT_TITLE_FAIL".localized),
                                     message: Text(self.locationVM.failMessage),
                                     dismissButton: .default(Text("TEXT_CLOSE".localized)))
                    }
                    .navigationBarTitle(Text("TEXT_LOCATION_TITLE".localized), displayMode: .inline)
                    .navigationBarColor(UIColor.red)
                    .navigationBarItems(leading:
                        Button(action: {
                            SegueConfig.shared.dismiss()
                        }, label: {
                            Image(systemName: "xmark")
                                .font(.system(size: self.iconSize))
                                .frame(width: self.frmIconSize,
                                       height: self.frmIconSize)
                        }))
                        .onAppear {
                            self.locationVM.showCurrentLocation()
                    }.onDisappear {
                        self.locationVM.clean()
                    }
                }
                .background(Color.primary)
                .onAppear {
                }
            }
        }
    }
}

struct SearchAddress: View {
    private let empty: String = ""
    private let one: Double = 1
    private let padding: CGFloat = 8
    private let corner: CGFloat = 20
    private let width = UIScreen.main.bounds.size.width
    private let searchWidth: CGFloat = 0.9
    private let height: CGFloat = 35
    
    @ObservedObject var locationVM: LocationViewModel
    var onCommit: () -> Void
    var onCancel: () -> Void
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .font(name: FontConfig.default.robotoRegular,
                          size: FontSizeConfig.default.title)
                    .foregroundColor(Color.secondaryText)
                    .padding(.leading, padding)
                ZStack (alignment: .leading) {
                    TextField("TEXT_SEARCH_NAME_OR_ADDRESS".localized,
                              text: $locationVM.search,
                              onEditingChanged: { isEditing in
                                
                    }, onCommit: onCommit)
                        .foregroundColor(Color.secondaryText)
                }
            }
            .frame(width: (width * searchWidth) - locationVM.cancelWidth,
                   height: height)
                .background(Color.background)
                .cornerRadius(corner)
            if $locationVM.searching.wrappedValue {
                Button("TEXT_CANCEL".localized) {
                    UIApplication.shared.endEditing(true)
                    self.locationVM.search = self.empty
                    self.onCancel()
                }
                .frame(width: locationVM.cancelWidth)
                .foregroundColor(Color.primaryText)
                .transition(.asymmetric(insertion: .move(edge: .trailing),
                                        removal: .move(edge: .trailing)))
            }
        }
    }
}

struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationView() { _ in
        }
    }
}
