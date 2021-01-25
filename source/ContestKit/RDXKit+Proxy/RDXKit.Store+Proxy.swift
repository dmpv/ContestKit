//
//  RDXKit.Store+proxy.swift
//  Messenger
//
//  Created by Dmitry Purtov on 20.12.2020.
//  Copyright © 2020 SoftPro. All rights reserved.
//

import Foundation

extension RDXKit.Store {
    func makeProxy<SubstateT>(config: RDXKit.ProxyConfig<StateT, SubstateT>) -> RDXKit.Store<SubstateT> {
        let proxyStore = RDXKit.Store(state: config.lens.get(state))
        proxyStore.apply(
            middleware: RDXKit.makeProxyMiddleware(store: self, actionMap: config.actionMap)
        )
        proxyStore.apply(middleware: RDXKit.makeThunkMiddleware())

        addObserver()
            .subscribeOnChanges { [weak proxyStore] state in
                proxyStore?.dispatch(RDXKit.ProxyAction(state: config.lens.get(state)))
            }
            .disposed(by: proxyStore.bag)

        return proxyStore
    }
}

extension RDXKit {
    struct ProxyConfig<StateT, SubstateT> {
        var lens: Lens<StateT, SubstateT>
        // dp-sticky-refactor-TODO: rename to actionTransform
        var actionMap: RDXKit.ActionMap<StateT, SubstateT>
    }
}

extension RDXKit.ProxyConfig {
    init(lens: Lens<StateT, SubstateT>) {
        self.init(lens: lens) { anySubaction in anySubaction.converted(with: lens) }
    }
}
