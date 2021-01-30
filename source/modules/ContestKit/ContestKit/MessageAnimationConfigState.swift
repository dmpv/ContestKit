//
//  MessageAnimationConfigState.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 28.01.2021.
//

import Foundation

public enum MessageAnimationConfigID: String, IDType {
    case smallText
    case bigText
    case linkWithPreview
    case singleEmoji
    case sticker
    case voiceMessage
    case videoMessage
}

extension MessageAnimationConfigID: Codable {}

public enum MessageAnimationConfigState: StateType {
    case smallText([MessageAnimationTimingState])
    case bigText([MessageAnimationTimingState])
    case linkWithPreview([MessageAnimationTimingState])
    case singleEmoji([MessageAnimationTimingState])
    case sticker([MessageAnimationTimingState])
    case voiceMessage([MessageAnimationTimingState])
    case videoMessage([MessageAnimationTimingState])
}

extension MessageAnimationConfigState: CKIdentifiable {
    var id: MessageAnimationConfigID {
        get {
            switch self {
            case .smallText:
                return .smallText
            case .bigText:
                return .bigText
            case .linkWithPreview:
                return .linkWithPreview
            case .singleEmoji:
                return .singleEmoji
            case .sticker:
                return .sticker
            case .voiceMessage:
                return .voiceMessage
            case .videoMessage:
                return .videoMessage
            }
        }
        set {
            switch newValue {
            case .smallText:
                self = .smallText([])
            case .bigText:
                self = .bigText([])
            case .linkWithPreview:
                self = .linkWithPreview([])
            case .singleEmoji:
                self = .singleEmoji([])
            case .sticker:
                self = .sticker([])
            case .voiceMessage:
                self = .voiceMessage([])
            case .videoMessage:
                self = .videoMessage([])
            }
        }
    }
}

extension MessageAnimationConfigState {
    var timings: [MessageAnimationTimingState] {
        get {
            switch self {
            case .smallText(let timings),
                 .bigText(let timings),
                 .linkWithPreview(let timings),
                 .singleEmoji(let timings),
                 .sticker(let timings),
                 .voiceMessage(let timings),
                 .videoMessage(let timings):
                return timings
            }
        }
        set(newTimings) {
            switch self {
            case .smallText:
                self = .smallText(newTimings)
            case .bigText:
                self = .bigText(newTimings)
            case .linkWithPreview:
                self = .linkWithPreview(newTimings)
            case .singleEmoji:
                self = .singleEmoji(newTimings)
            case .sticker:
                self = .sticker(newTimings)
            case .voiceMessage:
                self = .voiceMessage(newTimings)
            case .videoMessage:
                self = .videoMessage(newTimings)
            }
        }
    }

    var duration: TimeInterval {
        assert(timings.areUnique)
        return timings[0].timing.totalDuration
    }
}

extension MessageAnimationConfigState {
    var editor: MessageAnimationEditorState {
        get {
            .init(messageAnimationConfig: self)
        }
        set {
            self = newValue.messageAnimationConfig
        }
    }
}

extension MessageAnimationConfigID {
    var titleFormatted: String {
        switch self {
        case .smallText:
            return L10n.stub("Small Message (fits in the input field)")
        case .bigText:
            return L10n.stub("Big Message (doesn't fit into the input field)")
        case .linkWithPreview:
            return L10n.stub("Link with Preview")
        case .singleEmoji:
            return L10n.stub("Single Emoji")
        case .sticker:
            return L10n.stub("Sticker")
        case .voiceMessage:
            return L10n.stub("Voice Message")
        case .videoMessage:
            return L10n.stub("Video Message")
        }
    }
}

extension MessageAnimationConfigState: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case timings
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(MessageAnimationConfigID.self, forKey: .id)
        let timings = try container.decode([MessageAnimationTimingState].self, forKey: .timings)
        self = .smallText([])
        self.id = id
        self.timings = timings
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(timings, forKey: .timings)
    }
}
