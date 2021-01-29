//
//  SmallMessageAnimationConfig.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 28.01.2021.
//

import Foundation

public enum MessageAnimationConfigID: IDType {
    case smallText
    case bubble
}

extension MessageAnimationConfigID {
    var titleFormatted: String {
        switch self {
        case .smallText:
            return L10n.stub("Small Text")
        case .bubble:
            return L10n.stub("Bubble")
        }
    }
}

public enum MessageAnimationConfigState: Equatable {
    case smallText([MessageAnimationTimingState])
    case bubble([MessageAnimationTimingState])
}

extension MessageAnimationConfigState: CKIdentifiable {
    var id: MessageAnimationConfigID {
        switch self {
        case .smallText:
            return .smallText
        case .bubble:
            return .bubble
        }
    }
}

extension MessageAnimationConfigState {
    var timings: [MessageAnimationTimingState] {
        get {
            switch self {
            case .smallText(let timings),
                    .bubble(let timings):
                return timings
            }
        }
        set(newTimings) {
            switch self {
            case .smallText:
                self = .smallText(newTimings)
            case .bubble:
                self = .bubble(newTimings)
            }
        }
    }

    var duration: TimeInterval {
        assert(timings.areUnique)
        return timings[0].timing.totalDuration
    }
}


public enum MessageAnimationTimingID: IDType {
    case positionX
    case positionY
    case timeAppears

    case bubbleShape
    case textPosition
    case colorChange

    case emojiScale
}

public enum MessageAnimationTimingState: Equatable {
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
