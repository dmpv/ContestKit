//
//  mocks.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 13.08.2021.
//

import Foundation

import ToolKit

extension Stub {
    static func challengeSearchItem(for index: Int) -> ChallengeSearchItem {
        .init(
            id: "\(index)",
            name: [
                "[\(index)] Lorem ipsum dolor sit amet, consectetur adipiscing",
                "[\(index)] Lorem ipsum dolor sit amet",
            ].randomElement()!,
            status: [.created, .active, .completed].randomElement()!,
            duration: .init(
                start: Date.init(timeIntervalSinceNow: -10_000),
                end: Date.init(timeIntervalSinceNow: -10_000)
            ),
            mediaCount: 1000_000,
            reward: 10000,
            stub__description: "Group \(index / 20)"
        )
    }

    static func mediaSearchItem(for index: Int) -> MediaSearchItem {
        .init(
            id: "\(index)",
            previewURL: Stub.url(
                forImageWithSize: .init(
                    width: 400 + (-5...5).randomElement()!,
                    height: 400 + (-5...5).randomElement()!
                )
            ),
            userName: "User \(index)",
            userAvatarURL: Stub.url(
                forImageWithSize: .init(
                    width: 200 + (-5...5).randomElement()!,
                    height: 200 + (-5...5).randomElement()!
                )
            ),
            likeCount: 1000_000_000,
            impressionCount: 1000_000_000,
            stub__description: "Group \(index / 20)"
        )
    }

    static func userSearchItem(for index: Int) -> UserSearchItem {
        .init(
            id: "\(index)",
            name: [
                "@[\(index)]Konstantin-Konstantinovich-Konstantinopolski",
                "@[\(index)]Ivan",
                "@[\(index)]prince.albert",
            ].randomElement()!,
            avatarURL: Stub.url(
                forImageWithSize: .init(width: 200, height: 200)
            ),
            followerCount: 100_000,
            mediaCount: 200_000,
            challengeCount: 10_000,
            stub__description: "Group \(index / 20)"
        )
    }

    static func searchResult(for query: String) -> SearchResult {
        guard query != "" else {
            return .init()
        }
        let itemCount = 100

        let allChallengeSearchItems = (0..<itemCount).map { challengeSearchItem(for: $0) }
        let queriedChallengeSearchItems = allChallengeSearchItems.filter { item in
            item.stub__description.hasPrefix(query)
        }
        let challengeSection: SearchSection? = queriedChallengeSearchItems == []
            ? nil
            : .init(items: queriedChallengeSearchItems.map { .challenge($0) })

        let allMediaSearchItems = (0..<itemCount).map { mediaSearchItem(for: $0) }
        let queriedMediaSearchItems = allMediaSearchItems.filter { item in
            item.stub__description.hasPrefix(query)
        }
        let mediaSection: SearchSection? = queriedMediaSearchItems == []
            ? nil
            : .init(items: queriedMediaSearchItems.map { .media($0) })

        let allUserSearchItems = (0..<itemCount).map { userSearchItem(for: $0) }
        let queriedUserSearchItems = allUserSearchItems.filter { item in
            item.stub__description.hasPrefix(query)
        }
        let userSection: SearchSection? = queriedUserSearchItems == []
            ? nil
            : .init(items: queriedUserSearchItems.map { .user($0) })

        return .init(
            query: query,
            sections: [challengeSection, mediaSection, userSection].compactMap { $0 }
        )
    }
}
