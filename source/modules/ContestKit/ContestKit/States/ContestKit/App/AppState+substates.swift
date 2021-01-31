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
                isEnabled: config.hasUnappliedChanges
            )
        )
    }

    var durationActionSheet: UIAlertController.State {
        .init(
            title: L10n.stub("Duration"),
            style: .actionSheet,
            actions: config.durationSelection.values.map { duration in
                .init(title: duration.frameCountFormatted(verbose: true))
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
                .init(title: L10n.stub("Copy to Clipboard")),
                .init(
                    title: L10n.stub("Cancel"),
                    style: .cancel
                )
            ]
        )
    }

    var importActionSheet: UIAlertController.State {
        switch config.importableMessageAnimationConfigs {
        case nil:
            return .init(
                title: L10n.stub("There is nothing to import"),
                message: L10n.stub("Your clipboard is empty"),
                style: .actionSheet,
                actions: [
                    .init(
                        title: L10n.stub("Import from Clipboard"),
                        isEnabled: false
                    ),
                    .init(
                        title: L10n.stub("Cancel"),
                        style: .cancel
                    )
                ]
            )
        case _ where config.allConfigsAreEqual:
            return .init(
                title: L10n.stub("Just imported"),
                style: .actionSheet,
                actions: [
                    .init(
                        title: L10n.stub("Import from Clipboard"),
                        isEnabled: false
                    ),
                    .init(
                        title: L10n.stub("Cancel"),
                        style: .cancel
                    )
                ]
            )
        default:
            return .init(
                title: L10n.stub("Import"),
                style: .actionSheet,
                actions: [
                    .init(
                        title: L10n.stub("Import from Clipboard")
                    ),
                    .init(
                        title: L10n.stub("Cancel"),
                        style: .cancel
                    )
                ]
            )
        }
    }

    var restoreActionSheet: UIAlertController.State {
        .init(
            title: L10n.stub("Restore"),
            style: .actionSheet,
            actions: [
                .init(title: L10n.stub("Restore to Defaults")),
                config.importedMessageAnimationConfigs == nil
                    ? nil
                    : .init(title: "Restore to Imported"),
                .init(title: L10n.stub("Cancel"), style: .cancel)
            ].compactMap { $0 }
        )
    }

    var dismissalWarningActionSheet: UIAlertController.State {
        .init(
            title: L10n.stub("You have unapplied changes"),
            style: .actionSheet,
            actions: [
                .init(title: L10n.stub("Apply")),
                .init(title: L10n.stub("Discard"), style: .destructive),
                .init(title: L10n.stub("Stay in Editor"), style: .cancel)
            ].compactMap { $0 }
        )
    }
}
