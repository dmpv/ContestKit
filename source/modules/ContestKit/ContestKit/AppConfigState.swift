//
//  AppConfigState.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 30.01.2021.
//

import Foundation

public struct AppConfigState: StateType {
    var messageAnimationConfigs: [MessageAnimationConfigState] = []
    var defaultMessageAnimationConfigs: [MessageAnimationConfigState] = []

    public init(
        messageAnimationConfigs: [MessageAnimationConfigState] = [],
        defaultMessageAnimationConfigs: [MessageAnimationConfigState] = []
    ) {
        self.messageAnimationConfigs = messageAnimationConfigs
        self.defaultMessageAnimationConfigs = defaultMessageAnimationConfigs
    }
}

extension AppConfigState {
    static let initialMessageAnimationConfigs: [MessageAnimationConfigState] = [
        .smallText([
            .positionX(.makeDefault(totalDuration: 1)),
            .positionY(.makeDefault(totalDuration: 1))
        ]),
        .bubble([
            .bubbleShape(.makeDefault(totalDuration: 1))
        ]),
    ]
}
