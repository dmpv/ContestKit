//
//  AppState.Actions.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 31.01.2021.
//

import Foundation
import UIKit

extension AppModule {
    public func startEditing() -> RDXKit.AnyAction<AppState> {
        RDXKit.Thunk<RDXKit.Store<AppState>> { appStore in
            AppComponents.shared.uiCoordinator.showEditor()
        }.boxed()
    }

    func cancelEditing() -> RDXKit.AnyAction<AppState> {
        RDXKit.Thunk<RDXKit.Store<AppState>> { [self] appStore in
            AppComponents.shared.uiCoordinator.hideEditor {
                appStore.dispatch(resetEditing())
            }
        }.boxed()
    }

    func resetEditing() -> RDXKit.AnyAction<AppState> {
        RDXKit.Thunk<RDXKit.Store<AppState>> { appStore in
            appStore.dispatchCustom { app in
                app.config.draftMessageAnimationConfigs = app.config.stableMessageAnimationConfigs
            }
        }.boxed()
    }

    func applyEditing() -> RDXKit.AnyAction<AppState> {
        RDXKit.Thunk<RDXKit.Store<AppState>> { appStore in
            appStore.dispatchCustom { app in
                app.config.stableMessageAnimationConfigs = app.config.draftMessageAnimationConfigs
            }
        }.boxed()
    }

    func endEditing() -> RDXKit.AnyAction<AppState> {
        RDXKit.Thunk<RDXKit.Store<AppState>> { [self] appStore in
            appStore.dispatch(applyEditing())
            AppComponents.shared.uiCoordinator.hideEditor()
        }.boxed()
    }

    func startSharing() -> RDXKit.AnyAction<AppState> {
        RDXKit.Thunk<RDXKit.Store<AppState>> { appStore in
            AppComponents.shared.uiCoordinator.showShareActionSheet()
        }.boxed()
    }

    func startImporting() -> RDXKit.AnyAction<AppState> {
        RDXKit.Thunk<RDXKit.Store<AppState>> { appStore in
            AppComponents.shared.uiCoordinator.showImportActionSheet()
        }.boxed()
    }

    func startRestoring() -> RDXKit.AnyAction<AppState> {
        RDXKit.Thunk<RDXKit.Store<AppState>> { appStore in
            AppComponents.shared.uiCoordinator.showRestoreActionSheet()
        }.boxed()
    }

    func startPickingAnimationType() -> RDXKit.AnyAction<AppState> {
        RDXKit.Thunk<RDXKit.Store<AppState>> { appStore in
            AppComponents.shared.uiCoordinator.showIDPicker()
        }.boxed()
    }

    func finishPickingAnimationType(with id: MessageAnimationConfigID) -> RDXKit.AnyAction<AppState> {
        RDXKit.Thunk<RDXKit.Store<AppState>> { [self] appStore in
            appStore.dispatch(resetEditing())
            appStore.dispatchCustom { app in
                app.selectedConfigID = id
            }
            AppComponents.shared.uiCoordinator.hideIDPicker()
        }.boxed()
    }

    func startPickingDuration() -> RDXKit.AnyAction<AppState> {
        RDXKit.Thunk<RDXKit.Store<AppState>> { appStore in
            AppComponents.shared.uiCoordinator.showDurationActionSheet()
        }.boxed()
    }

    func finishPickingDuration(with buttonIndex: Int) -> RDXKit.AnyAction<AppState> {
        RDXKit.Thunk<RDXKit.Store<AppState>> { appStore in
            let cancelIndex = appStore.state.durationActionSheet.actions.count - 1
            switch buttonIndex {
            case cancelIndex:
                break
            default:
                appStore.dispatchCustom { app in
                    app.config.durationSelection.selectedIndex = buttonIndex
                }
            }
        }.boxed()
    }

    func finishSharing(with buttonIndex: Int) -> RDXKit.AnyAction<AppState> {
        RDXKit.Thunk<RDXKit.Store<AppState>> { [self] appStore in
            let shareIndex = 0
            let cancelIndex = appStore.state.shareActionSheet.actions.count - 1
            switch buttonIndex {
            case cancelIndex:
                break
            case shareIndex:
                appStore.dispatch(applyEditing())

                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
                if let jsonData
                    = try? encoder.encode(appStore.state.config.stableMessageAnimationConfigs),
                   let jsonString = String(data: jsonData, encoding: .utf8) {
                    let pasteboard = UIPasteboard.general
                    pasteboard.string = jsonString
                }
            default:
                fatalError(.shouldNeverBeCalled())
            }
        }.boxed()
    }

    func finishImporting(with buttonIndex: Int) -> RDXKit.AnyAction<AppState> {
        RDXKit.Thunk<RDXKit.Store<AppState>> { appStore in
            let importIndex = 0
            let cancelIndex = appStore.state.importActionSheet.actions.count - 1
            switch buttonIndex {
            case cancelIndex:
                break
            case importIndex:
                guard let stringData = UIPasteboard.general.string?.data(using: .utf8) else {
                    return
                }

                let decoder = JSONDecoder()
                if let messageAnimationConfigs = try? decoder.decode([MessageAnimationConfigState].self, from: stringData) {
                    appStore.dispatchCustom { app in
                        app.config.importedMessageAnimationConfigs = messageAnimationConfigs
                        app.config.draftMessageAnimationConfigs = messageAnimationConfigs
                        app.config.stableMessageAnimationConfigs = messageAnimationConfigs
                    }
                }
            default:
                fatalError(.shouldNeverBeCalled())
            }
        }.boxed()
    }

    func finishRestoring(with buttonIndex: Int) -> RDXKit.AnyAction<AppState> {
        RDXKit.Thunk<RDXKit.Store<AppState>> { appStore in
            let actionCount = appStore.state.restoreActionSheet.actions.count
            let restoreFromDefaultsIndex = 0
            let restoreFromImportedIndex = actionCount > 2 ? 1 : nil
            let cancelIndex = actionCount - 1
            switch buttonIndex {
            case cancelIndex:
                break
            case restoreFromDefaultsIndex:
                appStore.dispatchCustom { app in
                    app.config.draftMessageAnimationConfigs = AppConfigState.defaultMessageAnimationConfigs
                    app.config.stableMessageAnimationConfigs = AppConfigState.defaultMessageAnimationConfigs
                }
            case restoreFromImportedIndex:
                appStore.dispatchCustom { app in
                    let importedMessageAnimationConfigs = app.config.importedMessageAnimationConfigs!
                    app.config.draftMessageAnimationConfigs = importedMessageAnimationConfigs
                    app.config.stableMessageAnimationConfigs = importedMessageAnimationConfigs
                }
            default:
                fatalError(.shouldNeverBeCalled())
            }
        }.boxed()
    }
}
