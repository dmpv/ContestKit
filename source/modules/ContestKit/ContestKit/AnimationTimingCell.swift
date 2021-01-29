//
//  AnimationTimingCell.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 27.01.2021.
//

import Foundation
import UIKit

final class AnimationTimingCell: UITableViewCell, RowCell {
    var state: State? {
        didSet { stateDidChange(from: oldValue) }
    }

    var handlers = Handlers() {
        didSet { handlersDidChange() }
    }

    var module: RowModule?

    private var activated = false
    private var currentLayout: Layout?

    private var topSlider: CKSlider!
    private var topSliderThumb: UIView!
    private var topSliderOverlayView: UIView!

    private var topCentralSlider: CKSlider!
    private var bottomCentralSlider: CKSlider!

    private var bottomSlider: CKSlider!
    private var bottomSliderThumb: UIView!
    private var bottomSliderOverlayView: UIView!

    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        activate()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    private func activate() {
        guard !activated else { return fallback() }
        stateDidChange(from: state)
        updateConstraints()
        activated = true
    }

    private func setup() {
        selectionStyle = .none

        topSlider = CKSlider().applying {
            $0.minimumTrackTintColor = .lightGray
            $0.maximumTrackTintColor = .systemBlue
        }
        contentView.addSubview(topSlider)
        topSlider.addTarget(self, action: #selector(didSlideTopSlider), for: .primaryActionTriggered)

        topSliderOverlayView = UIView().applying {
            $0.backgroundColor = .lightGray
            $0.layer.cornerRadius = 2
        }
        contentView.addSubview(topSliderOverlayView)

        topCentralSlider = CKSlider().applying {
            $0.minimumTrackTintColor = .clear
            $0.maximumTrackTintColor = .clear
        }
        contentView.addSubview(topCentralSlider)
        topCentralSlider.addTarget(self, action: #selector(didSlideTopCentralSlider), for: .primaryActionTriggered)

        bottomCentralSlider = CKSlider().applying {
            $0.minimumTrackTintColor = .clear
            $0.maximumTrackTintColor = .clear
        }
        contentView.addSubview(bottomCentralSlider)
        bottomCentralSlider.addTarget(self, action: #selector(didSlideBottomCentralSlider), for: .primaryActionTriggered)

        bottomSlider = CKSlider().applying {
            $0.minimumTrackTintColor = .systemBlue
//            $0.maximumTrackTintColor = .systemGray
        }
        contentView.addSubview(bottomSlider)
        bottomSlider.addTarget(self, action: #selector(didSlideBottomSlider), for: .primaryActionTriggered)

        bottomSliderOverlayView = UIView().applying {
            $0.backgroundColor = .lightGray
            $0.layer.cornerRadius = 2
        }
        contentView.addSubview(bottomSliderOverlayView)
    }

    private func stateDidChange(from oldState: State?) {
        guard state != oldState || !activated else { return }

        topSlider.fraction = state?.timing.c2Fraction ?? 0
        topCentralSlider.fraction = state?.timing.endsAtFraction ?? 0
        bottomCentralSlider.fraction = state?.timing.startsAtFraction ?? 0
        bottomSlider.fraction = state?.timing.c1Fraction ?? 0

        layoutDidChange(from: oldState?.layout)
        appearanceDidChange(from: oldState?.appearance)
    }

    private func layoutDidChange(from oldLayout: Layout?) {
        guard state?.layout != oldLayout || !activated else { return }
        setNeedsUpdateConstraints()
        setNeedsLayout()
    }

    private func appearanceDidChange(from oldAppearance: Appearance?) {
        guard state?.appearance != oldAppearance || !activated else { return }
    }

    private func handlersDidChange() {
    }

    @objc
    private func didSlideTopSlider() {
        handlers.onSlideTopSlider?(topSlider.fraction)
    }

    @objc
    private func didSlideTopCentralSlider() {
        handlers.onSlideTopCentralSlider?(topCentralSlider.fraction)
    }

    @objc
    private func didSlideBottomCentralSlider() {
        handlers.onSlideBottomCentralSlider?(bottomCentralSlider.fraction)
    }

    @objc
    private func didSlideBottomSlider() {
        handlers.onSlideBottomSlider?(bottomSlider.fraction)
    }

    override func updateConstraints() {
        defer {
            currentLayout = state?.layout
            super.updateConstraints()
        }
        guard state?.layout != currentLayout || !activated else { return }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        topSlider.frame.adjust { frame in
            let frameHeight = frame.height
            frame = contentView.frame.inset(by: contentView.layoutMargins)
            frame.size.height = frameHeight
        }

        topSliderOverlayView.frame.adjust { frame in
            frame = topSlider.convert(topSlider.trackFrame, to: contentView)
            let insetLeft = frame.size.width * CGFloat(state?.layout.timingEndsAtFraction ?? 0)
            frame.size.width -= insetLeft
            frame.origin.x += insetLeft
        }

        topCentralSlider.frame.adjust { frame in
            let frameHeight = frame.height
            frame = contentView.frame.inset(by: contentView.layoutMargins)
            frame.origin.y += (frame.height - frameHeight) * 0.5
            frame.size.height = frameHeight
        }

        bottomCentralSlider.frame = topCentralSlider.frame

        bottomSlider.frame.adjust { frame in
            let frameHeight = frame.height
            frame = contentView.frame.inset(by: contentView.layoutMargins)
            frame.origin.y += frame.height - frameHeight
            frame.size.height = frameHeight
        }

        bottomSliderOverlayView.frame.adjust { frame in
            frame = bottomSlider.convert(bottomSlider.trackFrame, to: contentView)
            frame.size.width *= CGFloat(state?.layout.timingStartsAtFraction ?? 0)
        }
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        switch super.hitTest(point, with: event) {
        case bottomCentralSlider:
            let bottomCentralSliderPoint = convert(point, to: bottomCentralSlider)
            if bottomCentralSlider.thumbFrame.contains(bottomCentralSliderPoint) {
                return bottomCentralSlider
            } else {
                let topCentralSliderPoint = convert(point, to: topCentralSlider)
                if topCentralSlider.thumbFrame.contains(topCentralSliderPoint) {
                    return topCentralSlider
                } else {
                    return nil
                }
            }
        case let view:
            return view
        }
    }
}

extension AnimationTimingCell {
    struct State: Equatable {
        var timing: AnimationTimingState
        var layout: Layout {
            .init(
                timingStartsAtFraction: timing.startsAtFraction,
                timingEndsAtFraction: timing.endsAtFraction
            )
        }
        var appearance: Appearance = .init()
    }

    struct Layout: Equatable {
        var timingStartsAtFraction: Float
        var timingEndsAtFraction: Float
    }

    struct Appearance: Equatable {
    }

    struct Handlers {
        var onSlideTopSlider: ((_ fraction: Float) -> Void)?
        var onSlideTopCentralSlider: ((_ fraction: Float) -> Void)?
        var onSlideBottomCentralSlider: ((_ fraction: Float) -> Void)?
        var onSlideBottomSlider: ((_ fraction: Float) -> Void)?
    }
}

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
}

class CKSlider: UISlider {
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        var trackFrame = super.trackRect(forBounds: bounds)
        let thumbFrame = thumbRect(forBounds: bounds, trackRect: trackFrame, value: value)
        trackFrame.origin.x = thumbFrame.width * 0.5
        trackFrame.size.width = bounds.width - thumbFrame.width
        return trackFrame
    }

    override func thumbRect(forBounds bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect {
        var thumbFrame = super.thumbRect(forBounds: bounds, trackRect: rect, value: value)
        thumbFrame.origin.x = CGFloat(fraction) * (bounds.width - thumbFrame.width)
        return thumbFrame
    }
}
