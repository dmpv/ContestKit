//
//  AppUICoordinator.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 30.01.2021.
//

import Foundation
import UIKit

public class AppUICoordinator {
    private var navigationController: UINavigationController?
    private var editorVC: UIViewController?
    private var pickerVC: UIViewController?
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

    public func showEditor() {
        guard editorVC == nil else { return fallback() }
        store.dispatch(module.startEditing())
        editorVC = module.editorVC()
        navigationController = UINavigationController(rootViewController: editorVC!)
        rootVC.present(navigationController!, animated: true)
    }

    public func hideEditor(then completion: (() -> Void)? = nil) {
        guard editorVC != nil else { return fallback() }
        guard navigationController != nil else { return fallback() }
        navigationController?.dismiss(animated: true, completion: completion)
        editorVC = nil
        navigationController = nil
    }

    public func showIDPicker() {
        guard pickerVC == nil else { return fallback() }
        guard navigationController != nil else { return fallback() }
        pickerVC = module.messageAnimationPickerVC()
        navigationController!.pushViewController(pickerVC!, animated: true)
    }

    public func hideIDPicker() {
        guard pickerVC != nil else { return fallback() }
        guard navigationController != nil else { return fallback() }
        navigationController!.popViewController(animated: true)
        pickerVC = nil
    }
}

extension AppUICoordinator {
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
}
