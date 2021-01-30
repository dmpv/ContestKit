//
//  MessageAnimationEditorModule.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 27.01.2021.
//

import Foundation
import UIKit

class MessageAnimationEditorModule {
    private let store: RDXKit.Store<MessageAnimationEditorState>

    init(store: RDXKit.Store<MessageAnimationEditorState>) {
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

    var vc: UIViewController {
        let vc = ViewController(view: view)
        _ = store.stateObservable
            .addObserver { [weak vc] messageAnimationEditor in
                vc?.state = messageAnimationEditor.vc
            }
        vc.handlers = .init(
            leftBarButton: .init(
                onPress: { [self, weak store] in
                    store?.dispatch(cancel())
                }
            ),
            rightBarButton: .init(
                onPress: { [self, weak store] in
                    store?.dispatch(apply())
                }
            )
        )
        return vc
    }
}

extension MessageAnimationEditorModule {
    func cancel() -> RDXKit.AnyAction<MessageAnimationEditorState> {
        RDXKit.Thunk<RDXKit.Store<MessageAnimationEditorState>> { messageAnimationEditorStore in
            AppUICoordinator.shared.hideEditor()
        }.boxed()
    }

    func apply() -> RDXKit.AnyAction<MessageAnimationEditorState> {
        RDXKit.Thunk<RDXKit.Store<MessageAnimationEditorState>> { messageAnimationEditorStore in
            AppUICoordinator.shared.hideEditor()
        }.boxed()
    }
}
