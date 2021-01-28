//
//  AppState.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 27.01.2021.
//

import Foundation

public struct AppState: StateType {
    var config: AppConfigState = .init()

    public init(config: AppConfigState = .init()) {
        self.config = config
    }
}
