//
//  AnimationState.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 27.01.2021.
//

import Foundation

public struct AnimationTimingState: StateType {
    var startsAt: TimeInterval = 0
    var c1: TimePoint = .init()
    var c2: TimePoint = .init()
    var endsAt: TimeInterval = 0
    var duration: TimeInterval = 0

    public init(
        startsAt: TimeInterval = 0,
        c1: TimePoint = .init(),
        c2: TimePoint = .init(),
        endsAt: TimeInterval = 0,
        duration: TimeInterval = 0
    ) {
        self.startsAt = startsAt
        self.c1 = c1
        self.c2 = c2
        self.endsAt = endsAt
        self.duration = duration
    }
}

extension AnimationTimingState {
    static func makeDefault(duration: TimeInterval) -> Self {
        .init(
            startsAt: 0,
            c1: .init(x: duration * 0.5),
            c2: .init(x: duration * -0.5),
            endsAt: duration,
            duration: duration
        )
    }
}

public struct TimePoint: StateType {
    var x: TimeInterval = 0
    var y: TimeInterval = 0

    public init(
        x: TimeInterval = 0,
        y: TimeInterval = 0
    ) {
        self.x = x
        self.y = y
    }
}
