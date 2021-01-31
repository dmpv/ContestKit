//
//  AnimationTimingState+helpers.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 31.01.2021.
//

import Foundation

extension AnimationTimingState {
    static func makeDefault(totalDuration: TimeInterval = 1) -> Self {
        .init(
            startsAt: 0,
            c1: .init(x: totalDuration * 0.5, y: 0),
            c2: .init(x: totalDuration * 0.5, y: 1),
            endsAt: totalDuration,
            minDuration: 0.2,
            totalDuration: totalDuration
        )
    }
}
