//
//  RDXKit.Hook.swift
//  Messenger
//
//  Created by Dmitry Purtov on 20.12.2020.
//  Copyright © 2020 SoftPro. All rights reserved.
//

import Foundation

extension RDXKit {
    static func makeHookMiddleware<StateT>(config: DispatchHookConfig<StateT, AnyAction<StateT>>) -> Middleware<Store<StateT>, AnyAction<StateT>> {
        return { store, next in
            var isProxy = false
            return { action in
                switch action.unbox {
                case is ProxyAction<StateT>:
                    isProxy = true
                    let oldState = store.state
                    config.preHook?(oldState, action)
                    next(action)
                    config.postHook?(oldState, store.state, action)
                default:
                    let oldState = store.state
                    config.preHook?(oldState, action)
                    next(action)
                }
            }
        }
    }

    struct DispatchHookConfig<StateT, ActionT: Action> {
        typealias PreHook = (_ state: StateT, _ action: ActionT) -> Void
        typealias PostHook = (_ oldState: StateT, _ newState: StateT, _ action: ActionT) -> Void
        var preHook: PreHook?
        var postHook: PostHook?

        init(preHook: PreHook? = nil, postHook: PostHook? = nil) {
            self.preHook = preHook
            self.postHook = postHook
        }
    }
}
