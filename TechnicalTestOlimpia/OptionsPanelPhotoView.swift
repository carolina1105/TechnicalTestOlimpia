//
//  OptionsPanelPhotoView.swift
//  TechnicalTestOlimpia
//
//  Created by Laddy Diaz Lamus on 16/11/20.
//

import SwiftUI

struct OptionsPanelPhotoView: View {
    
    private let opacity: Double = 0.4
    private let dragClose: CGFloat = -100
    private let corner: CGFloat = 25
    private let padding: CGFloat = 25
    
    @Binding var showCapture: Bool
    @State var isOpacity: Bool = false
    var title: String
    var didPhoto: (UIImagePickerController.SourceType) -> Void
    
    var body: some View {
        let drag = DragGesture()
            .onEnded {
                if $0.translation.height > self.dragClose {
                    self.animateOut()
                }
            }
        return ZStack(alignment: .bottom) {
            if self.$isOpacity.wrappedValue {
                Color.black.opacity(self.opacity)
                    .edgesIgnoringSafeArea(.all)
            }
            VStack(spacing: .zero) {
                HStack(spacing: .zero) {
                    Text(title)
                        .foregroundColor(Color.tint)
                        .font(name: FontConfig.default.robotoRegular,
                              size: FontSizeConfig.default.title)
                        .padding()
                }
                Divider()
                Button(action: {
                    self.didPhoto(.camera)
                    self.animateOut()
                }) {
                    Image(systemName: "camera.fill")
                        .foregroundColor(Color.primaryText)
                        .font(name: FontConfig.default.robotoBold,
                              size: FontSizeConfig.default.text)
                        .padding(.trailing, padding)
                    Text("TEXT_TAKE_PHOTO".localized)
                        .foregroundColor(Color.primaryText)
                        .font(name: FontConfig.default.robotoRegular,
                              size: FontSizeConfig.default.text)
                    Spacer()
                }
                .padding()
                Button(action: {
                    self.didPhoto(.photoLibrary)
                    self.animateOut()
                }) {
                    Image(systemName: "photo.fill")
                        .foregroundColor(Color.primaryText)
                        .font(name: FontConfig.default.robotoBold,
                              size: FontSizeConfig.default.text)
                        .padding(.trailing, padding)
                    Text("TEXT_SELECT_PHOTO".localized)
                        .foregroundColor(Color.primaryText)
                        .font(name: FontConfig.default.robotoRegular,
                              size: FontSizeConfig.default.text)
                    Spacer()
                }
                .padding()
            }.padding(.bottom)
            .background(Color.backgroundDialog)
            .cornerRadius(radius: corner, corners: [.topRight, .topLeft])
            .edgesIgnoringSafeArea(.bottom)
        }.gesture(drag)
        .onAppear(perform: {
            animationIn()
        })
    }
    func animationIn() {
        withAnimation {
            isOpacity = true
        }
    }
    
    func animateOut() {
        isOpacity.toggle()
        self.showCapture.toggle()
        
    }
    
}

struct CapturePhotoView_Previews: PreviewProvider {
    static var previews: some View {
        OptionsPanelPhotoView(showCapture: .constant(false),
                              title: "Example") { type in
        }
    }
}
