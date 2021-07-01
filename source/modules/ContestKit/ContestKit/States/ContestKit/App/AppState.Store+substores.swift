//
//  AppState.Store+substores.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 28.01.2021.
//

import Foundation

import LensKit
import RDXKit

extension Store where StateT == AppState {
    func messageAnimationEditorStore() -> Store<MessageAnimationEditorState> {
        makeProxy(
            config: .init(
                lens: Lens(\.selectedConfig.editor)
            )
        )
    }
}

extension Store where StateT == AppState {
    var sectionedListStore: Store<SectionedListState> {
        makeProxy(
            config: .init(
                lens: Lens(\.config.messageAnimationIDPickerSectionedList)
            )
        )
    }
}
