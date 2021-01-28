//
//  RowModule.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 28.01.2021.
//

import Foundation
import UIKit

class RowModule {
    private let store: RDXKit.Store<RowState>

    init(store: RDXKit.Store<RowState>) {
        self.store = store
        setup()
    }

    private func setup() {}

    func setup(cell: RowCell) {
        _ = store.stateObservable
            .addObserver { [weak cell] row in
                cell?.state = row.cell
            }

        cell.handlers = {
            switch store.state.id {
            case .picker:
                return PickerCell.Handlers { [self, weak store] in
                    store?.dispatch(selectRow())
                }
            case .button:
                return ButtonCell.Handlers { [self, weak store] in
                    store?.dispatch(selectRow())
                }
            case .animationTiming:
                return AnimationTimingCell.Handlers()
            }
        }()
    }
}

extension RowModule {
    func selectRow() -> RDXKit.AnyAction<RowState> {
        SelectRow().boxed()
    }
}

private struct SelectRow: RDXKit.Action {
    typealias State = RowState

    func adjust(_ state: inout RowState) {
        print("SelectRow")
    }
}
