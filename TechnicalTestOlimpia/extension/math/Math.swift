//
//  Math.swift
//  TechnicalTestOlimpia
//
//  Created by Laddy Diaz Lamus on 14/11/20.
//

import Foundation
import UIKit

func FloatClamp(_ value: CGFloat,
                _ minValue: CGFloat,
                _ maxValue: CGFloat) -> CGFloat {
    return max(minValue, min(maxValue, value))
}

func FloatClamp01(_ value: CGFloat) -> CGFloat {
    return FloatClamp(value, 0.0, 1.0)
}

func FloatLerp(_ left: CGFloat,
               _ right: CGFloat,
               _ alpha: CGFloat) -> CGFloat {
    return (left * (1.0 - alpha) + (right * alpha))
}

func FloatInverseLerp(_ value: CGFloat,
                      _ minValue: CGFloat,
                      _ maxValue: CGFloat) -> CGFloat {
    return (value - minValue) / (maxValue - minValue)
}
