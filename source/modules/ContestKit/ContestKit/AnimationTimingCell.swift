//
//  AnimationTimingCell.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 27.01.2021.
//

import Foundation

class AnimationTimingCell: Namespace {
}

extension AnimationTimingCell {
    struct State: ValueType, Equatable {
        var name: String
        var timing: AnimationTiming
    }
}
