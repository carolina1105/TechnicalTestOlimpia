//
//  UserDataView.swift
//  TechnicalTestOlimpia
//
//  Created by Laddy Diaz Lamus on 13/11/20.
//

import SwiftUI

struct UserDataView: View {
    var width: CGFloat = UIScreen.main.bounds.size.width
    var btnWidth: CGFloat = 0.8
    var btnHeight: CGFloat = 45
    let animation = 0.5
    private let iconSize: CGFloat = 25.0
    private let offsetXBar: CGFloat = -20
    private var segue = SegueConfig.shared
    private let translationAnimateOut: CGFloat = -100
    private let translationAnimateIn: CGFloat = 100
    
    @State var showMenu = false
    @State var showCapture: Bool = false
    @State var isOpacity: Bool = false
    @ObservedObject var userVM = UserDataViewModel.shared

    var body: some View {
        let drag = DragGesture()
            .onEnded {
                if $0.translation.width < self.translationAnimateOut {
                    self.animateOut(animation: true)
                }
                if $0.translation.width > self.translationAnimateIn {
                    self.animateIn()
                }
            }
        NavigationView {
            ZStack{

            VStack{
                ScrollView { 
                    SectionView(title: "TEXT_NAME".localized, username: self.$userVM.name)
                    SectionView(title: "TEXT_IDENTIFICATION_CARD".localized, username: .constant("\(self.userVM.identification)"))
                    SectionView(title: "TEXT_ADDRESS".localized, username: self.$userVM.address)
                    SectionView(title: "TEXT_CITY".localized, username: self.$userVM.city)
                    SectionView(title: "TEXT_COUNTRY".localized, username: self.$userVM.country)
                    SectionView(title: "TEXT_CELLPHONE".localized, username: self.$userVM.cellphone)
                    SectionPhoto(title: "TEXT_SELECT_PHOTO".localized, didCaptureImage: {_ in 
                        self.animateInPhoto()
                    })

                }
                BtnHudPrimary(text: "TEXT_NEXT".localized) {  btn in
//                    self.showLocation()
                    print("user. \(self.userVM.user)")
                    btn.stopAnimation(animationStyle: .normal)

//                                self.registerUserVM.register(success: {
//                                    btn.stopAnimation(animationStyle: .expand) {
//                                        self.segue.present(inbox: InboxView(isSplash: false))
//                                    }
//                                }) {
//                                    btn.stopAnimation(animationStyle: .normal)
//                                }
                }
                .frame(width: width * btnWidth, height: btnHeight,alignment: .center)
                .padding(.bottom, 30)
                Spacer()
            }
            .padding(.top)
                NavigationContent()

            }
            .navigationBarItems(leading: Button(action: {
                self.animateIn()
                self.showMenu = true
            }) {
                HStack {
                    Text("  ")
                    Image(systemName: "line.horizontal.3")
                        .font(.system(size: self.iconSize))
                        .foregroundColor(Color.nSecondaryText)
                    Text("Pokémon")
                        .titleFont(color: Color.nSecondaryText)
                }.offset(x: self.offsetXBar)
            })
            .gesture(drag)
            .navigationBarColor(UIColor.primary)
            .edgesIgnoringSafeArea(.bottom)
        }
        if self.$showCapture.wrappedValue {
            OptionsPanelPhotoView(showCapture: self.$showCapture,
                                  isRestore: false,
                                  title: "cambiar foto",
                                  didRestore: {
                                  }) { sourceType in
                if sourceType == .camera {
                    self.showCamera()
                } else {
                    self.showGallery()
                }
            }.edgesIgnoringSafeArea(.all)
        }
        ZStack {
            if self.$showMenu.wrappedValue {
                MenuView(isOpacity: .constant(false),
                         close: {
                            self.animateOut(animation: true)
                         }) { tag in
                    self.userVM.activeSection = tag
                    self.animateOut(animation: false)
                }
                .statusBar(hidden: UIDevice.current.hasNotch ? true : false)
                .transition(.move(edge: .leading))
            }
        }
        .gesture(drag)
        
    }
    func showGallery() {
        segue.present(view: GalleryView(didSendPhoto: { photo, test in
            self.userVM.avatar = photo
        }))        
    }
    
    func animateInPhoto() {
        withAnimation {
            self.showCapture.toggle()
        }
        withAnimation(.easeIn(duration: animation)) {
            self.isOpacity.toggle()
        }
    }
    func showCamera() {
        segue.present(view: CameraView(didSendPhoto: { photo, message in
                                            self.userVM.avatar = photo
        }))
    }
    
    private func showLocation() {
        segue.present(view: LocationView { location in
//            self.conversationVM.location(location,
//                                         self.quote)
        },
        style: .automatic)
    }
    
    func animateIn(completion: (() -> Void)? = nil) {
        let duration: Double = 0.45
        withAnimation {
            self.showMenu = true
        }
        withAnimation(.easeIn(duration: duration)) {
            completion?()
        }
    }
    
    func animateOut(animation: Bool) {
        if animation {
            withAnimation {
                self.showMenu = false
            }
        } else {
            self.showMenu = false
        }
    }
}

struct SectionView: View {
    var title: String
    @Binding var username: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title + ":")
                .titleFont()
            TextField(title, text: $username)
                .textFieldStyle(CustomTextFieldStyle(status: .default))
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
}

struct SectionPhoto: View {
    var title: String
    var didCaptureImage: (Bool) -> Void
    private let sizeIconSmall: CGFloat = 25
    private let paddingBottonIcon:CGFloat = 35
    
    var body: some View {
        HStack {
            Text(title + ":")
                .titleFont()
            Spacer()
            Button(action: {
                self.didCaptureImage(false)
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

struct NavigationContent: View {
    private let appearanceTag: Int = 1
    private let securityTag: Int = 2
    
    @ObservedObject var userVM = UserDataViewModel.shared

    var body: some View {
        ZStack {
            NavigationLink(destination: AppearanceSettingsView(),
                           tag: appearanceTag,
                           selection: $userVM.activeSection) {
                Text("")
            }
        }
    }
}
struct UserDataView_Previews: PreviewProvider {
    static var previews: some View {
        UserDataView()
    }
}
