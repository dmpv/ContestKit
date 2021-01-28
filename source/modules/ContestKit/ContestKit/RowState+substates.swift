//
//  RowState+substates.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 29.01.2021.
//

import Foundation

extension RowState {
    var cell: Any {
        switch self {
        case .picker(.messageAnimationID(let id)):
            return PickerCell.State(
                name: L10n.stub("Animation Type"),
                selectedOption: id.pickerCellFormatted
            )
        case .picker(.messageAnimationDuration(let timeInterval)):
            return PickerCell.State(
                name: L10n.stub("Animation Type"),
                selectedOption: timeInterval.pickerCellFormatted
            )
        case .button(.share):
            return ButtonCell.State(name: L10n.stub("Share Parameters"))
        case .button(.fetch):
            return ButtonCell.State(name: L10n.stub("Import Parameters"))
        case .button(.restore):
            return ButtonCell.State(
                name: L10n.stub("Restore to Default"),
                appearance: .makeDestructive()
            )
        case .animationTiming:
            return AnimationTimingCell.State()
        }
    }
}
