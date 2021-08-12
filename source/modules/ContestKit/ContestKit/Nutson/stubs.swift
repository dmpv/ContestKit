//
//  mocks.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 13.08.2021.
//

import Foundation

import ToolKit

extension Stub {
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
        let allVideoSearchItems = (0..<itemCount).map { videoSearchItem(for: $0) }
        let queriedVideoSearchItems = allVideoSearchItems.filter { $0.stub__description.hasPrefix(query) }
        return .init(
            query: query,
            sections: queriedVideoSearchItems == [] ? [] : [
                .init(items: queriedVideoSearchItems.map { .video($0) })
            ]
        )
    }
}
