//
//  EditorState+substates.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 28.01.2021.
//

import Foundation

extension EditorState {
    var sectionedList: SectionedListState {
        get {
            .init(
                sections: [
                    .common(
                        rows: [
                            .picker(.messageAnimationID(messageAnimationConfig.id)),
                            .picker(.messageAnimationDuration(messageAnimationConfig.duration)),
                            .button(.share),
                            .button(.fetch),
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
                case .common:
                    return nil
                case .timing(_, let rows):
                    guard case .animationTiming(let timing) = rows[0] else { return fallback(nil) }
                    return timing
                }
            }
        }
    }
}
