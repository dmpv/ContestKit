//
//  ui.misc.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 28.01.2021.
//

import Foundation
import UIKit

public typealias Style<ViewT> = (ViewT) -> Void

public protocol Styleable {}

public extension Styleable {
    @discardableResult
    func applying(_ style: Style<Self>) -> Self {
        style(self)
        return self
    }
}

extension NSObject: Styleable {}

let noAutoresize: Style<UIView> = {
    $0.translatesAutoresizingMaskIntoConstraints = false
}

extension UIEdgeInsets: ValueType {}


func perform(animated: Bool, execute: @escaping () -> Void) {
    perform(with: animated ? AnimationConfig() : nil, execute: execute)
}

func perform(with animationConfig: AnimationConfig?, execute: @escaping () -> Void) {
    if let animationConfig = animationConfig {
        UIView.animate(with: animationConfig) { execute() }
    } else {
        execute()
    }
}

struct AnimationConfig {
    var options: UIView.AnimationOptions = [
        .curveEaseInOut,
        .beginFromCurrentState,
        .allowUserInteraction,
    ]
    var duration: Duration = .medium
    var delay: TimeInterval = 0
}

extension AnimationConfig {
    enum Duration: TimeInterval {
        case short = 0.2
        case medium = 0.4
        case long = 0.6
    }
}

extension UIView {
    static func animate(with config: AnimationConfig, animations: @escaping () -> Void) {
        animate(withDuration: config.duration.rawValue, delay: config.delay, options: config.options, animations: animations, completion: nil)
    }

    static func animate(with animations: @escaping () -> Void) {
        animate(with: AnimationConfig(), animations: animations)
    }
}
