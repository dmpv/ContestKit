//
//  AppConfigState+helpers.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 31.01.2021.
//

import Foundation

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
