//
//  TextFieldUtility.swift
//  TechnicalTestOlimpia
//
//  Created by Laddy Diaz Lamus on 14/11/20.
//

import SwiftUI

struct TextFieldForm: View {
    
    var placeholder: String = ""
    @Binding var text: String
    var tag: Int = 0
    var fontType: String = FontConfig.default.robotoRegular
    var fontSize: CGFloat = FontSizeConfig.default.text
    var color: UIColor? = UIColor.secondaryText
    var background: UIColor? = UIColor.background
    var borderColor: UIColor? = UIColor.secondaryText
    var alignment: NSTextAlignment = .left
    var keyboardType: UIKeyboardType = .default
    var capitalizationType: UITextAutocapitalizationType = .none
    var returnKey: UIReturnKeyType = .done
    var secureEntry: Bool = false
    var autocorrection: UITextAutocorrectionType = .no
    var accessory: Bool = false
    
    var showKeyboard: Bool = false
    var closeKeyboard: Bool = false
    var shouldReturn: ((UITextField?) -> Bool?)? = nil
    var didChange: ((UITextField?) -> Void)? = nil
    var shouldChange: (UITextField, NSRange, String) -> Bool
    
    var body: some View {
        TextFieldCustom(placeholder: placeholder,
                  text: $text,
                  tag: tag,
                  fontType: fontType,
                  fontSize: fontSize,
                  color: color,
                  background: background,
                  borderColor: borderColor,
                  alignment: alignment,
                  keyboardType: keyboardType,
                  capitalizationType: capitalizationType,
                  returnKey: returnKey,
                  secureEntry: secureEntry,
                  autocorrection: autocorrection,
                  accessory: accessory,
                  showKeyboard: showKeyboard,
                  closeKeyboard: closeKeyboard,
                  shouldReturn: shouldReturn,
                  didChange: didChange,
                  shouldChange: shouldChange)
    }
    
}

struct TextFieldCustom: UIViewRepresentable {
    
    private static let width = UIScreen.main.bounds.size.width

    var placeholder: String? = nil
    @Binding var text: String
    var tag: Int = 0
    var fontType: String = FontConfig.default.robotoBold
    var fontSize: CGFloat = FontSizeConfig.default.title
    var color: UIColor? = nil
    var background: UIColor? = nil
    var corner: CGFloat? = 5.0
    var border: CGFloat? = 1.0
    var borderColor: UIColor? = nil
    var clips: Bool? = true
    var width: CGFloat? = TextFieldCustom.width * 0.9
    var height: CGFloat? = CGFloat(80)
    var alignment: NSTextAlignment = .center
    var xText: CGFloat? = 10
    var keyboardType: UIKeyboardType = .numberPad
    var capitalizationType: UITextAutocapitalizationType = .none
    var returnKey: UIReturnKeyType = .default
    var secureEntry: Bool = false
    var autocorrection: UITextAutocorrectionType = .no
    var accessory: Bool = false
    
    var showKeyboard: Bool = false
    var closeKeyboard: Bool = false
    var shouldReturn: ((UITextField?) -> Bool?)? = nil
    var didChange: ((UITextField?) -> Void)? = nil
    var shouldChange: (UITextField, NSRange, String) -> Bool

    func makeUIView(context: UIViewRepresentableContext<TextFieldCustom>) -> UITextField {
        let textField = UITextField(frame: CGRect(x: .zero,
                                                  y: .zero,
                                                  width: width!,
                                                  height: height!))
        textField.attributedPlaceholder = NSAttributedString(string: (placeholder != nil) ? placeholder! : String.empty,
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.secondaryDark])
        textField.tag = tag
        textField.font = UIFont(name: fontType,
                                size: fontSize)
        textField.textColor = (color != nil) ? color : .clear
        textField.tintColor = (color != nil) ? color : .clear
        textField.backgroundColor = (background != nil) ? background : .clear
        textField.textAlignment = alignment
        if alignment != .center {
            textField.layer.sublayerTransform = CATransform3DMakeTranslation(xText!, .zero, .zero)
        }
        textField.isSecureTextEntry = secureEntry
        textField.autocapitalizationType = capitalizationType
        textField.returnKeyType = returnKey
        textField.keyboardType = keyboardType
        textField.layer.cornerRadius = corner!
        textField.layer.borderWidth = border!
        textField.layer.borderColor = (borderColor != nil) ? borderColor!.cgColor : UIColor.clear.cgColor
        textField.clipsToBounds = clips!
        textField.delegate = context.coordinator
        textField.autocorrectionType = autocorrection
        if accessory {
            textField.inputAccessoryView = setUpToolbar(textField: textField)
        }
        return textField
    }
    
    func makeCoordinator() -> TxfCoordinator {
        return TxfCoordinator(text: $text,
                              shouldReturn: shouldReturn,
                              didChange: didChange,
                              shouldChange: shouldChange)
    }
    
    func updateUIView(_ uiView: UITextField,
                      context: UIViewRepresentableContext<TextFieldCustom>) {
        uiView.text = text
        if showKeyboard {
            uiView.becomeFirstResponder()
            context.coordinator.becomeFirstResponder = true
        }
        if closeKeyboard {
            uiView.resignFirstResponder()
            context.coordinator.becomeFirstResponder = false
        }
        uiView.layer.borderColor = (borderColor != nil) ?
            borderColor!.cgColor :
            UIColor.clear.cgColor
    }
    
    let withoutDimesion = CGFloat(0)
    let iconSize = CGFloat(20.0)
    let close = "xmark"
    let closeColor = UIColor.secondaryText
    let closeSize = CGFloat(40.0)
    let toolbarColor = UIColor.secondary
    let toolbarHeight = CGFloat(44.0)
    
    func setUpToolbar(textField: UITextField) -> UIToolbar {
        let symbol = UIImage.SymbolConfiguration(pointSize: iconSize,
                                                 weight: .regular)
        let icon = UIImage(systemName: close,
                           withConfiguration: symbol)
        let btnClose = UIButton(frame: CGRect(x: withoutDimesion,
                                              y: withoutDimesion,
                                              width: closeSize,
                                              height: closeSize))
        btnClose.setImage(icon, for: .normal)
        btnClose.tintColor = closeColor
        btnClose.on(.touchUpInside) { (sender, event) in
            textField.resignFirstResponder()
            _ = self.shouldReturn?(textField)
        }
        
        let appearance = UIToolbarAppearance()
        appearance.backgroundColor = toolbarColor
        
        let toolbar = UIToolbar(frame: CGRect(x: withoutDimesion,
                                              y: withoutDimesion,
                                              width: TextFieldCustom.width,
                                              height: toolbarHeight))
        toolbar.isTranslucent = false
        toolbar.standardAppearance = appearance
        
        let barClose = UIBarButtonItem(customView: btnClose)
        let barFlexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.items = [ barFlexible, barClose ]
        
        return toolbar
    }
    
}

class TxfCoordinator: NSObject, UITextFieldDelegate {

    @Binding var text: String
    var becomeFirstResponder = false
    var shouldReturn: ((UITextField?) -> Bool?)? = nil
    var didChange: ((UITextField?) -> Void)? = nil
    var shouldChange: (UITextField, NSRange, String) -> Bool

    init(text: Binding<String>,
         shouldReturn: ((UITextField?) -> Bool?)?,
         didChange: ((UITextField?) -> Void)? = nil,
         shouldChange: @escaping (UITextField, NSRange, String) -> Bool) {
        _text = text
        self.shouldReturn = shouldReturn
        self.didChange = didChange
        self.shouldChange = shouldChange
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        DispatchQueue.main.async {
            self.text = textField.text ?? ""
            self.didChange?(textField)
        }
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        return shouldChange(textField, range, string)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if shouldReturn != nil {
            return shouldReturn!(textField)!
        }
        return true
    }

}
