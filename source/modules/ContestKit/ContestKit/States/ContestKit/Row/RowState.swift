//
//  RowState.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 29.01.2021.
//

import Foundation

import ToolKit

public enum RowID: IDType {
    case picker(PickerRowID)
    case button(ButtonRowID)
    case animationTiming(MessageAnimationTimingID)
}

public enum RowState: StateType {
    case picker(PickerRowState)
    case button(ButtonRowState)
    case animationTiming(MessageAnimationTimingState)
}

extension RowState: CKIdentifiable {
    public var id: RowID {
        switch self {
        case .picker(let pickerRow):
            return .picker(pickerRow.id)
        case .button(let buttonRow):
            return .button(buttonRow.id)
        case .animationTiming(let messageAnimationTiming):
            return .animationTiming(messageAnimationTiming.id)
        }
    }
}

public enum PickerRowID: StateType {
    case messageAnimationID
    case messageAnimationDuration
}

public enum PickerRowState: StateType {
    case messageAnimationID(MessageAnimationConfigID)
    case messageAnimationDuration(TimeInterval)
}

extension PickerRowState: CKIdentifiable {
    public var id: PickerRowID {
        switch self {
        case .messageAnimationID:
            return .messageAnimationID
        case .messageAnimationDuration:
            return .messageAnimationDuration
        }
    }
}

public enum ButtonRowID: IDType {
    case share
    case `import`
    case restore
    case messageAnimation(id: MessageAnimationConfigID)
}

public enum ButtonRowState: StateType {
    case share
    case `import`
    case restore
    case messageAnimation(id: MessageAnimationConfigID)
}

extension ButtonRowState: CKIdentifiable {
    public var id: ButtonRowID {
        switch self {
        case .share:
            return .share
        case .import:
            return .import
        case .restore:
            return .restore
        case .messageAnimation(let id):
            return .messageAnimation(id: id)
        }
    }
}
