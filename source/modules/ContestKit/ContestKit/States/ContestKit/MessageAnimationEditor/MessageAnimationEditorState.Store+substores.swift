//
//  MessageAnimationEditorState.Store+substores.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 28.01.2021.
//

import Foundation

import LensKit
import RDXKit

extension Store where StateT == MessageAnimationEditorState {
    var sectionedListStore: Store<SectionedListState> {
        makeProxy(
            config: .init(
                lens: Lens(\.sectionedList)
            )
        )
    }
}
