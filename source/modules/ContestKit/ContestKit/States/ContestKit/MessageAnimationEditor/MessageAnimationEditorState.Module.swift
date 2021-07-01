//
//  MessageAnimationEditorModule.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 27.01.2021.
//

import Foundation
import UIKit

import RDXKit

class MessageAnimationEditorModule {
    private let store: Store<MessageAnimationEditorState>

    init(store: Store<MessageAnimationEditorState>) {
        self.store = store
        setup()
    }

    private func setup() {}

    var view: UIView {
        let sectionedListModule = SectionedListModule(store: store.sectionedListStore)
        let view = MessageAnimationEditorView(module: sectionedListModule)
        _ = store.stateObservable
            .addObserver { [weak view] sectionedList in
                view?.state = .init()
            }
        return view
    }
}
