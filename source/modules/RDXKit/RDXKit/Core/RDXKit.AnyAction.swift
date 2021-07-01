//
//  RDXKit.AnyAction.swift
//  Messenger
//
//  Created by Dmitry Purtov on 20.12.2020.
//  Copyright © 2020 SoftPro. All rights reserved.
//

import Foundation

extension RDXKit {
    public struct AnyAction<StateT>: RDXKitAction {
        let unbox: Any
        public let id: String
        private let adjustBody: (inout StateT) -> Void

        init<ActionT: Action>(_ unbox: ActionT) where ActionT.State == StateT {
            if let anyAction = unbox as? RDXKit.AnyAction<StateT> {
                self = anyAction
            } else {
                self.unbox = unbox
                id = unbox.id
                adjustBody = { state in unbox.adjust(&state) }
            }
        }

        public func adjust(_ state: inout StateT) {
            adjustBody(&state)
        }
    }
}
