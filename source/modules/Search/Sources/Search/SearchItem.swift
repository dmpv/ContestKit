//
//  File.swift
//  
//
//  Created by Dmitry Purtov on 18.08.2021.
//

import Foundation

import ToolKit

enum SearchItem: StateType {
    case challenge(ChallengeSearchItem)
    case media(MediaSearchItem)
    case user(UserSearchItem)
}

extension SearchItem: Identifiable {
    var id: ID {
        switch self {
        case .challenge(let item):
            return .init(sectionID: .challenge, itemSubID: item.id)
        case .media(let item):
            return .init(sectionID: .media, itemSubID: item.id)
        case .user(let item):
            return .init(sectionID: .user, itemSubID: item.id)
        }
    }

    struct ID: IDType {
        var sectionID: SearchSection.ID
        var itemSubID: String
    }
}

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
