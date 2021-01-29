//
//  CG.misc.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 29.01.2021.
//

import Foundation
import CoreGraphics

extension CGRect: ValueType {}

extension CGRect {
    var center: CGPoint {
        get {
            origin + CGPoint(size * 0.5)
        }
        set {
            origin = origin + newValue - center
        }
    }
}

extension CGPoint {
    static func + (lhs: Self, rhs: Self) -> Self {
        .init(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    static prefix func - (pt: Self) -> Self {
        .init(x: -pt.x, y: -pt.y)
    }

    static func - (lhs: Self, rhs: Self) -> Self {
        lhs + -rhs
    }

    init(_ size: CGSize) {
        self.init(x: size.width, y: size.height)
    }
}

extension CGSize {
    static func * (size: Self, multiplier: CGFloat) -> Self {
        .init(width: size.width * multiplier, height: size.height * multiplier)
    }
}
