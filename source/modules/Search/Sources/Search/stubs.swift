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
            userAvatarURL: Stub.avatarImageURL(),
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
            avatarURL: Stub.avatarImageURL(),
            followerCount: 100_000,
            mediaCount: 200_000,
            challengeCount: 10_000,
            stub__description: "Group \(index / 20)"
        )
    }

    static func searchResult(for query: String, sectionID: SearchSection.ID) -> SearchResult {
        guard query != "" else {
            return .init()
        }
        let totalItemCount = 1000

        switch sectionID {
        case .challenge:
            let allChallengeSearchItems = (0..<totalItemCount).map { challengeSearchItem(for: $0) }
            let queriedChallengeSearchItems = allChallengeSearchItems.filter { item in
                item.stub__description.hasPrefix(query)
            }
            let challengeSection: SearchSection? = queriedChallengeSearchItems == []
                ? nil
                : .init(items: queriedChallengeSearchItems.map { .challenge($0) })
            return .init(
                query: query,
                sections: [challengeSection].compactMap { $0 }
            )
        case .media:
            let allMediaSearchItems = (0..<totalItemCount).map { mediaSearchItem(for: $0) }
            let queriedMediaSearchItems = allMediaSearchItems.filter { item in
                item.stub__description.hasPrefix(query)
            }
            let mediaSection: SearchSection? = queriedMediaSearchItems == []
                ? nil
                : .init(items: queriedMediaSearchItems.map { .media($0) })
            return .init(
                query: query,
                sections: [mediaSection].compactMap { $0 }
            )
        case .user:
            let allUserSearchItems = (0..<totalItemCount).map { userSearchItem(for: $0) }
            let queriedUserSearchItems = allUserSearchItems.filter { item in
                item.stub__description.hasPrefix(query)
            }
            let userSection: SearchSection? = queriedUserSearchItems == []
                ? nil
                : .init(items: queriedUserSearchItems.map { .user($0) })
            return .init(
                query: query,
                sections: [userSection].compactMap { $0 }
            )
        }
    }

    static func searchResponse(for request: SearchRequest) -> SearchResponse {
        let wholeResult = searchResult(for: request.query, sectionID: request.sectionID)
        guard let wholeSection = wholeResult.sections[safe: request.sectionID] else {
            return .init(section: nil, nextPageID: nil)
        }
        let id = request.pageID ?? nextPageID(
            for: request.pageID,
            totalElementCount: wholeSection.items.count
        )!

        return .init(
            section: .init(items: Array(wholeSection.items[range(for: id)])),
            nextPageID: nextPageID(for: id, totalElementCount: wholeSection.items.count)
        )
    }

    static func range(for str: String) -> Range<Int> {
        try! JSONDecoder().decode(Range<Int>.self, from: str.data(using: .utf8)!)
    }

    static func string(for range: Range<Int>) -> String {
        let data = try! JSONEncoder().encode(range)
        return String(data: data, encoding: .utf8)!
    }

    static func nextPageID(
        for pageID: String?,
        totalElementCount: Int,
        pageSize: Int = 50
    ) -> String? {
        switch pageID {
        case nil:
            return string(for: 0..<pageSize)
        case let pageID?:
            let lastElementIndex = range(for: pageID).upperBound
            return lastElementIndex < totalElementCount - 1
                ? string(for: lastElementIndex..<(lastElementIndex + pageSize))
                : nil
        }
    }
}
