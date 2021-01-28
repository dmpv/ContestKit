//
//  SectionedListState.Store+substores.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 29.01.2021.
//

import Foundation

extension RDXKit.Store where StateT == SectionedListState {
    func rowStore(for id: RowID) -> RDXKit.Store<RowState> {
        makeProxy(
            config: .init(
                lens: Lens(\.rows[id])
            )
        )
    }
}
