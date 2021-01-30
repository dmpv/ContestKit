//
//  AppState+substates.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 28.01.2021.
//

import Foundation

extension AppState {
    var pickerVC: ViewController.State {
        .init(
            title: L10n.stub("Animation Type")
        )
    }

    var editorVC: ViewController.State {
        .init(
            title: L10n.stub("Animation Settings"),
            leftBarButton: .init(
                title: L10n.stub("Cancel"),
                style: .plain
            ),
            rightBarButton: .init(
                title: L10n.stub("Apply"),
                style: .done,
                isEnabled: config.draftMessageAnimationConfigs != config.stableMessageAnimationConfigs
            )
        )
    }
}
