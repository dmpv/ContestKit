//
//  Store.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 13.08.2021.
//

import Foundation

import ToolKit

class Str<StateT: StateType> {
    private(set) var state: StateT

    private(set) lazy var stateObservable = Observable(value: state)

    private var broadcasting: Any?

    init(state: StateT) {
        self.state = state
    }

    func adjust(with adjuster: @escaping (inout StateT) -> Void) {
        dispatch { store in
            store.state.adjust(with: adjuster)
        }
    }

    func dispatch(_ action: @escaping (Str<StateT>) -> Void) {
        action(self)
        if let _ = broadcasting {
            fatalError(.shouldNeverBeCalled())
        }
        broadcasting = action
        stateObservable.value = state
        broadcasting = nil
    }
}
