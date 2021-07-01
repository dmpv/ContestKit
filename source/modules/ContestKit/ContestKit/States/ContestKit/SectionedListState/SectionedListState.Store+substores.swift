//
//  SectionedListState.Store+substores.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 29.01.2021.
//

import Foundation

import LensKit
import RDXKit

extension Store where StateT == SectionedListState {
    func rowStore(for id: RowID) -> Store<RowState> {
        makeProxy(
            config: .init(
                lens: Lens(\.rows[safe: id]).unwrapped(with: .button(.import))
            )
        )
    }
}
