//
//  Slider.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 31.01.2021.
//

import Foundation
import UIKit

extension UISlider {
    var fraction: Float {
        get {
            value / (maximumValue - minimumValue)
        }
        set {
            value = newValue * (maximumValue - minimumValue)
        }
    }

    var thumbFrame: CGRect {
        thumbRect(
            forBounds: bounds,
            trackRect: trackRect(forBounds: bounds),
            value: value
        )
    }

    var trackFrame: CGRect {
        trackRect(forBounds: bounds)
    }

    static let defaultMinTrackTintColor: UIColor = .systemBlue

    static let defaultMaxTrackTintColor: UIColor = .init(red: 228 / 255, green: 228 / 255, blue: 230 / 255, alpha: 1)

    static let defaultTrackCornerRadius: CGFloat = 2
}

class CKSlider: UISlider {
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        var trackFrame = super.trackRect(forBounds: bounds)
//        let thumbFrame = thumbRect(forBounds: bounds, trackRect: trackFrame, value: value)
//        trackFrame.origin.x = thumbFrame.width * 0.5
        trackFrame.origin.x = 8.5
        trackFrame.size.width = bounds.width - trackFrame.origin.x * 2
        return trackFrame
    }

    override func thumbRect(forBounds bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect {
        var thumbFrame = super.thumbRect(forBounds: bounds, trackRect: rect, value: value)
//        thumbFrame.origin.x = CGFloat(fraction) * (bounds.width - thumbFrame.width)
        let trackFrame = trackRect(forBounds: bounds)
        thumbFrame.origin.x = trackFrame.origin.x - thumbFrame.width * 0.5 + trackFrame.width * CGFloat(fraction)
        return thumbFrame
    }

    //    var sliderState: State =  {
    //        didSet { stateDidChange(from: oldValue) }
    //    }

    //    private func stateDidChange(from oldState: State) {
    //        guard sliderState != oldState else { return }
    //
    //        setValue(sliderState.value, animated: sliderState.shouldAnimate)
    //    }
}

//extension CKSlider {
//    struct State: StateType {
//        var shouldAnimate = true
//        var value: Float
//        var minValue: Float
//        var maxValue: Float
//    }
//}
//
//extension CKSlider.State {
//    var fraction: Float {
//        get {
//            value / (maximumValue - minimumValue)
//        }
//        set {
//            value = newValue * (maximumValue - minimumValue)
//        }
//    }
//}
