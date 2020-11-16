//
//  SearchBarView.swift
//  TechnicalTestOlimpia
//
//  Created by Laddy Diaz Lamus on 14/11/20.
//

import SwiftUI

struct SearchBarView: View {
    private let paddingVertical: CGFloat = 8
    private let paddingHorizontal: CGFloat = 8
    private let cornerRadius: CGFloat = 5
    private let duration: Double = 0.5
    private let height: CGFloat = 22.5
    
    var placeholder: String = "TEXT_SEARCH".localized
    var iconSystem: String = "magnifyingglass"
    var isTxfKit: Bool = false
    @Binding var show: Bool
    @Binding var close: Bool
    @Binding var searchText: String
    var onCommit: (() -> Void)? = nil
    var onCancel: () -> Void
    var shouldChange: ((UITextField, NSRange, String) -> Bool)? = nil
    
    init(placeholder: String = "TEXT_SEARCH".localized,
         iconSystem: String = "magnifyingglass",
         isTxfKit: Bool = false,
         show: Binding<Bool> = .constant(false),
         close: Binding<Bool> = .constant(false),
         searchText: Binding<String>,
         onCommit: (() -> Void)? = nil ,
         onCancel: @escaping () -> Void,
         shouldChange: ((UITextField, NSRange, String) -> Bool)? = nil) {
        self.placeholder = placeholder
        self.iconSystem = iconSystem
        self.isTxfKit = isTxfKit
        _show = show
        _close = close
        _searchText = searchText
        self.onCommit = onCommit
        self.onCancel = onCancel
        self.shouldChange = shouldChange
    }
    
    var body: some View {
        HStack {
            HStack(spacing: iconSystem == "magnifyingglass" ? 10 : 2) {
                Image(systemName: iconSystem)
                    .font(name: FontConfig.default.robotoBold,
                          size: FontSizeConfig.default.text)
                    .foregroundColor(Color.secondaryText)
                // Search text field
                ZStack (alignment: .leading) {
                    if searchText.isEmpty {
                        Text(self.placeholder)
                            .foregroundColor(Color.secondaryDark)
                    }
                    if isTxfKit {
                        TextFieldCustom(placeholder: "",
                                        text: $searchText,
                                        fontType: FontConfig.default.robotoRegular,
                                        fontSize: FontSizeConfig.default.text,
                                        color: UIColor.secondaryText,
                                        height: height,
                                        alignment: .left,
                                        xText: .zero,
                                        keyboardType: .default,
                                        returnKey: .search,
                                        showKeyboard: show,
                                        closeKeyboard: close,
                                        shouldReturn: { txf in
                                            self.show = false
                                            self.close = true
                                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + self.duration) {
                                                self.close = false
                                            }
                                            return true
                        },
                                        shouldChange: shouldChange!)
                            .frame(height: height)
                            .foregroundColor(Color.secondaryText)
                    } else {
                        TextField("",
                                  text: $searchText,
                                  onEditingChanged: { isEditing in },
                                  onCommit: onCommit!).foregroundColor(Color.secondaryText)
                    }
                }
                // Clear button
                Button(action: {
                    self.searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill").opacity(searchText == "" ? 0 : 1)
                }
            }
            .padding(.vertical,paddingVertical)
            .padding(.horizontal,paddingHorizontal)
                .foregroundColor(Color.background) // For magnifying glass and placeholder test
                .background(Color.background)
                .cornerRadius(cornerRadius)
            
            // Cancel button
            Button("TEXT_CANCEL".localized) {
                UIApplication.shared.endEditing(true) // this must be placed before the other commands here
                self.searchText = ""
                self.onCancel()
            }
            .foregroundColor(Color.primaryText)
            
        }
        .padding(.horizontal)
    }
}

extension UIApplication {
    func endEditing(_ force: Bool) {
        self.windows
            .filter{$0.isKeyWindow}
            .first?
            .endEditing(force)
    }
}

struct ResignKeyboardOnDragGesture: ViewModifier {
    var gesture = DragGesture().onChanged{_ in
        UIApplication.shared.endEditing(true)
    }
    func body(content: Content) -> some View {
        content.gesture(gesture)
    }
}

extension View {
    func resignKeyboardOnDragGesture() -> some View {
        modifier(ResignKeyboardOnDragGesture())
    }
}


struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView(isTxfKit: false,
                      searchText: .constant(""),
                      onCommit: {},
                      onCancel: {})
    }
}
