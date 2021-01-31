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

    var hasUnappliedChanges: Bool {
        draftMessageAnimationConfigs != stableMessageAnimationConfigs
    }
}

extension AppConfigState {
    static let defaultMessageAnimationConfigs: [MessageAnimationConfigState] = [
        .smallText([
            .positionY(.makeDefault()),
            .positionX(.makeDefault()),
            .bubbleShape(.makeDefault()),
            .textPosition(.makeDefault()),
            .colorChange(.makeDefault()),
            .timeAppears(.makeDefault()),
        ]),
        .bigText([
            .positionY(.makeDefault()),
            .positionX(.makeDefault()),
        ]),
        .linkWithPreview([
            .positionY(.makeDefault()),
            .positionX(.makeDefault()),
        ]),
        .singleEmoji([
            .positionY(.makeDefault()),
            .positionX(.makeDefault()),
            .emojiScale(.makeDefault()),
            .timeAppears(.makeDefault()),
        ]),
        .sticker([
            .positionY(.makeDefault()),
            .positionX(.makeDefault()),
        ]),
        .voiceMessage([
            .positionY(.makeDefault()),
            .positionX(.makeDefault()),
        ]),
        .videoMessage([
            .positionY(.makeDefault()),
            .positionX(.makeDefault()),
        ]),
    ]

    static let defaultDurations: [TimeInterval] = [0.5, 0.75, 1]
}
