//
//  AnimationState.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 27.01.2021.
//

import Foundation

public struct TimePoint: ValueType, Equatable {
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

public struct AnimationTiming: ValueType, Equatable {
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

public struct MessageAnimationConfigState: ValueType, Equatable {
    var positionXTiming: AnimationTiming = .init()
    var positionYTiming: AnimationTiming = .init()
    var bubbleShape: AnimationTiming = .init()

    public init(
        positionXTiming: AnimationTiming = .init(),
        positionYTiming: AnimationTiming = .init(),
        bubbleShape: AnimationTiming = .init()
    ) {
        self.positionXTiming = positionXTiming
        self.positionYTiming = positionYTiming
        self.bubbleShape = bubbleShape
    }
}
