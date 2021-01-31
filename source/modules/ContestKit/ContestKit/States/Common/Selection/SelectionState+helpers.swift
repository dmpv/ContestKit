//
//  SelectionState+helpers.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 31.01.2021.
//

import Foundation

extension SelectionState {
    init(values: [ValueT], selectedIndex: Int = 0) {
        self.init(values: values, selectedValue: values[selectedIndex])
    }

    mutating func selectLast() {
        selectedValue = values.last!
    }

    mutating func updateShiftingLeft(with values: [ValueT]) {
        self = .init(
            values: values,
            selectedValue: {
                let prefix = self.values[0...selectedIndex]
                return prefix.last(where: { values.contains($0) }) ?? values.first!
            }()
        )
    }

    mutating func updateSavingIndex(with values: [ValueT]) {
        self = .init(values: values, selectedIndex: selectedIndex)
    }

    func map<ToValueT>(_ transform: (ValueT) -> ToValueT) -> SelectionState<ToValueT> {
        .init(
            values: values.map(transform),
            selectedIndex: selectedIndex
        )
    }
}
