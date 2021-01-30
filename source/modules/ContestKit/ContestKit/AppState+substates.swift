//
//  AppState+substates.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 28.01.2021.
//

import Foundation
import UIKit

extension AppState {
    var configIDSelection: SelectionState<MessageAnimationConfigID> {
        get {
            .init(
                values: config.draftMessageAnimationConfigs.map(\.id),
                selectedValue: config.draftMessageAnimationConfigs[selectedConfigID].id
            )
        }
        set(newConfigIDSelection) {
            assert(newConfigIDSelection.values == configIDSelection.values)
            selectedConfigID = newConfigIDSelection.selectedValue
        }
    }

    var selectedConfig: MessageAnimationConfigState {
        get {
            config.draftMessageAnimationConfigs[selectedConfigID]
        }
        set(newSelectedConfig) {
            assert(newSelectedConfig.id == selectedConfig.id)
            config.draftMessageAnimationConfigs[newSelectedConfig.id] = newSelectedConfig
        }
    }

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

    var durationActionSheet: UIAlertController.State {
        .init(
            title: L10n.stub("Duration"),
            style: .actionSheet,
            actions: config.durationSelection.values.map { duration in
                .init(
                    title: duration.pickerCellOptionTitle,
                    style: .default
                )
            } + [
                .init(
                    title: L10n.stub("Cancel"),
                    style: .cancel
                )
            ]
        )
    }

    var shareActionSheet: UIAlertController.State {
        .init(
            title: L10n.stub("Share"),
            style: .actionSheet,
            actions: [
                .init(
                    title: L10n.stub("Copy to Clipboard"),
                    style: .default
                ),
                .init(
                    title: "Cancel",
                    style: .cancel
                )
            ]
        )
    }

    var importActionSheet: UIAlertController.State {
        .init(
            title: L10n.stub("Import"),
            style: .actionSheet,
            actions: [
                .init(
                    title: L10n.stub("Import from Clipboard"),
                    style: .default
                ),
                .init(
                    title: "Cancel",
                    style: .cancel
                )
            ]
        )
    }
}
