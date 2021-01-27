//
//  Components.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 27.01.2021.
//

import Foundation

//class AppContainer {
//    private var disposable = Disposable()
//
//    private let store: RDXKit.Store<AppState>
//
//    init(store: RDXKit.Store<AppState>) {
//        self.store = store
//
//
//    }
//}

//extension AppContainer {
//    static let shared = AppContainer(store: RDXKit.Store(state: .init()))
//}

//extension AppComponents
//
//
//extension AppState {
//
//}

//AppState -> EditorViewState
//
//AppContainer ->

//extension AppContainer {
//    var editorViewContainer:
//}

//class StateContainer<StateT: Equatable> {
//    private var disposable = Disposable()
//
//    private let store: RDXKit.Store<StateT>
//
//    init(store: RDXKit.Store<StateT>) {
//        self.store = store
//    }
//}

//extension StateContainer where StateT == AppState {
//    var editorViewContainer: StateContainer<EditorView.State> {
//        .init(
//            store: store.makeProxy(
//                config: .init(
//                    lens: Lens(\.config.animationConfig.message.editorView)
//                )
//            )
//        )
//    }
//}

extension RDXKit.Store where StateT == AppState {
    var messageEditorViewStore: RDXKit.Store<EditorView.State> {
        makeProxy(
            config: .init(
                lens: Lens(\.config.animationConfig.message.editorView)
            )
        )
    }
}

public class AppModule {
    private let store: RDXKit.Store<AppState>

    private var messageEditorViewModule: MessageEditorViewModule!

    public init(store: RDXKit.Store<AppState>) {
        self.store = store
        setup()
    }

    private func setup() {
        messageEditorViewModule = .init(store: store.messageEditorViewStore)
    }

    public var editorView: EditorView {
        messageEditorViewModule.editorView
    }
}

class MessageEditorViewModule {
    let store: RDXKit.Store<EditorView.State>

    init(store: RDXKit.Store<EditorView.State>) {
        self.store = store
    }

    var editorView: EditorView {
        let view = EditorView()
        _ = store.stateObservable
            .addObserver { [weak view] state in
                view?.state = state
            }
        return view
    }
}
