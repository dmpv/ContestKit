//
//  MessageAnimationEditorState.Store+substores.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 28.01.2021.
//

import Foundation

import LensKit

extension RDXKit.Store where StateT == MessageAnimationEditorState {
    var sectionedListStore: RDXKit.Store<SectionedListState> {
        makeProxy(
            config: .init(
                lens: Lens(\.sectionedList)
            )
        )
    }
}
