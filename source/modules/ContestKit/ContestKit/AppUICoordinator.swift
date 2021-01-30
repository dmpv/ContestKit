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

    private var appModule: AppModule!
    private var appStore: RDXKit.Store<AppState>!

    private let rootVC: UIViewController

    init(rootVC: UIViewController) {
        self.rootVC = rootVC
        setup()
    }

    private func setup() {
        appStore = RDXKit.Store<AppState>(state: .init())
        appStore.apply(middleware: RDXKit.makeThunkMiddleware())

        appModule = AppModule(store: appStore)
    }

    public func showEditor() {
        guard editorVC == nil else { return fallback() }
        appStore.dispatch(appModule.fetchDefaultAnimationConfig())
        editorVC = appModule.messageAnimationEditorVC()
        navigationController = UINavigationController(rootViewController: editorVC!)
        rootVC.present(navigationController!, animated: true)
    }

    public func hideEditor() {
        guard editorVC != nil else { return fallback() }
        guard navigationController != nil else { return fallback() }
        navigationController?.dismiss(animated: true)
        editorVC = nil
        navigationController = nil
    }

    public func showIDPicker() {
        guard pickerVC == nil else { return fallback() }
        guard navigationController != nil else { return fallback() }
        pickerVC = appModule.messageAnimationPickerVC()
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
    public static let shared = AppUICoordinator(rootVC: UIApplication.shared.keyWindow!.rootViewController!)
}
