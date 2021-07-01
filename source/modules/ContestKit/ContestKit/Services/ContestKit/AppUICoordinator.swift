//
//  AppUICoordinator.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 30.01.2021.
//

import Foundation
import UIKit

import RDXKit
import ToolKit

class AppUICoordinator: NSObject {
    private var navigationController: UINavigationController?
    private var editorVC: UIViewController?

    private let rootVC: UIViewController
    private let store: RDXKit.Store<AppState>
    private let module: AppModule

    init(rootVC: UIViewController, store: RDXKit.Store<AppState>, module: AppModule) {
        self.rootVC = rootVC
        self.store = store
        self.module = module
        super.init()
        setup()
    }

    private func setup() {
    }

    func showEditor() {
        guard editorVC == nil else { return fallback() }
        guard navigationController == nil else { return fallback() }
        editorVC = module.editorVC()
        navigationController = UINavigationController(rootViewController: editorVC!)
        navigationController!.presentationController?.delegate = self
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

extension AppUICoordinator: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        guard presentationController.presentedViewController == navigationController else {
            return fallback()
        }
        store.dispatch(module.cancelEditing())
        editorVC = nil
        navigationController = nil
    }

    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        guard presentationController.presentedViewController == navigationController else {
            return fallback()
        }
        let alertController = module.dismissalWarningAlertConroller()
        navigationController?.present(alertController, animated: true)
    }

    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        guard presentationController.presentedViewController == navigationController else {
            return fallback(true)
        }
        return !store.state.config.hasUnappliedChanges
    }
}
