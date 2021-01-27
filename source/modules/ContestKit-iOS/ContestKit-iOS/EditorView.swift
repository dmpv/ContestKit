//
//  EditorView.swift
//  ContestKit-iOS
//
//  Created by Dmitry Purtov on 27.01.2021.
//

import Foundation
import SwiftUI

import ContestKit

struct Editor: UIViewControllerRepresentable {
    func makeUIViewController(context: UIViewControllerRepresentableContext<Editor>) -> UIViewController {
        let appModule = AppModule.shared
        let vc = UIViewController()
        vc.view = appModule.editorView
        return vc
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<Editor>) {
        
    }
}

extension AppModule {
    static let shared = AppModule(store: .init(state: .init()))
}
