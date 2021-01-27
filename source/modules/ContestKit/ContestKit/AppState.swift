//
//  AppState.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 27.01.2021.
//

import Foundation

public struct AppState: ValueType, Equatable {
    var config: ConfigState = .init()

    public init(config: ConfigState = .init()) {
        self.config = config
    }
}

public struct ConfigState: ValueType, Equatable {
    var animationConfig: AnimationConfigState = .init()
    var defaultAnimationConfig: AnimationConfigState = .init()

    public init(
        animationConfig: AnimationConfigState = .init(),
        defaultAnimationConfig: AnimationConfigState = .init()
    ) {
        self.animationConfig = animationConfig
        self.defaultAnimationConfig = defaultAnimationConfig
    }
}

public struct AnimationConfigState: ValueType, Equatable {
    var message: MessageAnimationConfigState = .init()

    public init(
        message: MessageAnimationConfigState = .init()
    ) {
        self.message = message
    }
}

extension MessageAnimationConfigState {
    var editorView: EditorView.State {
        .init(
            typePickerCell: .init(name: "Type"),
            durationPickerCell: .init(name: "Duration"),
            shareButtonCell: .init(name: "Share"),
            importButtonCell: .init(name: "Import"),
            restoreDefaultsButtonCell: .init(name: "Defaults"),
            timingCells: []
        )
    }
}
