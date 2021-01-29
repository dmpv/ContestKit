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
