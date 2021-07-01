//
//  RDXKit.Middleware.swift
//  Messenger
//
//  Created by Dmitry Purtov on 20.12.2020.
//  Copyright © 2020 SoftPro. All rights reserved.
//

import Foundation

public protocol RDXKitStoreType {
    associatedtype State: Equatable

    var state: State { get }

    init(state: State)

    func apply(middleware: @escaping RDXKit.Middleware<Self, RDXKit.AnyAction<State>>)

    func dispatch<ActionT: RDXKitAction>(_ action: ActionT) where ActionT.State == State
}

extension RDXKit {
    public typealias StoreType = RDXKitStoreType
    public typealias Middleware<StoreT: StoreType, ActionT: Action> = (StoreT, @escaping Dispatch<ActionT>) -> Dispatch<ActionT>
}
