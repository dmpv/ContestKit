//
//  ViewController.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 30.01.2021.
//

import Foundation
import UIKit

class ViewController: UIViewController {
    var state: State? {
        didSet { stateDidChange(from: oldValue) }
    }

    var handlers = Handlers() {
        didSet { handlersDidChange() }
    }

    private var activated = false

    init(view: UIView) {
        super.init(nibName: nil, bundle: nil)
        self.view = view
        setup()
        activate()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError(.shouldNeverBeCalled()) }

    private func setup() {
        if #available(iOS 11.0, *) {
            viewRespectsSystemMinimumLayoutMargins = false
        }
        modalPresentationCapturesStatusBarAppearance = true
    }

    func activate() {
        guard !activated else { return fallback() }
        stateDidChange(from: state)
        activated = true
    }

    private func stateDidChange(from oldState: State?) {
        guard state != oldState || !activated else { return }

        title = state?.title

        if let rightBarButton = state?.rightBarButton {
            navigationItem.rightBarButtonItem = UIBarButtonItem().applying {
                $0.state = rightBarButton
                $0.target = self
                $0.action = #selector(didPressRightBarButton)
            }
        }

        if let leftBarButton = state?.leftBarButton {
            navigationItem.leftBarButtonItem = UIBarButtonItem().applying {
                $0.state = leftBarButton
                $0.target = self
                $0.action = #selector(didPressLeftBarButton)
            }
        }

        if state?.statusBarStyle != oldState?.statusBarStyle {
            UIView.animate { [self] in
                setNeedsStatusBarAppearanceUpdate()
            }
        }
    }

    private func handlersDidChange() {
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        state?.statusBarStyle ?? .default
    }

    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        .fade
    }

    @objc
    private func didPressLeftBarButton() {
        handlers.leftBarButton.onPress?()
    }

    @objc
    private func didPressRightBarButton() {
        handlers.rightBarButton.onPress?()
    }
}

extension ViewController {
    struct State: Equatable {
        var title: String?
        var leftBarButton: UIBarButtonItem.State?
        var rightBarButton: UIBarButtonItem.State?
        var statusBarStyle: UIStatusBarStyle = .default
    }

    struct Handlers {
        var leftBarButton: UIBarButtonItem.Handlers = .init()
        var rightBarButton: UIBarButtonItem.Handlers = .init()
    }
}

extension UIBarButtonItem {
    struct State: StateType {
        var title: String
        var style: UIBarButtonItem.Style = .plain
        var isEnabled = true
    }

    struct Handlers {
        var onPress: (() -> Void)?
    }
}

extension UIBarButtonItem {
    var state: State? {
        get {
            fatalError(.notImplementedYet)
        }
        set(newState) {
            title = newState?.title
            style = newState?.style ?? .plain
            isEnabled = newState?.isEnabled ?? true
        }
    }
}
