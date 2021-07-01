//
//  RDXKit.Thunk.swift
//  Messenger
//
//  Created by Dmitry Purtov on 20.12.2020.
//  Copyright © 2020 SoftPro. All rights reserved.
//

import Foundation

import LensKit

extension RDXKit {
    public struct Thunk<StoreT: StoreType>: Action {
        public typealias Body = (StoreT) -> Void

        let body: Body

        public init(body: @escaping Body) {
            self.body = body
        }

        public func adjust(_ state: inout StoreT.State) {
            assertionFailure("No ThunkMiddleware applied to the Store<\(StoreT.State.self)>")
        }
    }

    public static func makeThunkMiddleware<StoreT: StoreType>() -> Middleware<StoreT, AnyAction<StoreT.State>> {
        return { store, next in
            return { action in
                switch action.unbox {
                case let thunk as Thunk<StoreT>:
                    thunk.body(store)
                default:
                    next(action)
                }
            }
        }
    }
}

extension RDXKit.Thunk {
    // dp-NOTE: "поднимает" действие Thunk на superstate
    // Аналогично converted у обычных экшенов
    // dp-redux-TODO: Привести converted и uplifted к общей концепции
    func uplifted<SuperstateT: Equatable>(
        with proxyConfig: RDXKit.ProxyConfig<SuperstateT, StoreT.State>
    ) -> RDXKit.Thunk<RDXKit.Store<SuperstateT>> {
        RDXKit.Thunk { superstateStore in
            let proxyStore = StoreT(state: proxyConfig.lens.get(superstateStore.state))
            proxyStore.apply(middleware: RDXKit.makeProxyMiddleware(store: superstateStore, actionMap: proxyConfig.actionMap))
            proxyStore.apply(middleware: RDXKit.makeThunkMiddleware())
            body(proxyStore)
        }
    }

    func uplifted<SuperstateT: Equatable>(
        with lens: Lens<SuperstateT, StoreT.State?>,
        actionMap: @escaping RDXKit.ActionMap<SuperstateT, StoreT.State>
    ) -> RDXKit.Thunk<RDXKit.Store<SuperstateT>> {
        RDXKit.Thunk { superstateStore in
            guard let state = lens.get(superstateStore.state) else { return }
            let proxyConfig = RDXKit.ProxyConfig(
                lens: lens.unwrapped(with: state),
                actionMap: actionMap
            )
            let proxyStore = StoreT(state: proxyConfig.lens.get(superstateStore.state))
            proxyStore.apply(middleware: RDXKit.makeProxyMiddleware(store: superstateStore, actionMap: proxyConfig.actionMap))
            proxyStore.apply(middleware: RDXKit.makeThunkMiddleware())
            body(proxyStore)
        }
    }
}
