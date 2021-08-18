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
    var query: String = ""
    var paginatedSections: [SearchPaginatedSection] = []
    var selectedSectionID: SearchSection.ID = .challenge
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

struct SearchPaginatedSection: StateType, Identifiable {
    var id: SearchSection.ID
    var status: SearchPaginationStatus
}

typealias SearchPaginationStatus = PaginationStatus<SearchSection, String>

enum PaginationStatus<DataT: StateType, PageIDT: IDType>: StateType {
    case empty(loadingStatus: LoadingStatus)
    case partial(data: DataT, nextPageID: PageIDT, loadingStatus: LoadingStatus)
    case full(data: DataT?)
}

enum LoadingStatus {
    case idle
    case loading
}
