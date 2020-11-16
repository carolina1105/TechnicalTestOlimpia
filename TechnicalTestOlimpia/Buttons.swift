//
//  Buttos.swift
//  TechnicalTestOlimpia
//
//  Created by Laddy Diaz Lamus on 14/11/20.
//

import SwiftUI
import TransitionButton

struct ButtonPrimary: View {
    let padding: CGFloat = 8
    let cornerRadius: CGFloat = 8
    
    var text: String
    var textColor: Color = Color.nSecondaryText
    var decoration: DecorationType = .bold
    var color: Color = Color.nPrimary
    var action: () -> Void
    
    var body: some View {
        Button(action: {
            self.action()
        }) {
            HStack(spacing: 10) {
                Spacer()
                Text(text)
                    .lineLimit(1)
                    .textFont(color: textColor,
                              decoration: .bold)
                Spacer()
            }.padding(.vertical, padding)
                .background(color)
                .cornerRadius(cornerRadius)
        }.buttonStyle(PlainButtonStyle())
    }
}

struct ButtosView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonPrimary(text: "text") {
            
        }.environment(\.colorScheme, .light)
}
}

struct ButtonSecondary: View {
    let padding: CGFloat = 8
    let cornerRadius: CGFloat = 8
    
    var text: String
    var color: Color = Color.nTint
    var colorBackground = Color.clear
    var decoration: DecorationType = .bold
    var border: CGFloat = 2
    var action: () -> Void
    
    var body: some View {
        Button(action: {
            self.action()
        }) {
            HStack {
                Spacer()
                Text(text)
                    .lineLimit(1)
                    .textFont(color: color,
                              decoration: decoration)
                Spacer()
            }.padding(.vertical, padding)
                .overlay(RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(color, lineWidth: border))
            .background(colorBackground)
        }.buttonStyle(PlainButtonStyle())
    }
}

private enum TransitionButtonState { case normal, animating }
private var state: TransitionButtonState = .normal
struct BtnHudPrimary: UIViewRepresentable {
    
    private static let width = UIScreen.main.bounds.size.width
    
    var text: String
    var textColor: UIColor? = UIColor.nPrimaryText
    var fontType: String? = FontConfig.default.robotoBold 
    var fontSize: CGFloat? = FontSizeConfig.default.text
    var color: UIColor? = UIColor.nPrimary
    var corner: CGFloat? = CGFloat(5)
    var width: CGFloat? = (BtnHudPrimary.width * 0.8)
    var height: CGFloat? = CGFloat(45.0)
    var onSuccessStopAnimationStyle = StopAnimationStyle.expand
    var onFailureStopAnimationStyle = StopAnimationStyle.normal
    var isAnimating: Bool? = nil
    var didActivitySucceed: Bool? = nil
    var onStopAnimation: (() -> Void)? = nil
    var action: (TransitionButton) -> Void
    
    func makeUIView(context: UIViewRepresentableContext<BtnHudPrimary>) -> UIView {
        let view = UIView()
        
        let btn = TransitionButton(frame: CGRect(x: 0, y: 0, width: width!, height: height!))
        
        btn.setTitle(text, for: .normal)
        btn.setTitleColor(textColor, for: .normal)
        btn.titleLabel!.font = UIFont(name: fontType!, size: fontSize!)
        btn.backgroundColor = color
        btn.cornerRadius = corner!
        btn.spinnerColor = textColor!
        btn.on(.touchUpInside) { (sender, event) in
            btn.startAnimation()
            state = .animating
            self.action(sender as! TransitionButton)
        }
        state = .normal
        
        view.addSubview(btn)
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<BtnHudPrimary>) {
        for btn in uiView.subviews {
            if let btn = btn as? TransitionButton {
                btn.setTitle(text, for: .normal)
                btn.backgroundColor = color
                
                if let isAnimating = self.isAnimating,
                    let didActivitySucceed = self.didActivitySucceed,
                    !isAnimating,
                    state == .animating {
                    state = .normal
                    let animationStyle = didActivitySucceed ? onSuccessStopAnimationStyle : onFailureStopAnimationStyle
                    btn.stopAnimation(animationStyle: animationStyle,
                                      completion: onStopAnimation)
                }
            }
        }
    }
    
}

struct BtnImagePrimary: UIViewRepresentable {
    
    private static let width = UIScreen.main.bounds.size.width
    
    @Binding var img: String
    var color: UIColor? = UIColor.nPrimary
    var corner: CGFloat? = CGFloat(5)
    var width: CGFloat? = (BtnImagePrimary.width * 0.8)
    var height: CGFloat? = CGFloat(45.0)
    var action: (TransitionButton) -> Void
    
    func makeUIView(context: UIViewRepresentableContext<BtnImagePrimary>) -> UIView {
        let view = UIView()
        
        let btn = TransitionButton(frame: CGRect(x: 0, y: 0, width: width!, height: height!))
        
        btn.setImage(UIImage(named: img), for: .normal)
        btn.contentMode = .scaleAspectFit
        btn.backgroundColor = color
        btn.cornerRadius = corner!
        btn.on(.touchUpInside) { (sender, event) in
            btn.startAnimation()
            self.action(sender as! TransitionButton)
        }
        
        view.addSubview(btn)
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<BtnImagePrimary>) {
        
        for btn in uiView.subviews {
            if btn is TransitionButton {
                guard let button = btn as? TransitionButton else {
                    return
                }
                button.setImage(UIImage(named: img), for: .normal)
                button.backgroundColor = color
            }
        }
    }
    
}

struct BtnHudPrimaryQuestions: UIViewRepresentable {
    
    private static let width = UIScreen.main.bounds.size.width
    
    var text: String
    var textColor: UIColor? = UIColor.nPrimaryText
    var fontType: String? = FontConfig.default.robotoBold
    var fontSize: CGFloat? = FontSizeConfig.default.text
    var color: UIColor? = UIColor.nPrimary
    var corner: CGFloat? = CGFloat(5)
    var width: CGFloat? = (BtnHudPrimaryQuestions.width * 0.4)
    var height: CGFloat? = CGFloat(45.0)
    var action: (TransitionButton) -> Void
    
    func makeUIView(context: UIViewRepresentableContext<BtnHudPrimaryQuestions>) -> UIView {
        let view = UIView()
        
        let btn = TransitionButton(frame: CGRect(x: 0, y: 0, width: width!, height: height!))
        
        btn.setTitle(text, for: .normal)
        btn.setTitleColor(textColor, for: .normal)
        btn.titleLabel!.font = UIFont(name: fontType!, size: fontSize!)
        btn.backgroundColor = color
        btn.cornerRadius = corner!
        btn.spinnerColor = textColor!
        btn.on(.touchUpInside) { (sender, event) in
            btn.startAnimation()
            self.action(sender as! TransitionButton)
        }
        
        view.addSubview(btn)
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<BtnHudPrimaryQuestions>) {
        for btn in uiView.subviews {
            if btn is TransitionButton {
                btn.backgroundColor = color
            }
        }
    }
    
}

struct BtnHudSecondary: UIViewRepresentable {
    
    private static let width = UIScreen.main.bounds.size.width
    
    var text: String
    var textColor: UIColor? = UIColor.nTint
    var fontType: String? = FontConfig.default.robotoBold
    var fontSize: CGFloat? = FontSizeConfig.default.text
    var color: UIColor? = UIColor.nBackground
    var corner: CGFloat? = CGFloat(5)
    var border: CGFloat? = CGFloat(1)
    var width: CGFloat? = (BtnHudSecondary.width * 0.8)
    var height: CGFloat? = CGFloat(45.0)
    var action: (TransitionButton) -> Void
    
    func makeUIView(context: UIViewRepresentableContext<BtnHudSecondary>) -> UIView {
        let view = UIView()
        
        let btn = TransitionButton(frame: CGRect(x: 0, y: 0, width: width!, height: height!))
        
        btn.setTitle(text, for: .normal)
        btn.setTitleColor(textColor, for: .normal)
        btn.titleLabel!.font = UIFont(name: fontType!, size: fontSize!)
        btn.backgroundColor = color
        btn.cornerRadius = corner!
        if border! > 0 {
            btn.layer.borderWidth = border!
            btn.layer.borderColor = (textColor as! CGColor)
        }
        btn.spinnerColor = textColor!
        btn.on(.touchUpInside) { (sender, event) in
            btn.startAnimation()
            self.action(sender as! TransitionButton)
        }
        
        view.addSubview(btn)
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<BtnHudSecondary>) {
        for btn in uiView.subviews {
            if btn is TransitionButton {
                (btn as! TransitionButton).setTitleColor(textColor, for: .normal)
                (btn as! TransitionButton).setTitle(text, for: .normal)
            }
        }
    }
    
}
