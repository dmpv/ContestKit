//
//  AppConfigState.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 30.01.2021.
//

import Foundation

public struct AppConfigState: StateType {
    var stableMessageAnimationConfigs: [MessageAnimationConfigState] {
        didSet { assert(stableMessageAnimationConfigs != []) }
    }

    var draftMessageAnimationConfigs: [MessageAnimationConfigState] {
        didSet { assert(draftMessageAnimationConfigs != []) }
    }

    var importedMessageAnimationConfigs: [MessageAnimationConfigState]? {
        didSet { assert(importedMessageAnimationConfigs != []) }
    }

    var importableMessageAnimationConfigs: [MessageAnimationConfigState]? {
        didSet { assert(importedMessageAnimationConfigs != []) }
    }

    var durations: [TimeInterval]
}

extension AppConfigState {
    public init() {
        self.init(
            stableMessageAnimationConfigs: Self.defaultMessageAnimationConfigs,
            draftMessageAnimationConfigs: Self.defaultMessageAnimationConfigs,
            importedMessageAnimationConfigs: nil,
            durations: Self.defaultDurations
        )
    }
}

extension AppConfigState {
    var durationSelection: SelectionState<TimeInterval> {
        get {
            assert(draftMessageAnimationConfigs.map(\.duration).unique.count == 1)
            return .init(
                values: durations,
                selectedValue: draftMessageAnimationConfigs[0].duration
            )
        }
        set(newDurationSelection) {
            assert(newDurationSelection.values == durationSelection.values)
            for index in draftMessageAnimationConfigs.indices {
                draftMessageAnimationConfigs[index].duration = newDurationSelection.selectedValue
            }
        }
    }
}

extension AppConfigState {
    var allConfigsAreEqual: Bool {
        draftMessageAnimationConfigs == stableMessageAnimationConfigs
            && draftMessageAnimationConfigs == importedMessageAnimationConfigs
            && draftMessageAnimationConfigs == importableMessageAnimationConfigs
    }
}

extension AppConfigState {
    static let defaultMessageAnimationConfigs: [MessageAnimationConfigState] = [
        .smallText([
            .positionX(.makeDefault()),
            .positionY(.makeDefault())
        ]),
        .bigText([
            .positionX(.makeDefault()),
            .positionY(.makeDefault())
        ]),
        .linkWithPreview([
            .positionX(.makeDefault()),
            .positionY(.makeDefault())
        ]),
        .singleEmoji([
            .positionX(.makeDefault()),
            .positionY(.makeDefault())
        ]),
        .sticker([
            .positionX(.makeDefault()),
            .positionY(.makeDefault())
        ]),
        .voiceMessage([
            .positionX(.makeDefault()),
            .positionY(.makeDefault())
        ]),
        .videoMessage([
            .positionX(.makeDefault()),
            .positionY(.makeDefault())
        ]),
    ]

    static let defaultDurations: [TimeInterval] = [0.5, 0.75, 1]
}
