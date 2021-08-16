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
                forImageWithSize: .init(width: 200, height: 200)
            ),
            userName: "User \(index)",
            userAvatarURL: Stub.url(
                forImageWithSize: .init(width: 50, height: 50)
            ),
            likeCount: 1000_000_000,
            impressionCount: 1000_000_000,
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

        return .init(
            query: query,
            sections: [challengeSection, mediaSection].compactMap { $0 }
        )
    }
}
