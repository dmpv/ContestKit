//
//  draft.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 25.01.2021.
//

import Foundation

protocol StateType: ValueType, Equatable {}

protocol IDType: ValueType, Hashable {}

class L10n: Namespace {
    static func stub(_ string: String) -> String {
        NSLocalizedString(string, comment: "")
    }
}
