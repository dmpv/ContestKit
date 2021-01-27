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
        let editorView = EditorView()
        let vc = UIViewController()
        vc.view = editorView
        return vc
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<Editor>) {
        
    }
}

