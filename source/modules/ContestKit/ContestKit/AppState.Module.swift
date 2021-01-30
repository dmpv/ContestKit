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

    public func messageAnimationEditorVC() -> UIViewController {
        let messageAnimationConfigID: MessageAnimationConfigID = store.state.config.messageAnimationConfigs[0].id
        let editorModule = MessageAnimationEditorModule(store: store.messageAnimationEditorStore(for: messageAnimationConfigID))
        return editorModule.vc
    }

    public func messageAnimationPickerVC() -> UIViewController {
        let sectionedListModule = SectionedListModule(store: store.sectionedListStore)
        let view = sectionedListModule.view
        let vc = ViewController(view: view)
        _ = store.stateObservable
            .addObserver { [weak vc] app in
                vc?.state = app.pickerVC
            }
        return vc
    }
}

extension AppModule {
    public func fetchDefaultAnimationConfig() -> RDXKit.AnyAction<AppState> {
        RDXKit.Thunk<RDXKit.Store<AppState>> { appStore in
            appStore.dispatchCustom { app in
                app.config.defaultMessageAnimationConfigs = AppConfigState.initialMessageAnimationConfigs
                app.config.messageAnimationConfigs = app.config.defaultMessageAnimationConfigs
            }
        }.boxed()
    }
}
