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
    var section: SearchSection?
    var nextPageID: String?
}


class SearchService {
    func asyncBackgroundExecute(_ execute: @escaping () -> Void) {
        DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: .now() + .milliseconds(300)) {
            execute()
        }
    }

    func fetchSearchResult(for request: SearchRequest, then: @escaping (Result<SearchResponse, Error>) -> Void) {
        log("Start fetchSearchResult: \(request)")
        asyncBackgroundExecute {
            let response = Stub.searchResponse(for: request)
            log("""
                END fetchSearchResult:
                -> \(request)
                <- \(response.nextPageID), \(response.section?.items.count ?? 0)
            """)
            DispatchQueue.main.async {
                then(.success(response))
            }
        }
    }
}

extension SearchService {
    enum Error: Swift.Error {
        case common
    }
}
