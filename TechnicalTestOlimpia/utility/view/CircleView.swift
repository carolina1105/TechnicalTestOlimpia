//
//  CircleView.swift
//  TechnicalTestOlimpia
//
//  Created by Laddy Diaz Lamus on 14/11/20.
//

import Foundation
import PureLayout

public class CircleView: UIView {

    @available(*, unavailable, message:"use other constructor instead.")
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public required init() {
        super.init(frame: .zero)
    }
 
    public required init(diameter: CGFloat) {
        super.init(frame: .zero)

        autoSetDimensions(to: CGSize(width: diameter, height: diameter))
    }

    @objc
    override public var frame: CGRect {
        didSet {
            updateRadius()
        }
    }

    @objc
    override public var bounds: CGRect {
        didSet {
            updateRadius()
        }
    }

    private func updateRadius() {
        self.layer.cornerRadius = self.bounds.size.height / 2
    }
}
