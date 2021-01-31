//
//  AnimationTimingPathView.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 29.01.2021.
//

import Foundation
import UIKit

final class AnimationTimingPathView: UIView {
    var state: State? {
        didSet { stateDidChange(from: oldValue) }
    }

    private var activated = false
    private var currentLayout: Layout?

    init() {
        super.init(frame: .zero)
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
        backgroundColor = .clear
    }

    private func stateDidChange(from oldState: State?) {
        guard state != oldState || !activated else { return }

        setNeedsDisplay()

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

    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        let lineWidth: CGFloat = 4
        path.move(to: .init(x: rect.minX, y: rect.maxY))
        path.addCurve(
            to: .init(x: rect.maxX, y: rect.minY),
            controlPoint1: .init(
                x: rect.maxX * CGFloat(state?.c1Fraction ?? 0),
                y: rect.maxY
            ),
            controlPoint2: .init(
                x: rect.maxX * CGFloat(state?.c2Fraction ?? 0),
                y: 0
            )
        )
        path.lineWidth = lineWidth

        UISlider.defaultMaxTrackTintColor.set()
        path.stroke()
    }
}

extension AnimationTimingPathView {
    struct State: Equatable {
        var c1Fraction: Float
        var c2Fraction: Float
        var layout: Layout = .init()
        var appearance: Appearance = .init()
    }

    struct Layout: Equatable {
    }

    struct Appearance: Equatable {
    }
}
