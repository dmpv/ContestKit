//
//  Editor.swift
//  ContestKit-iOS
//
//  Created by Dmitry Purtov on 27.01.2021.
//

import Foundation
import SwiftUI

import ContestKit

//let appStore: RDXKit.Store<AppState> = .init(state: .init())

struct Editor: UIViewControllerRepresentable {
    func makeUIViewController(context: UIViewControllerRepresentableContext<Editor>) -> UIViewController {
        let appStore = RDXKit.Store<AppState>(state: .init())
        appStore.apply(middleware: RDXKit.makeThunkMiddleware())

        let appModule = AppModule(store: appStore)

        appStore.dispatch(appModule.fetchDefaultAnimationConfig())

        let vc = UIViewController()
        vc.view = appModule.messageAnimationEditorView(for: .smallText)
        return vc
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<Editor>) {
        
    }
}

//extension AppModule {
//    static let shared = AppModule(store: appStore)
//}
