//
//  MessageAnimationTimingState+substates.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 31.01.2021.
//

import Foundation

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
