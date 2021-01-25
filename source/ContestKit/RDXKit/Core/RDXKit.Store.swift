//
//  RDXKit.Store.swift
//  Messenger
//
//  Created by Dmitry Purtov on 20.12.2020.
//  Copyright © 2020 SoftPro. All rights reserved.
//

import Foundation

extension RDXKit {
    typealias Dispatch<ActionT: Action> = (ActionT) -> Void

    final class Store<StateT: Equatable>: StoreType {
        private(set) var state: StateT

        private(set) var disposable = Disposable()

        private lazy var dispatchBody: Dispatch<AnyAction<StateT>> = { [weak self] action in
            assert(Thread.isMainThread)
            guard let self = self else { return }
            action.adjust(&self.state)
        }

        func apply(middleware: @escaping Middleware<Store, AnyAction<StateT>>) {
            let dispatchBody = self.dispatchBody
            self.dispatchBody = { [weak self] action in
                guard let self = self else { return }
                middleware(self, dispatchBody)(action)
            }
        }

        private(set) lazy var stateObservable = Observable(value: state)

        var broadcasting: AnyAction<StateT>?

        func dispatch<ActionT: Action>(_ action: ActionT) where ActionT.State == StateT {
            dispatchBody(action.boxed())
            if let _ = broadcasting {
                fatalError(.shouldNeverBeCalled())
            }
            broadcasting = action.boxed()
            stateObservable.value = state
            broadcasting = nil
        }

        init(state: StateT) {
            self.state = state
        }
    }
}
