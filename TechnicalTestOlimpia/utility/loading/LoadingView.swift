//
//  LoadingView.swift
//  TechnicalTestOlimpia
//
//  Created by Laddy Diaz Lamus on 14/11/20.
//

import SwiftUI
import NVActivityIndicatorView

struct LoadingView: UIViewRepresentable {
    
    var color: UIColor? = UIColor.primaryText
    var dimension: CGFloat? = CGFloat(50.0)
    var type: NVActivityIndicatorType? = .ballClipRotatePulse
    var background: UIColor? = UIColor.black.withAlphaComponent(0.5)
    
    func makeUIView(context: UIViewRepresentableContext<LoadingView>) -> UIView {
        let frame = CGRect(x: 0, y: 0, width: dimension!, height: dimension!)
        let view = UIView(frame: frame)
        view.backgroundColor = background
        let origin = (dimension! / 4);
        let size = (dimension! / 2);
        let loadingFrame = CGRect(x: origin, y: origin, width: size, height: size)
        let loading = NVActivityIndicatorView(frame: loadingFrame,
                                              type: type,
                                              color: color,
                                              padding: nil)
        loading.startAnimating()
        view.addSubview(loading)
        return view
    }
    
    func updateUIView(_ uiView: UIView,
                      context: UIViewRepresentableContext<LoadingView>) {
    }
    
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
