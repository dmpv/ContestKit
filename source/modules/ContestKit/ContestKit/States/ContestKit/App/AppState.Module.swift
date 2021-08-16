//
//  AppState.Module.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 28.01.2021.
//

import Foundation
import UIKit

import RDXKit
import ToolKit
import ComponentKit

public class AppModule {
    private let store: Store<AppState>

    private var pasteboardService: PasteboardService!

    public init(store: Store<AppState>) {
        self.store = store
        setup()
    }

    private func setup() {
        pasteboardService = PasteboardService()
    }

    func messageAnimationPickerVC() -> UIViewController {
        let sectionedListModule = _XectionedListModule(store: store.sectionedListStore)
        let view = sectionedListModule.view
        let vc = ViewController(view: view)
        _ = store.stateObservable
            .addObserver { [weak vc] app in
                vc?.state = app.pickerVC
            }
        return vc
    }

    func editorVC() -> UIViewController {
        let editorModule = MessageAnimationEditorModule(store: store.messageAnimationEditorStore())
        let view = editorModule.view
        let vc = ViewController(view: view)
        _ = store.stateObservable
            .addObserver { [weak vc] app in
                vc?.state = app.editorVC
            }
        vc.handlers = .make(
            leftBarButton: .make(
                onPress: { [self, weak store] in
                    store?.dispatch(cancelEditing())
                }
            ),
            rightBarButton: .make(
                onPress: { [self, weak store] in
                    store?.dispatch(endEditing())
                }
            )
        )
        return vc
    }

    func durationPickerAlertConroller() -> UIAlertController {
        UIAlertController(
            state: store.state.durationActionSheet,
            handlers: .make(
                actions: store.state.durationActionSheet.actions.indices.map { [self] index in
                    .make { [self, weak store] in
                        store?.dispatch(finishPickingDuration(with: index))
                    }
                }
            )
        )
    }

    func shareAlertConroller() -> UIAlertController {
        UIAlertController(
            state: store.state.shareActionSheet,
            handlers: .make(
                actions: store.state.shareActionSheet.actions.indices.map { [self] index in
                    .make { [self, weak store] in
                        store?.dispatch(finishSharing(with: index))
                    }
                }
            )
        )
    }

    func importAlertConroller() -> UIAlertController {
        UIAlertController(
            state: store.state.importActionSheet,
            handlers: .make(
                actions: store.state.importActionSheet.actions.indices.map { [self] index in
                    .make { [self, weak store] in
                        store?.dispatch(finishImporting(with: index))
                    }
                }
            )
        )
    }

    func restoreAlertConroller() -> UIAlertController {
        UIAlertController(
            state: store.state.restoreActionSheet,
            handlers: .make(
                actions: store.state.restoreActionSheet.actions.indices.map { [self] index in
                    .make { [self, weak store] in
                        store?.dispatch(finishRestoring(with: index))
                    }
                }
            )
        )
    }

    func dismissalWarningAlertConroller() -> UIAlertController {
        UIAlertController(
            state: store.state.dismissalWarningActionSheet,
            handlers: .make(
                actions: store.state.dismissalWarningActionSheet.actions.indices.map { [self] index in
                    .make { [self, weak store] in
                        store?.dispatch(finishDismissal(with: index))
                    }
                }
            )
        )
    }
}

extension AppModule {
    public func startEditing() -> AnyAction<AppState> {
        Thunk<Store<AppState>> { appStore in
            AppComponents.shared.uiCoordinator.showEditor()
        }.boxed()
    }

    func cancelEditing() -> AnyAction<AppState> {
        Thunk<Store<AppState>> { [self] appStore in
            AppComponents.shared.uiCoordinator.hideEditor {
                appStore.dispatch(resetEditing())
            }
        }.boxed()
    }

    func resetEditing() -> AnyAction<AppState> {
        Thunk<Store<AppState>> { appStore in
            appStore.dispatchCustom { app in
                app.config.draftMessageAnimationConfigs = app.config.stableMessageAnimationConfigs
            }
        }.boxed()
    }

    func applyEditing() -> AnyAction<AppState> {
        Thunk<Store<AppState>> { appStore in
            appStore.dispatchCustom { app in
                app.config.stableMessageAnimationConfigs = app.config.draftMessageAnimationConfigs
            }
        }.boxed()
    }

    func endEditing() -> AnyAction<AppState> {
        Thunk<Store<AppState>> { [self] appStore in
            appStore.dispatch(applyEditing())
            AppComponents.shared.uiCoordinator.hideEditor()
        }.boxed()
    }

    func startPickingAnimationType() -> AnyAction<AppState> {
        Thunk<Store<AppState>> { appStore in
            AppComponents.shared.uiCoordinator.showIDPicker()
        }.boxed()
    }

    func finishPickingAnimationType(with id: MessageAnimationConfigID) -> AnyAction<AppState> {
        Thunk<Store<AppState>> { [self] appStore in
            appStore.dispatch(resetEditing())
            appStore.dispatchCustom { app in
                app.selectedConfigID = id
            }
            AppComponents.shared.uiCoordinator.hideIDPicker()
        }.boxed()
    }

    func startPickingDuration() -> AnyAction<AppState> {
        Thunk<Store<AppState>> { appStore in
            AppComponents.shared.uiCoordinator.showDurationActionSheet()
        }.boxed()
    }

    func finishPickingDuration(with buttonIndex: Int) -> AnyAction<AppState> {
        Thunk<Store<AppState>> { appStore in
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

    func startSharing() -> AnyAction<AppState> {
        Thunk<Store<AppState>> { appStore in
            AppComponents.shared.uiCoordinator.showShareActionSheet()
        }.boxed()
    }

    func finishSharing(with buttonIndex: Int) -> AnyAction<AppState> {
        Thunk<Store<AppState>> { [self] appStore in
            let shareSelectedIndex = 0
            let shareAllIndex = 1
            let cancelIndex = appStore.state.shareActionSheet.actions.count - 1
            switch buttonIndex {
            case cancelIndex:
                break
            case shareSelectedIndex:
                appStore.dispatch(applyEditing())
                appStore.dispatch(shareSelectedStableConfig())
            case shareAllIndex:
                appStore.dispatch(applyEditing())
                appStore.dispatch(shareStableConfigs())
            default:
                fatalError(.shouldNeverBeCalled())
            }
        }.boxed()
    }

    func startImporting() -> AnyAction<AppState> {
        Thunk<Store<AppState>> { [self] appStore in
            appStore.dispatch(checkForImportableConfigs())
            AppComponents.shared.uiCoordinator.showImportActionSheet()
        }.boxed()
    }

    func finishImporting(with buttonIndex: Int) -> AnyAction<AppState> {
        Thunk<Store<AppState>> { appStore in
            let importIndex = 0
            let cancelIndex = appStore.state.importActionSheet.actions.count - 1
            switch buttonIndex {
            case cancelIndex:
                break
            case importIndex:
                appStore.dispatchCustom { app in
                    guard let importableMessageAnimationConfigs
                            = app.config.importableMessageAnimationConfigs else { return fallback() }
                    app.config.importedMessageAnimationConfigs = importableMessageAnimationConfigs
                    app.config.draftMessageAnimationConfigs = importableMessageAnimationConfigs
                    app.config.stableMessageAnimationConfigs = importableMessageAnimationConfigs
                }
            default:
                fatalError(.shouldNeverBeCalled())
            }
        }.boxed()
    }

    func startRestoring() -> AnyAction<AppState> {
        Thunk<Store<AppState>> { appStore in
            AppComponents.shared.uiCoordinator.showRestoreActionSheet()
        }.boxed()
    }

    func finishRestoring(with buttonIndex: Int) -> AnyAction<AppState> {
        Thunk<Store<AppState>> { appStore in
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

    func finishDismissal(with buttonIndex: Int) -> AnyAction<AppState> {
        Thunk<Store<AppState>> { [self] appStore in
            let applyAndDismissIndex = 0
            let dismissIndex = 1
            let cancelIndex = appStore.state.dismissalWarningActionSheet.actions.count - 1
            switch buttonIndex {
            case cancelIndex:
                break
            case applyAndDismissIndex:
                appStore.dispatch(endEditing())
            case dismissIndex:
                appStore.dispatch(cancelEditing())
            default:
                fatalError(.shouldNeverBeCalled())
            }
        }.boxed()
    }

    func checkForImportableConfigs() -> AnyAction<AppState> {
        Thunk<Store<AppState>> { [self] appStore in
            var importableMessageAnimationConfigs = pasteboardService.fetchMessageAnimationConfigs()
            if importableMessageAnimationConfigs?.count == 1 {
                let config = importableMessageAnimationConfigs![0]
                var draftConfigs = appStore.state.config.draftMessageAnimationConfigs
                draftConfigs[safe: config.id] = config
                importableMessageAnimationConfigs = draftConfigs
            }
            appStore.dispatchCustom { app in
                app.config.importableMessageAnimationConfigs = importableMessageAnimationConfigs
            }
        }.boxed()
    }

    func shareSelectedStableConfig() -> AnyAction<AppState> {
        Thunk<Store<AppState>> { [self] appStore in
            pasteboardService.sendMessageAnimationConfig(messageAnimationConfig: appStore.state.selectedConfig)
        }.boxed()
    }

    func shareStableConfigs() -> AnyAction<AppState> {
        Thunk<Store<AppState>> { [self] appStore in
            pasteboardService.sendMessageAnimationConfigs(
                appStore.state.config.stableMessageAnimationConfigs
            )
        }.boxed()
    }
}
