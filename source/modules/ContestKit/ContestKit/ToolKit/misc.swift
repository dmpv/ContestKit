//
//  misc.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 25.01.2021.
//

import Foundation

protocol CKIdentifiable {
    associatedtype ID: Hashable

    var id: Self.ID { get }
}


extension Array where Element: CKIdentifiable {
    subscript(safe id: Element.ID) -> Element? {
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

extension Array where Element: CKIdentifiable {
    subscript(id: Element.ID) -> Element {
        get {
            self[safe: id]!
        }
        set {
            self[safe: id] = newValue
        }
    }
}

extension Array where Element: Equatable {
    var areUnique: Bool {
        unique.count == count
    }

    var unique: Self {
        reduce([]) { partialUnique, element in
            partialUnique.contains(element) ? partialUnique : partialUnique + [element]
        }
    }
}

protocol StateType: ValueType, Equatable {}

protocol IDType: ValueType, Hashable {}

class L10n: Namespace {
    static func stub(_ string: String) -> String {
        NSLocalizedString(string, comment: "")
    }
}

class Stub: Namespace {
    static func make<ValueT>(_ value: ValueT) -> ValueT {
        value
    }
}
