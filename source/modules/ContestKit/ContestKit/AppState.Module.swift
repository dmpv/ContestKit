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
