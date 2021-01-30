//
//  MessageAnimationTimingState.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 30.01.2021.
//

import Foundation

public enum MessageAnimationTimingID: String, IDType {
    case positionX
    case positionY
    case timeAppears

    case bubbleShape
    case textPosition
    case colorChange

    case emojiScale
}

extension MessageAnimationTimingID: Codable {}

public enum MessageAnimationTimingState: StateType {
    case positionX(AnimationTimingState)
    case positionY(AnimationTimingState)
    case timeAppears(AnimationTimingState)

    case bubbleShape(AnimationTimingState)
    case textPosition(AnimationTimingState)
    case colorChange(AnimationTimingState)

    case emojiScale(AnimationTimingState)
}

extension MessageAnimationTimingState: CKIdentifiable {
    var id: MessageAnimationTimingID {
        get {
            switch self {
            case .positionX:
                return .positionX
            case .positionY:
                return .positionY
            case .timeAppears:
                return .timeAppears
            case .bubbleShape:
                return .bubbleShape
            case .textPosition:
                return .textPosition
            case .colorChange:
                return .colorChange
            case .emojiScale:
                return .emojiScale
            }
        }
        set {
            switch newValue {
            case .positionX:
                self = .positionX(.init())
            case .positionY:
                self = .positionY(.init())
            case .timeAppears:
                self = .timeAppears(.init())
            case .bubbleShape:
                self = .bubbleShape(.init())
            case .textPosition:
                self = .textPosition(.init())
            case .colorChange:
                self = .colorChange(.init())
            case .emojiScale:
                self = .emojiScale(.init())
            }
        }
    }
}

extension MessageAnimationTimingState {
    var timing: AnimationTimingState {
        get {
            switch self {
            case .positionX(let timing),
                 .positionY(let timing),
                 .bubbleShape(let timing),
                 .timeAppears(let timing),
                 .textPosition(let timing),
                 .colorChange(let timing),
                 .emojiScale(let timing):
                return timing
            }
        }
        set(newTiming) {
            switch self {
            case .positionX:
                self = .positionX(newTiming)
            case .positionY:
                self = .positionY(newTiming)
            case .bubbleShape:
                self = .bubbleShape(newTiming)
            case .timeAppears:
                self = .timeAppears(newTiming)
            case .textPosition:
                self = .textPosition(newTiming)
            case .colorChange:
                self = .colorChange(newTiming)
            case .emojiScale:
                self = .emojiScale(newTiming)
            }
        }
    }
}

extension MessageAnimationTimingID {
    var editorSectionTitle: String {
        switch self {
        case .positionX:
            return L10n.stub("X Position")
        case .positionY:
            return L10n.stub("Y Position")
        case .timeAppears:
            return L10n.stub("Time Appears")
        case .bubbleShape:
            return L10n.stub("Bubble Shape")
        case .textPosition:
            return L10n.stub("Text Position")
        case .colorChange:
            return L10n.stub("Color Change")
        case .emojiScale:
            return L10n.stub("Emoji Scale")
        }
    }
}

extension MessageAnimationTimingState: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case timing
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(MessageAnimationTimingID.self, forKey: .id)
        let timing = try container.decode(AnimationTimingState.self, forKey: .timing)
        self = .positionX(.init())
        self.id = id
        self.timing = timing
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(timing, forKey: .timing)
    }
}
