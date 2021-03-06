//
//  _XectionedListState+substates.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 28.01.2021.
//

import Foundation

import ToolKit

extension _XectionedListState {
    var view: _XectionedListView.State {
        .init(sectionedList: self)
    }

    var rows: [RowState] {
        get {
            sections.flatMap(\.rows)
        }
        set(newRows) {
            guard newRows.map(\.id) == rows.map(\.id) else { return fallback() }
            for sectionIndex in sections.indices {
                for newRow in newRows {
                    if sections[sectionIndex].rows[safe: newRow.id] != nil {
                        sections[sectionIndex].rows[newRow.id] = newRow
                    }
                }
            }
        }
    }
}
