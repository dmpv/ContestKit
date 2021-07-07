//
//  MessageAnimationTimingState.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 30.01.2021.
//

import Foundation

import ToolKit

public enum MessageAnimationTimingID: String, IDType {
    case positionX
    case positionY
    case timeAppears

    case bubbleShape
    case textPosition
    case colorChange

    case emojiScale
}

public enum MessageAnimationTimingState: StateType {
    case positionX(AnimationTimingState)
    case positionY(AnimationTimingState)
    case timeAppears(AnimationTimingState)

    case bubbleShape(AnimationTimingState)
    case textPosition(AnimationTimingState)
    case colorChange(AnimationTimingState)

    case emojiScale(AnimationTimingState)
}

extension MessageAnimationTimingState: Identifiable {
    public var id: MessageAnimationTimingID {
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
