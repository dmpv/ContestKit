//
//  UIAlertController+component.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 30.01.2021.
//

import Foundation
import UIKit

extension UIAlertController {
    convenience init(state: State, handlers: Handlers) {
        self.init(title: state.title, message: state.message, preferredStyle: state.style)
        for index in state.actions.indices {
            addAction(
                .init(
                    state: state.actions[index],
                    handlers: handlers.actions[index]
                )
            )
        }
    }
}

extension UIAlertController {
    struct State: Equatable {
        var title: String?
        var message: String?
        var style: UIAlertController.Style
        var actions: [UIAlertAction.State] = []
    }

    struct Handlers {
        var actions: [UIAlertAction.Handlers]
    }
}

extension UIAlertAction {
    convenience init(state: State, handlers: Handlers) {
        self.init(
            title: state.title,
            style: state.style
        ) { _ in
            handlers.onPress?()
        }
        isEnabled = state.isEnabled
    }
}

extension UIAlertAction {
    struct State: Equatable {
        var title: String?
        var style: UIAlertAction.Style = .default
        var isEnabled = true
    }

    struct Handlers {
        var onPress: (() -> Void)?
    }
}
