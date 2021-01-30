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
    var minDuration: TimeInterval = 0.2
    var totalDuration: TimeInterval = 0

    public init(
        startsAt: TimeInterval = 0,
        c1: TimePoint = .init(),
        c2: TimePoint = .init(),
        endsAt: TimeInterval = 0,
        totalDuration: TimeInterval = 0
    ) {
        self.startsAt = startsAt
        self.c1 = c1
        self.c2 = c2
        self.endsAt = endsAt
        self.totalDuration = totalDuration
    }
}

extension AnimationTimingState {
    static func makeDefault(totalDuration: TimeInterval = 1) -> Self {
        .init(
            startsAt: 0,
            c1: .init(x: totalDuration * 0.5),
            c2: .init(x: totalDuration * 0.5),
            endsAt: totalDuration,
            totalDuration: totalDuration
        )
    }
}

extension AnimationTimingState {
    var c1Fraction: Float {
        get {
            Float(c1.x / totalDuration)
        }
        set(newC1Fraction) {
            c1.x = totalDuration * Double(newC1Fraction)
            if c1.x < startsAt {
                startsAt = c1.x
            }
            if c1.x > endsAt {
                endsAt = c1.x
            }
        }
    }

    var c2Fraction: Float {
        get {
            Float(c2.x / totalDuration)
        }
        set(newC2Fraction) {
            c2.x = totalDuration * Double(newC2Fraction)
            if c2.x < startsAt {
                startsAt = c2.x
            }
            if c2.x > endsAt {
                endsAt = c2.x
            }
        }
    }

    var startsAtFraction: Float {
        get {
            Float(startsAt / totalDuration)
        }
        set(newStartsAtFraction) {
            startsAt = totalDuration * Double(newStartsAtFraction)
            if startsAt > endsAt - minDuration {
                endsAt = startsAt + minDuration
                if endsAt > totalDuration {
                    endsAt = totalDuration
                    startsAt = totalDuration - minDuration
                }
            }
            if startsAt > c1.x {
                c1.x = startsAt
            }
            if startsAt > c2.x {
                c2.x = startsAt
            }
        }
    }

    var endsAtFraction: Float {
        get {
            Float(endsAt / totalDuration)
        }
        set(newEndsAtFraction) {
            endsAt = totalDuration * Double(newEndsAtFraction)
            if endsAt < startsAt + minDuration {
                startsAt = endsAt - minDuration
                if startsAt < 0 {
                    startsAt = 0
                    endsAt = minDuration
                }
            }
            if endsAt < c2.x {
                c2.x = endsAt
            }
            if endsAt < c1.x {
                c1.x = endsAt
            }
        }
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
