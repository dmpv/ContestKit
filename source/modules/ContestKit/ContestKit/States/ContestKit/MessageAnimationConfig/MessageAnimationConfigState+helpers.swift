//
//  MessageAnimationConfigState+helpers.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 31.01.2021.
//

import Foundation

extension MessageAnimationConfigState {
    init(id: MessageAnimationConfigID, timings: [MessageAnimationTimingState]) {
        switch id {
        case .smallText:
            self = .smallText(timings)
        case .bigText:
            self = .bigText(timings)
        case .linkWithPreview:
            self = .linkWithPreview(timings)
        case .singleEmoji:
            self = .singleEmoji(timings)
        case .sticker:
            self = .sticker(timings)
        case .voiceMessage:
            self = .voiceMessage(timings)
        case .videoMessage:
            self = .videoMessage(timings)
        }
    }
}

extension MessageAnimationConfigID: Codable {}

extension MessageAnimationConfigState: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case timings
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(MessageAnimationConfigID.self, forKey: .id)
        let timings = try container.decode([MessageAnimationTimingState].self, forKey: .timings)
        self.init(id: id, timings: timings)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(timings, forKey: .timings)
    }
}
