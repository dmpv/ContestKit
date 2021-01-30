//
//  AppState+substates.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 28.01.2021.
//

import Foundation

extension AppState {
    var pickerVC: ViewController.State {
        .init(
            title: L10n.stub("Animation Type")
        )
    }
}
