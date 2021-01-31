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
