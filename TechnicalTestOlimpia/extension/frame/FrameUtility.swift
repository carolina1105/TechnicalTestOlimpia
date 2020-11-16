//
//  FrameUtility.swift
//  TechnicalTestOlimpia
//
//  Created by Laddy Diaz Lamus on 14/11/20.
//

import UIKit

extension CGFloat {
    func clamp(_ a: CGFloat, _ b: CGFloat) -> CGFloat {
      return CGFloat(Double(self).clamp(Double(a), Double(b)))
    }
    
    // Linear interpolation
    func lerp(_ minValue: CGFloat, _ maxValue: CGFloat) -> CGFloat {
        return FloatLerp(minValue, maxValue, self)
    }
    
    // Inverse linear interpolation
    func inverseLerp(_ minValue: CGFloat, _ maxValue: CGFloat, shouldClamp: Bool = false) -> CGFloat {
        let value = FloatInverseLerp(self, minValue, maxValue)
        return (shouldClamp ? FloatClamp01(value) : value)
    }
}

extension Double {
    func clamp(_ a: Double, _ b: Double) -> Double {
      let minValue = a <= b ? a : b
      let maxValue = a <= b ? b : a
      return max(min(self, maxValue), minValue)
    }
}

extension CGPoint {
    @inlinable
    func distance(_ other: CGPoint) -> CGFloat {
        return sqrt(pow(x - other.x, 2) + pow(y - other.y, 2))
    }
    
    @inlinable
    func within(_ delta: CGFloat, of other: CGPoint) -> Bool {
        return distance(other) <= delta
    }
}
