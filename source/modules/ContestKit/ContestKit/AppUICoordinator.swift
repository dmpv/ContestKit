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
        appStore.dispatch(appModule.startEditing())
        editorVC = appModule.editorVC()
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
    public func commonAlertActions() -> [UIAlertAction] {
        [
            .init(
                title: L10n.stub("Cancel"),
                style: .cancel
            ) { [self] _ in
                hideActionSheet()
            }
        ]
    }
//    private
    func showActionSheet(withTitle title: String, actions: [UIAlertAction]) {
        guard alertController == nil else { return fallback() }
        alertController = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        for action in actions {
            alertController!.addAction(action)
        }
        navigationController?.present(alertController!, animated: true)
    }

    private func hideActionSheet() {
        guard alertController != nil else { return fallback() }
        alertController?.dismiss(animated: true)
    }

//    private func showDurationActionSheet() {
//        showActionSheet(withTitle: L10n.stub("Duration"), actions: )
//    }
//
//    public func durationAlertActions() {
//        alertController.addAction(
//            UIAlertAction(
//                title: "Cancel",
//                style: .cancel
//            ) { _ in
//
//            }
//        )
//        alertController.addAction(
//            UIAlertAction(
//                title: "Stub",
//                style: .default
//            ) { _ in
//
//            }
//        )
//        alertController.addAction(
//            UIAlertAction(
//                title: "Destructive",
//                style: .destructive
//            ) { _ in
//
//            }
//        )
//        navigationController?.present(alertController, animated: true)
//    }
}

extension AppUICoordinator {
    public static let shared = AppUICoordinator(rootVC: UIApplication.shared.keyWindow!.rootViewController!)
}
