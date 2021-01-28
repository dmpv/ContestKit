//
//  RowCell.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 29.01.2021.
//

import Foundation
import UIKit

protocol RowCell: UITableViewCell {
    var module: RowModule? { get set }

    var state: Any? { get set }

    var handlers: Any { get set }
}

extension RowCell {
    var state: Any? {
        get {
            fatalError(.notImplementedYet)
        }
        set(newState) {
            switch self {
            case let pickerCell as PickerCell:
                pickerCell.state = {
                    guard let newState = newState else { return nil }
                    return (newState as! PickerCell.State)
                }()
            case let buttonCell as ButtonCell:
                buttonCell.state = {
                    guard let newState = newState else { return nil }
                    return (newState as! ButtonCell.State)
                }()
            case let timingCell as AnimationTimingCell:
                timingCell.state = {
                    guard let newState = newState else { return nil }
                    return (newState as! AnimationTimingCell.State)
                }()
            default:
                fatalError(.shouldNeverBeCalled())
            }
        }
    }

    var handlers: Any {
        get {
            fatalError(.notImplementedYet)
        }
        set(newHandlers) {
            switch self {
            case let pickerCell as PickerCell:
                pickerCell.handlers = newHandlers as! PickerCell.Handlers
            case let buttonCell as ButtonCell:
                buttonCell.handlers = newHandlers as! ButtonCell.Handlers
            case let timingCell as AnimationTimingCell:
                timingCell.handlers = newHandlers as! AnimationTimingCell.Handlers
            default:
                fatalError(.shouldNeverBeCalled())
            }
        }
    }
}
