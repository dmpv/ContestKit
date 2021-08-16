//
//  MessageAnimationEditorState+substates.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 28.01.2021.
//

import Foundation

import ToolKit

extension MessageAnimationEditorState {
    var sectionedList: _XectionedListState {
        get {
            .init(
                sections: [
                    .common(
                        rows: [
                            .picker(.messageAnimationID(messageAnimationConfig.id)),
                            .picker(.messageAnimationDuration(messageAnimationConfig.duration)),
                            .button(.share),
                            .button(.import),
                            .button(.restore)
                        ]
                    )
                ] + messageAnimationConfig.timings.map { timing in
                    .timing(
                        timing.id,
                        rows: [
                            .animationTiming(timing)
                        ]
                    )
                }
            )
        }
        set {
            messageAnimationConfig.timings = newValue.sections.compactMap { section in
                switch section {
                case .messageAnimations,
                     .backgroundAnimation,
                     .common:
                    return nil
                case .timing(_, let rows):
                    guard case .animationTiming(let timing) = rows[0] else { return fallback(nil) }
                    return timing
                }
            }
        }
    }
}
