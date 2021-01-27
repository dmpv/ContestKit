//
//  AnimationState.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 27.01.2021.
//

import Foundation

struct TimePoint: ValueType, Equatable {
    var x: TimeInterval = 0
    var y: TimeInterval = 0
}

struct AnimationTiming: ValueType, Equatable {
    var startsAt: TimeInterval = 0
    var c1: TimePoint = .init()
    var c2: TimePoint = .init()
    var endsAt: TimeInterval = 0
    var duration: TimeInterval = 0
}

struct MessageAnimationParams: ValueType, Equatable {
    var positionXTiming: AnimationTiming
    var positionYTiming: AnimationTiming
    var bubbleShape: AnimationTiming
}
