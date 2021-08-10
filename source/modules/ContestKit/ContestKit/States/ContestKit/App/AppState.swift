//
//  AppState.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 27.01.2021.
//

import Foundation

import ToolKit

public struct AppState: StateType {
    var config: AppConfigState = .init()
    var selectedConfigID: MessageAnimationConfigID

    public init(config: AppConfigState = .init()) {
        self.config = config
        selectedConfigID = config.draftMessageAnimationConfigs[0].id
    }
}
