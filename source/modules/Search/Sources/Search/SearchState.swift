//
//  SearchState.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 13.08.2021.
//

import Foundation

import ToolKit
import ComponentKit

struct SearchState: StateType {
    var status: SearchStatus = .loaded(result: SearchResult())
    var selectedSectionID: SearchSection.ID = .media
}

enum SearchStatus: StateType {
    case loaded(result: SearchResult)
    case loading(query: String)
}

struct SearchResult: StateType {
    var query: String = ""
    var sections: [SearchSection] = []
}

struct SearchSection: StateType {
    var items: [SearchItem] = []
}

extension SearchSection: Identifiable {
    var id: ID {
        assert(items.map(\.id).areUnique)
        return items.first!.id.sectionID
    }

    enum ID: String, CaseIterable, IDType {
        case challenge
        case media
        case user
    }
}
