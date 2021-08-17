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
    var selectedSectionID: SearchSectionID = .media
}

extension SearchState: SectionedListType {
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

extension SearchResult: SectionedListType {}

enum SearchSectionID: String, CaseIterable, IDType {
    case challenge
    case media
    case user
}

struct SearchSection {
    var items: [SearchItem] = []
}

extension SearchSection: SectionType {
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
    case media(MediaSearchItem)
    case user(UserSearchItem)
}

extension SearchItem: Identifiable {
    var id: SearchItemID {
        switch self {
        case .challenge(let item):
            return .init(sectionID: .challenge, itemSubID: item.id)
        case .media(let item):
            return .init(sectionID: .media, itemSubID: item.id)
        case .user(let item):
            return .init(sectionID: .user, itemSubID: item.id)
        }
    }
}

extension SearchItem: ItemType {}

struct ChallengeSearchItem: StateType, Identifiable {
    var id: String
    var name: String
    var status: ChallengeStatus
    var duration: DateInterval
    var mediaCount: Int
    var reward: Int

    var stub__description: String
}

enum ChallengeStatus: StateType {
    case created
    case active
    case completed
}

struct MediaSearchItem: StateType, Identifiable {
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
    var name: String
    var avatarURL: URL
    var followerCount: Int
    var mediaCount: Int
    var challengeCount: Int

    var stub__description: String
}
