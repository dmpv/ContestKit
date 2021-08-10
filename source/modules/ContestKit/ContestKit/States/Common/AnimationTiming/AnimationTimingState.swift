//
//  AnimationTimingState.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 27.01.2021.
//

import Foundation

import ToolKit

public struct AnimationTimingState: StateType, Codable {
    var startsAt: TimeInterval
    var c1: TimePoint
    var c2: TimePoint
    var endsAt: TimeInterval
    var minDuration: TimeInterval
    var totalDuration: TimeInterval

    public init(
        startsAt: TimeInterval,
        c1: TimePoint,
        c2: TimePoint,
        endsAt: TimeInterval,
        minDuration: TimeInterval,
        totalDuration: TimeInterval
    ) {
        self.startsAt = startsAt
        self.c1 = c1
        self.c2 = c2
        self.endsAt = endsAt
        self.minDuration = minDuration
        self.totalDuration = totalDuration
    }
}

public struct TimePoint: StateType, Codable {
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
