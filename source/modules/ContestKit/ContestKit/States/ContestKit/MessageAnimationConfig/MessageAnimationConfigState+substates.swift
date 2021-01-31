//
//  MessageAnimationConfigState+substates.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 31.01.2021.
//

import Foundation

extension MessageAnimationConfigID {
    func titleFormatted(verbose: Bool) -> String {
        switch self {
        case .smallText:
            return L10n.stub("Small Message")
                + (verbose ? " (fits in the input field)" : "")
        case .bigText:
            return L10n.stub("Big Message")
                + (verbose ? " (doesn't fit into the input field)" : "")
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

extension MessageAnimationConfigState {
    var editor: MessageAnimationEditorState {
        get {
            .init(messageAnimationConfig: self)
        }
        set {
            self = newValue.messageAnimationConfig
        }
    }

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
        get {
            assert(timings.map(\.timing.totalDuration).unique.count == 1)
            return timings[0].timing.totalDuration
        }
        set(newDuration) {
            for index in timings.indices {
                timings[index].timing.updateTotalDuration(newDuration)
            }
        }
    }
}
