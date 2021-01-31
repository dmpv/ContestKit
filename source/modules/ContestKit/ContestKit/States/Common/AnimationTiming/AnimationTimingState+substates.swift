//
//  AnimationTimingState+substates.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 31.01.2021.
//

import Foundation

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
            let oldC1RelativeFraction = c1RelativeFraction
            let oldC2RelativeFraction = c2RelativeFraction
            startsAt = totalDuration * Double(newStartsAtFraction)
            if startsAt > endsAt - minDuration {
                endsAt = startsAt + minDuration
                if endsAt > totalDuration {
                    endsAt = totalDuration
                    startsAt = totalDuration - minDuration
                }
            }
            c1RelativeFraction = oldC1RelativeFraction
            c2RelativeFraction = oldC2RelativeFraction
        }
    }

    var endsAtFraction: Float {
        get {
            Float(endsAt / totalDuration)
        }
        set(newEndsAtFraction) {
            let oldC1RelativeFraction = c1RelativeFraction
            let oldC2RelativeFraction = c2RelativeFraction
            endsAt = totalDuration * Double(newEndsAtFraction)
            if endsAt < startsAt + minDuration {
                startsAt = endsAt - minDuration
                if startsAt < 0 {
                    startsAt = 0
                    endsAt = minDuration
                }
            }
            c1RelativeFraction = oldC1RelativeFraction
            c2RelativeFraction = oldC2RelativeFraction
        }
    }

    var c1RelativeFraction: Float {
        get {
            Float((c1.x - startsAt) / (endsAt - startsAt))
        }
        set(newC1RelativeFraction) {
            c1.x = startsAt + (endsAt - startsAt) * Double(newC1RelativeFraction)
        }
    }

    var c2RelativeFraction: Float {
        get {
            Float((c2.x - startsAt) / (endsAt - startsAt))
        }
        set(newC2RelativeFraction) {
            c2.x = startsAt + (endsAt - startsAt) * Double(newC2RelativeFraction)
        }
    }
}
