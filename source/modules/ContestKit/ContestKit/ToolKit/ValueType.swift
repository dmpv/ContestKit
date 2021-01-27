//
//  ValueType.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 27.01.2021.
//

import Foundation

protocol ValueType {
    typealias Reducer = (Self) -> Self
    typealias Adjuster = (inout Self) -> Void
}

extension ValueType {
    func reduce(with adjuster: Adjuster) -> Self {
        var value = self
        adjuster(&value)
        return value
    }

    mutating func adjust(with adjuster: Adjuster) {
        adjuster(&self)
    }
}
