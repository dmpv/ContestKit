//
//  RDXKit.Action.swift
//  Messenger
//
//  Created by Dmitry Purtov on 20.12.2020.
//  Copyright © 2020 SoftPro. All rights reserved.
//

import Foundation

public protocol RDXKitAction: CustomDebugStringConvertible {
    associatedtype State
    func adjust(_ state: inout State)

    var id: String { get }
}

extension RDXKit {
    public typealias Action = RDXKitAction
}

extension RDXKit.Action {
    var id: String {
        "\(Self.self)"
    }

    func boxed() -> RDXKit.AnyAction<State> {
        .init(self)
    }

    func reduce(_ state: State) -> State {
        var state = state
        adjust(&state)
        return state
    }

    func converted<SuperstateT>(with lens: Lens<SuperstateT, State>) -> RDXKit.AnyAction<SuperstateT> {
        RDXKit.Custom(id: "\(SuperstateT.self)::\(id)") { superstate in
            lens.set(&superstate, reduce(lens.get(superstate)))
        }.boxed()
    }

    func converted<SuperstateT>(with lens: Lens<SuperstateT, State?>) -> RDXKit.AnyAction<SuperstateT> {
        RDXKit.Custom(id: "\(SuperstateT.self)::\(id)") { superstate in
            guard let state = lens.get(superstate) else { return }
            lens.set(&superstate, reduce(state))
        }.boxed()
    }

    public var debugDescription: String {
        "\(type(of: self))"
    }
}

extension RDXKit {
    struct Custom<StateT>: Action {
        let id: String
        let adjustBody: (inout StateT) -> Void

        func adjust(_ state: inout StateT) {
            adjustBody(&state)
        }
    }
}

extension RDXKit.StoreType {
    func dispatchCustom(_ id: String = "", adjustBody: @escaping (inout State) -> Void) {
        dispatch(RDXKit.Custom(id: id, adjustBody: adjustBody))
    }
}

extension RDXKit.Custom {
    var debugDescription: String {
        "Custom/\(id)"
    }
}
