//
//  ViewExtension.swift
//  TechnicalTestOlimpia
//
//  Created by Laddy Diaz Lamus on 14/11/20.
//

import UIKit

extension UIView {
    var parent: UIViewController? {
        var responder: UIResponder? = self
        while responder != nil {
            responder = responder?.next
            if let controller = responder as? UIViewController {
                return controller
            }
        }
        return nil
    }
    
    func autoPin(to ratio: CGFloat) -> NSLayoutConstraint {
        return autoPin(to: ratio,
                       relation: .equal)
    }
    
    func autoPin(to ratio: CGFloat,
                 relation: NSLayoutConstraint.Relation) -> NSLayoutConstraint {
        let clamped = FloatClamp(ratio, 0.05, 95.0)
        if clamped != ratio {
            print("Invalid aspect ratio: %f for view: %@", ratio, self)
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: .width,
                                            relatedBy: relation,
                                            toItem: self,
                                            attribute: .height,
                                            multiplier: clamped,
                                            constant: .zero)
        constraint.autoInstall()
        return constraint
    }
    
    func width() -> CGFloat {
        self.frame.size.width
    }
    
    func height() -> CGFloat {
        self.frame.size.height
    }
    
    func autoHCenter() -> NSLayoutConstraint {
        return self.autoAlignAxis(.vertical, toSameAxisOf: superview!)
    }
    
    func autoVCenter() -> NSLayoutConstraint {
        return self.autoAlignAxis(.horizontal, toSameAxisOf: superview!)
    }
    
    func autoPinToSuperviewMargins() -> [NSLayoutConstraint] {
        let result = [
            self.autoPinTopMargin(),
            self.autoPinLeadingMargin(),
            self.autoPinTrailingMargin(),
            self.autoPinBottomMargin()
        ]
        return result
    }
    
    func autoPinTopMargin() -> NSLayoutConstraint {
        return autoPinTopMargin(with: .zero)
    }
    
    func autoPinTopMargin(with inset: CGFloat) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        
        let constraint = topAnchor.constraint(equalTo: superview!.layoutMarginsGuide.topAnchor, constant: inset)
        constraint.isActive = true
        return constraint
    }
    
    func autoPinLeadingMargin() -> NSLayoutConstraint {
        return autoPinLeadingMargin(with: .zero)
    }
    
    func autoPinLeadingMargin(with inset: CGFloat) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        
        let constraint = leadingAnchor.constraint(equalTo: superview!.layoutMarginsGuide.leadingAnchor, constant: inset)
        constraint.isActive = true
        return constraint
    }
    
    func autoPinTrailingMargin() -> NSLayoutConstraint {
        return autoPinTrailingMargin(with: .zero)
    }
    
    func autoPinTrailingMargin(with inset: CGFloat) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        
        let constraint = trailingAnchor.constraint(equalTo: superview!.layoutMarginsGuide.trailingAnchor, constant: inset)
        constraint.isActive = true
        return constraint
    }
    
    func autoPinBottomMargin() -> NSLayoutConstraint {
        return autoPinBottomMargin(with: .zero)
    }
    
    func autoPinBottomMargin(with inset: CGFloat) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        
        let constraint = bottomAnchor.constraint(equalTo: superview!.layoutMarginsGuide.bottomAnchor, constant: inset)
        constraint.isActive = true
        return constraint
    }
    
    func fadeIn(duration: TimeInterval = 0.5,
                delay: TimeInterval = 0.0,
                completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in }) {
        UIView.animate(withDuration: duration,
                       delay: delay,
                       options: .curveEaseIn,
                       animations: {
                        self.alpha = 1.0
        }, completion: completion)
    }

    func fadeOut(duration: TimeInterval = 0.5,
                 delay: TimeInterval = 0.0,
                 completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in }) {
        UIView.animate(withDuration: duration,
                       delay: delay,
                       options: .curveEaseIn,
                       animations: {
                        self.alpha = 0.0
        }, completion: completion)
    }
}
