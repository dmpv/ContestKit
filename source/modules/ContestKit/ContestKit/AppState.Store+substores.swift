//
//  AppState.Store+substores.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 28.01.2021.
//

import Foundation

extension RDXKit.Store where StateT == AppState {
    func messageAnimationEditorStore(for id: MessageAnimationConfigID) -> RDXKit.Store<MessageAnimationEditorState> {
        makeProxy(
            config: .init(
                lens: Lens(\.config.messageAnimationConfigs[id].editor)
            )
        )
    }
}
