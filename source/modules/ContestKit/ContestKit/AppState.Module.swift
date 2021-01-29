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

    public func messageAnimationEditorView(for id: MessageAnimationConfigID) -> MessageAnimationEditorView {
        let editorModule = MessageAnimationEditorModule(store: store.messageAnimationEditorStore(for: id))
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
