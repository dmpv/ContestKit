//
//  ValueType.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 27.01.2021.
//

import Foundation

public protocol ValueType {
    typealias Reducer = (Self) -> Self
    typealias Adjuster = (inout Self) -> Void
}

extension ValueType {
    public func reduce(with adjuster: Adjuster) -> Self {
        var value = self
        adjuster(&value)
        return value
    }

    public mutating func adjust(with adjuster: Adjuster) {
        adjuster(&self)
    }
}
