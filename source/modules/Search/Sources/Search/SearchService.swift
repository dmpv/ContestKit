//
//  SearchService.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 11.08.2021.
//

import Foundation

import ToolKit

struct SearchRequest: StateType {
    var query: String
    var sectionID: SearchSection.ID
    var pageID: String?
}

struct SearchResponse: StateType {
    var result: SearchResult
    var nextPageID: String?
}


class SearchService {
    func asyncExecute(_ execute: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            execute()
        }
    }

    func fetchSearchResult(for request: SearchRequest, then: @escaping (Result<SearchResponse, Error>) -> Void) {
        asyncExecute {
            then(.success(Stub.searchResponse(for: request)))
        }
    }
}

extension SearchService {
    enum Error: Swift.Error {
        case common
    }
}
