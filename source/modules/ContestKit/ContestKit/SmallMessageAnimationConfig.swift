//
//  SmallMessageAnimationConfig.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 28.01.2021.
//

import Foundation

public enum MessageAnimationConfigID: Equatable {
    case smallText
    case bubble
}

extension MessageAnimationConfigID {
    var pickerCellOptionTitle: String {
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
    case bubbleShape
}

extension MessageAnimationTimingID {
    var editorSectionTitle: String {
        switch self {
        case .positionX:
            return L10n.stub("Position X")
        case .positionY:
            return L10n.stub("Position Y")
        case .bubbleShape:
            return L10n.stub("Bubble Shape")
        }
    }
}

public enum MessageAnimationTimingState: Equatable {
    case positionX(AnimationTimingState)
    case positionY(AnimationTimingState)
    case bubbleShape(AnimationTimingState)
}

extension MessageAnimationTimingState: CKIdentifiable {
    var id: MessageAnimationTimingID {
        switch self {
        case .positionX:
            return .positionX
        case .positionY:
            return .positionY
        case .bubbleShape:
            return .bubbleShape
        }
    }
}

extension MessageAnimationTimingState {
    var timing: AnimationTimingState {
        get {
            switch self {
            case .positionX(let timing),
                 .positionY(let timing),
                 .bubbleShape(let timing):
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


public struct AppConfigState: StateType {
    var messageAnimationConfigs: [MessageAnimationConfigState] = []
    var defaultMessageAnimationConfigs: [MessageAnimationConfigState] = []

    public init(
        messageAnimationConfigs: [MessageAnimationConfigState] = [],
        defaultMessageAnimationConfigs: [MessageAnimationConfigState] = []
    ) {
        self.messageAnimationConfigs = messageAnimationConfigs
        self.defaultMessageAnimationConfigs = defaultMessageAnimationConfigs
    }
}

extension AppConfigState {
    static let initialMessageAnimationConfigs: [MessageAnimationConfigState] = [
        .smallText([
            .positionX(.makeDefault(totalDuration: 1)),
            .positionY(.makeDefault(totalDuration: 1))
        ]),
        .bubble([
            .bubbleShape(.makeDefault(totalDuration: 1))
        ]),
    ]
}
