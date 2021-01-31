//
//  AppState.Module.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 28.01.2021.
//

import Foundation
import UIKit

public class AppModule {
    private let store: RDXKit.Store<AppState>

    private var pasteboardService: PasteboardService!

    public init(store: RDXKit.Store<AppState>) {
        self.store = store
        setup()
    }

    private func setup() {
        pasteboardService = PasteboardService()
    }

    func messageAnimationPickerVC() -> UIViewController {
        let sectionedListModule = SectionedListModule(store: store.sectionedListStore)
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
        vc.handlers = .init(
            leftBarButton: .init(
                onPress: { [self, weak store] in
                    store?.dispatch(cancelEditing())
                }
            ),
            rightBarButton: .init(
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
            handlers: .init(
                actions: store.state.durationActionSheet.actions.indices.map { [self] index in
                    .init { [self, weak store] in
                        store?.dispatch(finishPickingDuration(with: index))
                    }
                }
            )
        )
    }

    func shareAlertConroller() -> UIAlertController {
        UIAlertController(
            state: store.state.shareActionSheet,
            handlers: .init(
                actions: store.state.shareActionSheet.actions.indices.map { [self] index in
                    .init { [self, weak store] in
                        store?.dispatch(finishSharing(with: index))
                    }
                }
            )
        )
    }

    func importAlertConroller() -> UIAlertController {
        UIAlertController(
            state: store.state.importActionSheet,
            handlers: .init(
                actions: store.state.importActionSheet.actions.indices.map { [self] index in
                    .init { [self, weak store] in
                        store?.dispatch(finishImporting(with: index))
                    }
                }
            )
        )
    }

    func restoreAlertConroller() -> UIAlertController {
        UIAlertController(
            state: store.state.restoreActionSheet,
            handlers: .init(
                actions: store.state.restoreActionSheet.actions.indices.map { [self] index in
                    .init { [self, weak store] in
                        store?.dispatch(finishRestoring(with: index))
                    }
                }
            )
        )
    }
}

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

    func startSharing() -> RDXKit.AnyAction<AppState> {
        RDXKit.Thunk<RDXKit.Store<AppState>> { appStore in
            AppComponents.shared.uiCoordinator.showShareActionSheet()
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
                appStore.dispatch(exportStableConfigs())
            default:
                fatalError(.shouldNeverBeCalled())
            }
        }.boxed()
    }

    func startImporting() -> RDXKit.AnyAction<AppState> {
        RDXKit.Thunk<RDXKit.Store<AppState>> { [self] appStore in
            appStore.dispatch(checkForImportableConfigs())
            AppComponents.shared.uiCoordinator.showImportActionSheet()
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

    func startRestoring() -> RDXKit.AnyAction<AppState> {
        RDXKit.Thunk<RDXKit.Store<AppState>> { appStore in
            AppComponents.shared.uiCoordinator.showRestoreActionSheet()
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

    func checkForImportableConfigs() -> RDXKit.AnyAction<AppState> {
        RDXKit.Thunk<RDXKit.Store<AppState>> { [self] appStore in
            let importableMessageAnimationConfigs = pasteboardService.fetchMessageAnimationConfigs()
            appStore.dispatchCustom { app in
                app.config.importableMessageAnimationConfigs = importableMessageAnimationConfigs
            }
        }.boxed()
    }

    func exportStableConfigs() -> RDXKit.AnyAction<AppState> {
        RDXKit.Thunk<RDXKit.Store<AppState>> { [self] appStore in
            pasteboardService.sendMessageAnimationConfigs(
                appStore.state.config.stableMessageAnimationConfigs
            )
        }.boxed()
    }
}
