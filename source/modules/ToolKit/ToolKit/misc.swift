//
//  misc.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 25.01.2021.
//

import Foundation

public protocol CKIdentifiable {
    associatedtype ID: Hashable

    var id: Self.ID { get }
}


extension Array where Element: CKIdentifiable {
    public subscript(safe id: Element.ID) -> Element? {
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

    public subscript(id: Element.ID) -> Element {
        get {
            self[safe: id]!
        }
        set {
            self[safe: id] = newValue
        }
    }
}

extension Array where Element: Equatable {
    public var areUnique: Bool {
        unique.count == count
    }

    public var unique: Self {
        reduce([]) { partialUnique, element in
            partialUnique.contains(element) ? partialUnique : partialUnique + [element]
        }
    }
}

public protocol StateType: ValueType, Equatable {}

public protocol IDType: ValueType, Hashable {}

public class L10n: Namespace {
    public static func stub(_ string: String) -> String {
        NSLocalizedString(string, comment: "")
    }
}

class Stub: Namespace {
    static func make<ValueT>(_ value: ValueT) -> ValueT {
        value
    }
}
