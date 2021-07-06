//
//  AppState+substates.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 28.01.2021.
//

import Foundation
import UIKit

import ToolKit
import ComponentKit

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
        .make(
            title: L10n.stub("Animation Type")
        )
    }

    var editorVC: ViewController.State {
        .make(
            title: L10n.stub("Animation Settings"),
            leftBarButton: .make(
                title: L10n.stub("Cancel"),
                style: .plain
            ),
            rightBarButton: .make(
                title: L10n.stub("Apply"),
                style: .done,
                isEnabled: config.hasUnappliedChanges
            )
        )
    }

    var durationActionSheet: UIAlertController.State {
        .make(
            title: L10n.stub("Duration"),
            style: .actionSheet,
            actions: config.durationSelection.values.map { duration in
                .make(title: duration.frameCountFormatted(verbose: true))
            } + [
                .make(
                    title: L10n.stub("Cancel"),
                    style: .cancel
                )
            ]
        )
    }

    var shareActionSheet: UIAlertController.State {
        .make(
            title: L10n.stub("Share"),
            message: L10n.stub("Copy to Clipboard"),
            style: .actionSheet,
            actions: [
                .make(title: L10n.stub("Current Only")),
                .make(title: L10n.stub("All")),
                .make(
                    title: L10n.stub("Cancel"),
                    style: .cancel
                )
            ]
        )
    }

    var importActionSheet: UIAlertController.State {
        switch config.importableMessageAnimationConfigs {
        case nil:
            return .make(
                title: L10n.stub("There is nothing to import"),
                message: L10n.stub("Your clipboard is empty"),
                style: .actionSheet,
                actions: [
                    .make(
                        title: L10n.stub("Import from Clipboard"),
                        isEnabled: false
                    ),
                    .make(
                        title: L10n.stub("Cancel"),
                        style: .cancel
                    )
                ]
            )
        case _ where config.allConfigsAreEqual:
            return .make(
                title: L10n.stub("Just imported"),
                style: .actionSheet,
                actions: [
                    .make(
                        title: L10n.stub("Import from Clipboard"),
                        isEnabled: false
                    ),
                    .make(
                        title: L10n.stub("Cancel"),
                        style: .cancel
                    )
                ]
            )
        default:
            return .make(
                title: L10n.stub("Import"),
                style: .actionSheet,
                actions: [
                    .make(
                        title: L10n.stub("Import from Clipboard")
                    ),
                    .make(
                        title: L10n.stub("Cancel"),
                        style: .cancel
                    )
                ]
            )
        }
    }

    var restoreActionSheet: UIAlertController.State {
        .make(
            title: L10n.stub("Restore"),
            style: .actionSheet,
            actions: [
                .make(title: L10n.stub("Restore to Defaults")),
                config.importedMessageAnimationConfigs == nil
                    ? nil
                    : .make(title: "Restore to Imported"),
                .make(title: L10n.stub("Cancel"), style: .cancel)
            ].compactMap { $0 }
        )
    }

    var dismissalWarningActionSheet: UIAlertController.State {
        .make(
            title: L10n.stub("You have unapplied changes"),
            style: .actionSheet,
            actions: [
                .make(title: L10n.stub("Apply")),
                .make(title: L10n.stub("Discard"), style: .destructive),
                .make(title: L10n.stub("Stay in Editor"), style: .cancel)
            ].compactMap { $0 }
        )
    }
}
