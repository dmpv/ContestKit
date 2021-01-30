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
    var fetchedMessageAnimationConfigs: [MessageAnimationConfigState]? {
        didSet { assert(fetchedMessageAnimationConfigs != []) }
    }
}

extension AppConfigState {
    public init() {
        self.init(
            stableMessageAnimationConfigs: Self.defaultMessageAnimationConfigs,
            draftMessageAnimationConfigs: Self.defaultMessageAnimationConfigs,
            fetchedMessageAnimationConfigs: nil
        )
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
}
