//
//  RowState.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 29.01.2021.
//

import Foundation

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
    var id: RowID {
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
