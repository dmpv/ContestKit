//
//  AppState.Module.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 28.01.2021.
//

import Foundation

public class AppModule {
    private let store: RDXKit.Store<AppState>

    public init(store: RDXKit.Store<AppState>) {
        self.store = store
        setup()
    }

    private func setup() {}

    public func editorView(for id: MessageAnimationConfigID) -> EditorView {
        let editorModule = EditorModule(store: store.editorStore(for: id))
        return editorModule.view
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
