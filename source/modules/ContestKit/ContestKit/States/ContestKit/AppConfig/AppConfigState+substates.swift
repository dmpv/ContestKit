//
//  AppConfigState+substates.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 31.01.2021.
//

import Foundation

extension AppConfigState {
    var durationSelection: SelectionState<TimeInterval> {
        get {
            assert(draftMessageAnimationConfigs.map(\.duration).unique.count == 1)
            return .init(
                values: durations,
                selectedValue: draftMessageAnimationConfigs[0].duration
            )
        }
        set(newDurationSelection) {
            assert(newDurationSelection.values == durationSelection.values)
            for index in draftMessageAnimationConfigs.indices {
                draftMessageAnimationConfigs[index].duration = newDurationSelection.selectedValue
            }
        }
    }

    var messageAnimationIDPickerSectionedList: SectionedListState {
        get {
            .init(
                sections: [
                    .messageAnimations(
                        rows: draftMessageAnimationConfigs.map { messageAnimationConfig in
                            .button(.messageAnimation(id: messageAnimationConfig.id))
                        }
                    ),
                    .backgroundAnimation(
                        rows: []
                    )
                ]
            )
        }
        set {
            fatalError(.shouldNeverBeCalled(nil))
        }
    }
}
