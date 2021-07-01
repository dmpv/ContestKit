//
//  RowState+substates.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 29.01.2021.
//

import Foundation

import ToolKit

extension RowState {
    var cell: Any {
        switch self {
        case .picker(.messageAnimationID(let id)):
            return PickerCell.State(
                name: L10n.stub("Animation Type"),
                selectedOption: id.titleFormatted(verbose: false)
            )
        case .picker(.messageAnimationDuration(let timeInterval)):
            return PickerCell.State(
                name: L10n.stub("Duration"),
                selectedOption: timeInterval.frameCountFormatted(verbose: true)
            )
        case .button(.share):
            return ButtonCell.State(name: L10n.stub("Share Parameters"))
        case .button(.import):
            return ButtonCell.State(name: L10n.stub("Import Parameters"))
        case .button(.restore):
            return ButtonCell.State(
                name: L10n.stub("Restore to Default"),
                appearance: .makeDestructive()
            )
        case .button(.messageAnimation(let id)):
            return ButtonCell.State(
                name: id.titleFormatted(verbose: true)
            )
        case .animationTiming(let messageAnimationTiming):
            return AnimationTimingCell.State(timing: messageAnimationTiming.timing)
        }
    }
}
