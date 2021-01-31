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
    case messageAnimations(rows: [RowState])
    case backgroundAnimation(rows: [RowState])

    case common(rows: [RowState])
    case timing(MessageAnimationTimingID, rows: [RowState])
}

extension SectionState {
    var rows: [RowState] {
        get {
            switch self {
            case .common(let rows),
                 .timing(_, let rows),
                 .messageAnimations(let rows),
                 .backgroundAnimation(let rows):
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
            case .messageAnimations:
                self = .messageAnimations(rows: newRows)
            case .backgroundAnimation:
                self = .backgroundAnimation(rows: newRows)
            }
        }
    }
}

enum SectionID: IDType {
    case messageAnimations
    case backgroundAnimation
    case common
    case timing(MessageAnimationTimingID)
}

extension SectionState: StateType, CKIdentifiable {
    var id: SectionID {
        switch self {
        case .messageAnimations:
            return .messageAnimations
        case .backgroundAnimation:
            return .backgroundAnimation
        case .common:
            return .common
        case .timing(let timingID, _):
            return .timing(timingID)
        }
    }
}

extension TimeInterval {
    func frameCountFormatted(verbose: Bool) -> String {
        let frameCount = Int(self * 60)
        return L10n.stub("\(frameCount)f")
            + (verbose && (self == 1) ? L10n.stub(" (1 sec)") : "")
    }
}
