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
    private var segue = SegueConfig.shared

    @State var username: String = ""
    @ObservedObject var userVM = UserDataViewModel.shared

    var body: some View {
        NavigationView {
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
            .navigationBarTitle("UserData", displayMode: .inline)
            .navigationBarColor(UIColor.tint)
            .edgesIgnoringSafeArea(.bottom)
        }
        
        
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

struct UserDataView_Previews: PreviewProvider {
    static var previews: some View {
        UserDataView()
    }
}
