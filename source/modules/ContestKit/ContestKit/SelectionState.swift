//
//  SelectionState.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 30.01.2021.
//

import Foundation

struct SelectionState<ValueT: Equatable>: Equatable {
    var values: [ValueT] { didSet { validate() } }
    var selectedValue: ValueT { didSet { validate() } }

    init(values: [ValueT], selectedValue: ValueT) {
        self.values = values
        self.selectedValue = selectedValue
        validate()
    }

    private func validate() {
        assert(values != [])
        assert(values.areUnique)
        assert(values.contains(selectedValue))
    }
}

extension SelectionState {
    var selectedIndex: Int {
        get { values.firstIndex(of: selectedValue)! }
        set { selectedValue = values[newValue] }
    }
}

extension SelectionState: Hashable where ValueT: Hashable {}

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
