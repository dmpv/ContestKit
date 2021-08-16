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
            name: "Challenge \(index)",
            status: .created,
            duration: .init(
                start: Date.init(timeIntervalSinceNow: -10_000),
                end: Date.init(timeIntervalSinceNow: -10_000)
            ),
            mediaCount: 1000_000,
            reward: 10000,
            stub__description: "Group \(index / 20)"
        )
    }

    static func videoSearchItem(for index: Int) -> VideoSearchItem {
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

        let allVideoSearchItems = (0..<itemCount).map { videoSearchItem(for: $0) }
        let queriedVideoSearchItems = allVideoSearchItems.filter { item in
            item.stub__description.hasPrefix(query)
        }
        let videoSection: SearchSection? = queriedVideoSearchItems == []
            ? nil
            : .init(items: queriedVideoSearchItems.map { .video($0) })

        return .init(
            query: query,
            sections: [challengeSection, videoSection].compactMap { $0 }
        )
    }
}
