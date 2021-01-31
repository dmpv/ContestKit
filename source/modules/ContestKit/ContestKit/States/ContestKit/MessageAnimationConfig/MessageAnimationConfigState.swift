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
}
