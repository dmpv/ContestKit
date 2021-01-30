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
        let messageAnimationConfigID: MessageAnimationConfigID = store.state.config.stableMessageAnimationConfigs[0].id
        let editorModule = MessageAnimationEditorModule(store: store.messageAnimationEditorStore(for: messageAnimationConfigID))
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
}

extension AppModule {
    func startEditing() -> RDXKit.AnyAction<AppState> {
        RDXKit.Thunk<RDXKit.Store<AppState>> { appStore in
        }.boxed()
    }

    func cancelEditing() -> RDXKit.AnyAction<AppState> {
        RDXKit.Thunk<RDXKit.Store<AppState>> { appStore in
            AppUICoordinator.shared.hideEditor {
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
            AppUICoordinator.shared.hideEditor()

            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let jsonData = try! encoder.encode(appStore.state.config.stableMessageAnimationConfigs)
            let jsonString = String(data: jsonData, encoding: .utf8)!

            let pasteBoard = UIPasteboard.general
            pasteBoard.string = jsonString
        }.boxed()
    }
}

//import Foundation // Needed for JSONEncoder/JSONDecoder
//
//let encoder = JSONEncoder()
//encoder.outputFormatting = .prettyPrinted
//let decoder = JSONDecoder()
//
//let count = PostType.count(number: 42)
//let countData = try encoder.encode(count)
//let countJSON = String.init(data: countData, encoding: .utf8)!
//print(countJSON)
////    {
////      "count" : 42
////    }
//
//let decodedCount = try decoder.decode(PostType.self, from: countData)
