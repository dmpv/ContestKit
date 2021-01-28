//
//  Components.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 27.01.2021.
//

import Foundation
import UIKit

class EditorModule {
    private let store: RDXKit.Store<EditorState>

    init(store: RDXKit.Store<EditorState>) {
        self.store = store
        setup()
    }

    private func setup() {}

    var view: EditorView {
        let sectionedListModule = SectionedListModule(store: store.sectionedListStore)
        let view = EditorView(module: sectionedListModule)
        _ = store.stateObservable
            .addObserver { [weak view] state in
                view?.state = .init()
            }
        return view
    }
}
