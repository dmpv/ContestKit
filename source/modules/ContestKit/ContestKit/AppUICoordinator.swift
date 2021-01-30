//
//  AppUICoordinator.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 30.01.2021.
//

import Foundation
import UIKit

class AppUICoordinator {
    private var navigationController: UINavigationController?
    private var editorVC: UIViewController?
    private var alertController: UIAlertController?

    private let rootVC: UIViewController
    private let store: RDXKit.Store<AppState>
    private var module: AppModule

    init(rootVC: UIViewController, store: RDXKit.Store<AppState>, module: AppModule) {
        self.rootVC = rootVC
        self.store = store
        self.module = module
        setup()
    }

    private func setup() {
    }

    func showEditor() {
        guard editorVC == nil else { return fallback() }
        editorVC = module.editorVC()
        navigationController = UINavigationController(rootViewController: editorVC!)
        rootVC.present(navigationController!, animated: true)
    }

    func hideEditor(then completion: (() -> Void)? = nil) {
        guard editorVC != nil else { return fallback() }
        guard navigationController != nil else { return fallback() }
        navigationController?.dismiss(animated: true, completion: completion)
        editorVC = nil
        navigationController = nil
    }

    func showIDPicker() {
        guard navigationController != nil else { return fallback() }
        let pickerVC = module.messageAnimationPickerVC()
        navigationController!.pushViewController(pickerVC, animated: true)
    }

    func hideIDPicker() {
        guard navigationController != nil else { return fallback() }
        navigationController!.popViewController(animated: true)
    }

    func showDurationActionSheet() {
        let alertController = module.durationPickerAlertConroller()
        navigationController?.present(alertController, animated: true)
    }

    func showShareActionSheet() {
        let alertController = module.shareAlertConroller()
        navigationController?.present(alertController, animated: true)
    }

    func showImportActionSheet() {
        let alertController = module.importAlertConroller()
        navigationController?.present(alertController, animated: true)
    }

    func showRestoreActionSheet() {
        let alertController = module.restoreAlertConroller()
        navigationController?.present(alertController, animated: true)
    }
}
