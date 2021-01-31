//
//  MessageAnimationTimingState+helpers.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 31.01.2021.
//

import Foundation

extension MessageAnimationTimingState {
    init(id: MessageAnimationTimingID, timing: AnimationTimingState) {
        switch id {
        case .positionX:
            self = .positionX(timing)
        case .positionY:
            self = .positionY(timing)
        case .timeAppears:
            self = .timeAppears(timing)
        case .bubbleShape:
            self = .bubbleShape(timing)
        case .textPosition:
            self = .textPosition(timing)
        case .colorChange:
            self = .colorChange(timing)
        case .emojiScale:
            self = .emojiScale(timing)
        }
    }
}

extension MessageAnimationTimingID: Codable {}

extension MessageAnimationTimingState: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case timing
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(MessageAnimationTimingID.self, forKey: .id)
        let timing = try container.decode(AnimationTimingState.self, forKey: .timing)
        self.init(id: id, timing: timing)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(timing, forKey: .timing)
    }
}
