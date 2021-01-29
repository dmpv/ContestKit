//
//  SectionedListState.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 28.01.2021.
//

import Foundation

public struct SectionedListState: StateType {
    var sections: [SectionState] = []
}

enum SectionState: Equatable {
    case common(rows: [RowState])
    case timing(MessageAnimationTimingID, rows: [RowState])
}

extension SectionState {
    var rows: [RowState] {
        get {
            switch self {
            case .common(let rows),
                 .timing(_, let rows):
                return rows
            }
        }
        set(newRows) {
            guard newRows.map(\.id) == rows.map(\.id) else { return fallback() }
            switch self {
            case .common:
                self = .common(rows: newRows)
            case .timing(let timing, _):
                self = .timing(timing, rows: newRows)
            }
        }
    }
}

enum SectionID: IDType {
    case common
    case timing(MessageAnimationTimingID)
}

extension SectionState: StateType, CKIdentifiable {
    var id: SectionID {
        switch self {
        case .common:
            return .common
        case .timing(let timingID, _):
            return .timing(timingID)
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

extension TimeInterval {
    var frameCountFormatted: String {
        let frameCount = Int(self * 60)
        return L10n.stub("\(frameCount)f")
    }
}

extension TimeInterval {
    var pickerCellOptionTitle: String {
        let suffix = self == 1 ? " " + L10n.stub("(1 sec)") : ""
        return frameCountFormatted + suffix
    }
}

extension PickerRowState: CKIdentifiable {
    var id: PickerRowID {
        switch self {
        case .messageAnimationID:
            return .messageAnimationID
        case .messageAnimationDuration:
            return .messageAnimationDuration
        }
    }
}

public enum ButtonRowID: StateType {
    case share
    case fetch
    case restore
}

public enum ButtonRowState: StateType {
    case share
    case fetch
    case restore
}

extension ButtonRowState: CKIdentifiable {
    var id: ButtonRowID {
        switch self {
        case .share:
            return .share
        case .fetch:
            return .fetch
        case .restore:
            return .restore
        }
    }
}
