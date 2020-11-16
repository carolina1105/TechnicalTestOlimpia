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
    private let iconSize: CGFloat = 25.0
//    private let frmIconSize: CGFloat = 40.0
    private let offsetXBar: CGFloat = -20
    private var segue = SegueConfig.shared
    private let translationAnimateOut: CGFloat = -100
    private let translationAnimateIn: CGFloat = 100
    
    @State var showMenu = false
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
        segue.present(view: GalleryView(didSendPhoto: { text, test in
            
        }))
//        self.segue.present(view: GalleryView(message: "",
//                                             didSendPhoto: { photo, message in
//                                                self.conversationVM.photo(base64: photo,
//                                                                          message: message,
//                                                                          quote: self.quote)
//                                                self.messageToAttachment = String.empty
//                                                self.quoteClear()
//                                             }, didSendVideo: { (video, message) in
//                                                self.conversationVM.video(path: video,
//                                                                          message: message,
//                                                                          quote: self.quote)
//                                                self.messageToAttachment = String.empty
//                                                self.quoteClear()
//                                             }), style: .automatic)
        
    }
    
    func showCamera() {
        segue.navigation(view: CameraView(
                                          didSendPhoto: { photo, message in
//                                            self.conversationVM.photo(base64: photo,
//                                                                      message: message,
//                                                                      quote: self.quote)
//                                            self.messageToAttachment = String.empty
//                                            self.quoteClear()
//                                          }) { video, message in
//            self.conversationVM.video(path: video,
//                                      message: message,
//                                      quote: self.quote)
//            self.messageToAttachment = String.empty
//            self.quoteClear()
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
        .padding()
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
