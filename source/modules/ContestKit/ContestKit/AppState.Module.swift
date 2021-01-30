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

    public init(store: RDXKit.Store<AppState>) {
        self.store = store
        setup()
    }

    private func setup() {}

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
                    store?.dispatch(applyEditing())
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
                        store?.dispatch(pickDuration(at: index))
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
                        store?.dispatch(pickShare(at: index))
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
                        store?.dispatch(pickImport(at: index))
                    }
                }
            )
        )
    }
}

extension AppModule {
    func startEditing() -> RDXKit.AnyAction<AppState> {
        RDXKit.Thunk<RDXKit.Store<AppState>> { appStore in
        }.boxed()
    }

    func cancelEditing() -> RDXKit.AnyAction<AppState> {
        RDXKit.Thunk<RDXKit.Store<AppState>> { appStore in
            AppComponents.shared.uiCoordinator.hideEditor {
                appStore.dispatchCustom { app in
                    app.config.draftMessageAnimationConfigs = app.config.stableMessageAnimationConfigs
                }
            }
        }.boxed()
    }

    func applyEditing() -> RDXKit.AnyAction<AppState> {
        RDXKit.Thunk<RDXKit.Store<AppState>> { appStore in
            appStore.dispatchCustom { app in
                app.config.stableMessageAnimationConfigs = app.config.draftMessageAnimationConfigs
            }
            AppComponents.shared.uiCoordinator.hideEditor()
        }.boxed()
    }

    func pickDuration(at index: Int) -> RDXKit.AnyAction<AppState> {
        RDXKit.Thunk<RDXKit.Store<AppState>> { appStore in
            let cancelIndex = appStore.state.durationActionSheet.actions.count
            switch index {
            case cancelIndex:
                break
            default:
                appStore.dispatchCustom { app in
                    app.config.durationSelection.selectedIndex = index
                }
            }
        }.boxed()
    }

    func pickShare(at index: Int) -> RDXKit.AnyAction<AppState> {
        RDXKit.Thunk<RDXKit.Store<AppState>> { appStore in
            let shareIndex = 0
            let cancelIndex = appStore.state.shareActionSheet.actions.count
            switch index {
            case cancelIndex:
                break
            case shareIndex:
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
                let jsonData = try! encoder.encode(appStore.state.config.stableMessageAnimationConfigs)
                let jsonString = String(data: jsonData, encoding: .utf8)!

                let pasteboard = UIPasteboard.general
                pasteboard.string = jsonString
            default:
                fatalError(.shouldNeverBeCalled())
            }
        }.boxed()
    }

    func pickImport(at index: Int) -> RDXKit.AnyAction<AppState> {
        RDXKit.Thunk<RDXKit.Store<AppState>> { appStore in
            let importIndex = 0
            let cancelIndex = appStore.state.importActionSheet.actions.count
            switch index {
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
}
