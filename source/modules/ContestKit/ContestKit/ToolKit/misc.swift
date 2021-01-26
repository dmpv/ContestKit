//
//  misc.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 25.01.2021.
//

import Foundation

protocol CKIdentifiable {
    associatedtype ID : Hashable

    var id: Self.ID { get }
}


extension Array where Element: CKIdentifiable {
    subscript(id: Element.ID) -> Element? {
        get {
            let elements = filter { $0.id == id }
            assert(elements.count <= 1)
            return elements.first
        }
        set {
            guard let newValue = newValue else {
                removeAll(where: { $0.id == id })
                return
            }
            guard newValue.id == id else {
                fatalError(.shouldNeverBeCalled("Can't set \(type(of: newValue)) with id \(newValue.id) for id \(id)"))
            }
            if let index = firstIndex(where: { $0.id == id }) {
                self[index] = newValue
            } else {
                append(newValue)
            }
        }
    }
}
