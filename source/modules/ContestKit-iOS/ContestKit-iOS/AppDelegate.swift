//
//  AppDelegate.swift
//  ContestKit-iOS
//
//  Created by Dmitry Purtov on 31.01.2021.
//

import UIKit

import ContestKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UIViewController()
        window?.makeKeyAndVisible()

        AppComponents.shared.store.dispatch(
            AppComponents.shared.module.startEditing()
        )

        return true
    }
}
