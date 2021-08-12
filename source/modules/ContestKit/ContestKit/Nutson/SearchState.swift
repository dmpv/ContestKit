//
//  SearchState.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 13.08.2021.
//

import Foundation

import ToolKit

struct SearchState: StateType {
    var status: SearchStatus = .loaded(result: SearchResult())
    var selectedSectionID: SearchSectionID = .video
}

extension SearchState: XectionedListType {
    typealias Section = SearchSection

    var sections: [SearchSection] {
        status.result?.sections.filter { $0.id == selectedSectionID } ?? []
    }
}

enum SearchStatus: StateType {
    case loaded(result: SearchResult)
    case loading(query: String)
}

struct SearchResult: StateType {
    var query: String = ""
    var sections: [SearchSection] = []
}

extension SearchResult: XectionedListType {}

enum SearchSectionID: String, CaseIterable, IDType {
    case challenge
    case video
    case user
}

struct SearchSection {
    var items: [SearchItem] = []
}

extension SearchSection: XectionType {
    var id: SearchSectionID {
        assert(items.map(\.id).areUnique)
        return items.first!.id.sectionID
    }
}

struct SearchItemID: IDType {
    var sectionID: SearchSectionID
    var itemSubID: String
}

enum SearchItem: StateType {
    case challenge(ChallengeSearchItem)
    case video(VideoSearchItem)
    case user(UserSearchItem)
}

extension SearchItem: Identifiable {
    var id: SearchItemID {
        switch self {
        case .challenge(let item):
            return .init(sectionID: .challenge, itemSubID: item.id)
        case .video(let item):
            return .init(sectionID: .video, itemSubID: item.id)
        case .user(let item):
            return .init(sectionID: .user, itemSubID: item.id)
        }
    }
}

extension SearchItem: ItemType {}

struct ChallengeSearchItem: StateType, Identifiable {
    var id: String
}

struct VideoSearchItem: StateType, Identifiable {
    var id: String
    var previewURL: URL
    var userName: String
    var userAvatarURL: URL
    var likeCount: Int
    var impressionCount: Int

    var stub__description: String
}

struct UserSearchItem: StateType, Identifiable {
    var id: String
    var userName: String
}
