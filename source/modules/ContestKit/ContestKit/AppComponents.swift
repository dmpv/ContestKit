//
//  File.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 30.01.2021.
//

import Foundation
import UIKit

public class AppComponents {
    public private(set) var store: RDXKit.Store<AppState>!
    public private(set) var module: AppModule!

    private(set) var uiCoordinator: AppUICoordinator!

    init() {
        setup()
    }

    private func setup() {
        store = .init(state: .init())
        store.apply(middleware: RDXKit.makeThunkMiddleware())

        module = .init(store: store)

        uiCoordinator = .init(
            rootVC: UIApplication.shared.keyWindow!.rootViewController!,
            store: store,
            module: module
        )
    }
}

extension AppComponents {
    public static let shared = AppComponents()
}
