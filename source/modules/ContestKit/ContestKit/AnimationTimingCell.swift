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
    private var topSliderOverlayView: UIView!
    private var topSliderFakeThumb: SliderThumbView!
    private var topTooltipLabel: UILabel!

    private var rightDottedView: AnimationTimingDottedView!
    private var rightCentralSlider: CKSlider!
    private var rightCentralTooltipLabel: UILabel!

    private var pathView: AnimationTimingPathView!

    private var leftCentralSlider: CKSlider!
    private var leftDottedView: AnimationTimingDottedView!
    private var leftCentralTooltipLabel: UILabel!

    private var bottomSlider: CKSlider!
    private var bottomSliderFakeThumb: SliderThumbView!
    private var bottomSliderOverlayView: UIView!
    private var bottomTooltipLabel: UILabel!

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
        contentView.layoutMargins = .init(top: 40, left: 40, bottom: 40, right: 40)

        let cpSliderStyle: Style<UISlider> = {
            let thumbImageSize = SliderThumbView.State().layout.size
            let transparentImage = UIView.State(layout: .init(frame: .init(origin: .zero, size: thumbImageSize))).image
            $0.setThumbImage(transparentImage, for: .normal)
        }

        let durationSliderStyle: Style<UISlider> = {
            $0.minimumTrackTintColor = .clear
            $0.maximumTrackTintColor = .clear
            let size = CGSize(width: 10, height: 20)
            let image = SliderThumbView.State(layout: .init(size: size)).image
            $0.setThumbImage(image, for: .normal)
        }

        pathView = AnimationTimingPathView()
        contentView.addSubview(pathView)

        topSlider = CKSlider().applying(cpSliderStyle).applying {
            $0.minimumTrackTintColor = UISlider.defaultMaxTrackTintColor
            $0.maximumTrackTintColor = UISlider.defaultMinTrackTintColor
        }
        contentView.addSubview(topSlider)
        topSlider.addTarget(self, action: #selector(didSlideTopSlider), for: .primaryActionTriggered)

        topSliderOverlayView = UIView().applying {
            $0.backgroundColor = UISlider.defaultMaxTrackTintColor
            $0.layer.cornerRadius = UISlider.defaultTrackCornerRadius
        }
        contentView.addSubview(topSliderOverlayView)

        bottomSlider = CKSlider().applying(cpSliderStyle)
        contentView.addSubview(bottomSlider)
        bottomSlider.addTarget(self, action: #selector(didSlideBottomSlider), for: .primaryActionTriggered)

        bottomSliderOverlayView = UIView().applying {
            $0.backgroundColor = UISlider.defaultMaxTrackTintColor
            $0.layer.cornerRadius = UISlider.defaultTrackCornerRadius
        }
        contentView.addSubview(bottomSliderOverlayView)

        rightDottedView = AnimationTimingDottedView().applying {
            $0.isUserInteractionEnabled = false
        }
        contentView.addSubview(rightDottedView)

        leftDottedView = AnimationTimingDottedView().applying {
            $0.isUserInteractionEnabled = false
        }
        contentView.addSubview(leftDottedView)

        topSliderFakeThumb = SliderThumbView().applying {
            $0.isUserInteractionEnabled = false
        }
        contentView.addSubview(topSliderFakeThumb)

        bottomSliderFakeThumb = SliderThumbView().applying {
            $0.isUserInteractionEnabled = false
        }
        contentView.addSubview(bottomSliderFakeThumb)

        rightCentralSlider = CKSlider().applying(durationSliderStyle)
        contentView.addSubview(rightCentralSlider)
        rightCentralSlider.addTarget(self, action: #selector(didSlideRightCentralSlider), for: .primaryActionTriggered)

        leftCentralSlider = CKSlider().applying(durationSliderStyle)
        contentView.addSubview(leftCentralSlider)
        leftCentralSlider.addTarget(self, action: #selector(didSlideLeftCentralSlider), for: .primaryActionTriggered)

        topTooltipLabel = UILabel().applying {
            $0.font = .systemFont(ofSize: 18, weight: .light)
            $0.textColor = .systemBlue
        }
        contentView.addSubview(topTooltipLabel)

        bottomTooltipLabel = UILabel().applying {
            $0.font = .systemFont(ofSize: 18, weight: .light)
            $0.textColor = .systemBlue
        }
        contentView.addSubview(bottomTooltipLabel)

        rightCentralTooltipLabel = UILabel().applying {
            $0.font = .systemFont(ofSize: 18, weight: .light)
            $0.textColor = .systemYellow
        }
        contentView.addSubview(rightCentralTooltipLabel)

        leftCentralTooltipLabel = UILabel().applying {
            $0.font = .systemFont(ofSize: 18, weight: .light)
            $0.textColor = .systemYellow
        }
        contentView.addSubview(leftCentralTooltipLabel)
    }

    private func stateDidChange(from oldState: State?) {
        guard state != oldState || !activated else { return }

        topSlider.fraction = state?.timing.c2Fraction ?? 0
        rightCentralSlider.fraction = state?.timing.endsAtFraction ?? 0
        leftCentralSlider.fraction = state?.timing.startsAtFraction ?? 0
        bottomSlider.fraction = state?.timing.c1Fraction ?? 0

        rightDottedView.state = .init(circleRadius: 5)
        leftDottedView.state = .init(circleRadius: 5)

        topSliderFakeThumb.state = .iOSSystemPreferences
        bottomSliderFakeThumb.state = .iOSSystemPreferences

        if let timing = state?.timing {
            let relativeC1Fraction = Float(timing.c1.x - timing.startsAt) / Float(timing.endsAt - timing.startsAt)
            let relativeC2Fraction = Float(timing.c2.x - timing.startsAt) / Float(timing.endsAt - timing.startsAt)
            pathView.state = .init(
                c1Fraction: relativeC1Fraction,
                c2Fraction: relativeC2Fraction
            )

            topTooltipLabel.text = (1 - relativeC2Fraction).percentageTooltip
            topTooltipLabel.sizeToFit()

            bottomTooltipLabel.text = relativeC1Fraction.percentageTooltip
            bottomTooltipLabel.sizeToFit()

            rightCentralTooltipLabel.text = timing.endsAt.frameCountFormatted
            rightCentralTooltipLabel.sizeToFit()

            leftCentralTooltipLabel.text = timing.startsAt.frameCountFormatted
            leftCentralTooltipLabel.sizeToFit()
        }

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
    private func didSlideRightCentralSlider() {
        handlers.onSlideRightCentralSlider?(rightCentralSlider.fraction)
    }

    @objc
    private func didSlideLeftCentralSlider() {
        handlers.onSlideLeftCentralSlider?(leftCentralSlider.fraction)
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

        let layout = state?.layout ?? .init(timingStartsAtFraction: 0, timingEndsAtFraction: 1, timingC1Fraction: 0.5, timingC2Fraction: 0.5)

//        let containerFrame = contentView.bounds

        topSlider.frame.adjust { frame in
            let frameHeight = frame.height
            frame = contentView.frame.inset(by: contentView.layoutMargins)
            frame.size.height = frameHeight
        }

        topSliderOverlayView.frame.adjust { frame in
            frame = topSlider.convert(topSlider.trackFrame, to: contentView)
            let insetLeft = frame.size.width * CGFloat(layout.timingEndsAtFraction)
            frame.size.width -= insetLeft
            frame.origin.x += insetLeft
        }

        rightCentralSlider.frame.adjust { frame in
            let frameHeight = frame.height
            frame = contentView.frame.inset(by: contentView.layoutMargins)
            frame.origin.y += (frame.height - frameHeight) * 0.5
            frame.size.height = frameHeight
        }

        leftCentralSlider.frame = rightCentralSlider.frame

        bottomSlider.frame.adjust { frame in
            let frameHeight = frame.height
            frame = contentView.frame.inset(by: contentView.layoutMargins)
            frame.origin.y += frame.height - frameHeight
            frame.size.height = frameHeight
        }

        bottomSliderOverlayView.frame.adjust { frame in
            frame = bottomSlider.convert(bottomSlider.trackFrame, to: contentView)
            frame.size.width *= CGFloat(layout.timingStartsAtFraction)
        }

        let topThumbFrame = topSlider.convert(topSlider.thumbFrame, to: contentView)
        let bottomThumbFrame = bottomSlider.convert(bottomSlider.thumbFrame, to: contentView)
        let leftCentralThumbFrame = leftCentralSlider.convert(leftCentralSlider.thumbFrame, to: contentView)
        let rightCentralThumbFrame = rightCentralSlider.convert(rightCentralSlider.thumbFrame, to: contentView)

        rightDottedView.frame.adjust { frame in
            frame.size.width = rightDottedView.intrinsicContentSize.width
            frame.center.x = rightCentralThumbFrame.center.x
            frame.origin.y = topThumbFrame.center.y - frame.size.width * 0.5
            frame.size.height = bottomThumbFrame.center.y - topThumbFrame.center.y + frame.size.width
        }

        leftDottedView.frame.adjust { frame in
            frame.size.width = leftDottedView.intrinsicContentSize.width
            frame.center.x = leftCentralThumbFrame.center.x
            frame.origin.y = topThumbFrame.center.y - frame.size.width * 0.5
            frame.size.height = bottomThumbFrame.center.y - topThumbFrame.center.y + frame.size.width
        }

        pathView.frame.adjust { frame in
            frame.origin.x = leftCentralThumbFrame.center.x
            frame.origin.y = topThumbFrame.center.y
            frame.size.width = rightCentralThumbFrame.center.x - leftCentralThumbFrame.center.x
            frame.size.height = bottomThumbFrame.center.y - topThumbFrame.center.y
        }

        topSliderFakeThumb.frame.adjust { frame in
            frame.center = topThumbFrame.center
            frame.size = topSliderFakeThumb.intrinsicContentSize
        }

        bottomSliderFakeThumb.frame.adjust { frame in
            frame.center = bottomThumbFrame.center
            frame.size = bottomSliderFakeThumb.intrinsicContentSize
        }

        topTooltipLabel.frame.adjust { frame in
            frame.origin.y = topThumbFrame.minY - layout.tooltipOffset - frame.size.height
            frame.center.x = topThumbFrame.center.x
        }

        bottomTooltipLabel.frame.adjust { frame in
            frame.origin.y = bottomThumbFrame.maxY + layout.tooltipOffset
            frame.center.x = bottomThumbFrame.center.x
        }

        rightCentralTooltipLabel.frame.adjust { frame in
            let rightSpace = contentView.frame.width - rightCentralThumbFrame.maxX
            if rightSpace < frame.width + layout.tooltipOffset {
                frame.origin.x = rightCentralThumbFrame.minX - frame.width - layout.tooltipOffset
            } else {
                frame.origin.x = rightCentralThumbFrame.maxX + layout.tooltipOffset
            }
            frame.center.y = rightCentralThumbFrame.center.y
        }

        leftCentralTooltipLabel.frame.adjust { frame in
            frame.origin.x = leftCentralThumbFrame.maxX + layout.tooltipOffset
            frame.center.y = leftCentralThumbFrame.center.y
        }
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        switch super.hitTest(point, with: event) {
        case leftCentralSlider:
            let leftCentralSliderPoint = convert(point, to: leftCentralSlider)
            if leftCentralSlider.thumbFrame.contains(leftCentralSliderPoint) {
                return leftCentralSlider
            } else {
                let rightCentralSliderPoint = convert(point, to: rightCentralSlider)
                if rightCentralSlider.thumbFrame.contains(rightCentralSliderPoint) {
                    return rightCentralSlider
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
                timingEndsAtFraction: timing.endsAtFraction,
                timingC1Fraction: timing.c1Fraction,
                timingC2Fraction: timing.c2Fraction
            )
        }
        var appearance: Appearance = .init()
    }

    struct Layout: Equatable {
        var timingStartsAtFraction: Float
        var timingEndsAtFraction: Float
        var timingC1Fraction: Float
        var timingC2Fraction: Float
        var tooltipOffset: CGFloat = 4
    }

    struct Appearance: Equatable {
    }

    struct Handlers {
        var onSlideTopSlider: ((_ fraction: Float) -> Void)?
        var onSlideRightCentralSlider: ((_ fraction: Float) -> Void)?
        var onSlideLeftCentralSlider: ((_ fraction: Float) -> Void)?
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

    static let defaultMinTrackTintColor: UIColor = .systemBlue

    static let defaultMaxTrackTintColor: UIColor = .init(red: 228 / 255, green: 228 / 255, blue: 230 / 255, alpha: 1)

    static let defaultTrackCornerRadius: CGFloat = 2
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

extension Float {
    fileprivate var percentageTooltip: String {
        let percent = Int(self * 100)
        return "\(percent)%"
    }
}
