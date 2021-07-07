//
//  AnimationTimingDottedView.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 29.01.2021.
//

import Foundation
import UIKit

import ToolKit

final class AnimationTimingDottedView: UIView {
    var state: State? {
        didSet { stateDidChange(from: oldValue) }
    }

    private var activated = false
    private var currentLayout: Layout?

    private var topCircleView: UIView!
    private var dottedLineView: DottedLineView!
    private var bottomCircleView: UIView!

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
        let circleViewSetuper: Setuper<UIView> = {
            $0.backgroundColor = .systemYellow
            $0.layer.borderWidth = 2
            $0.layer.borderColor = UIColor.white.cgColor
        }

        topCircleView = UIView().applying(circleViewSetuper)
        addSubview(topCircleView)

        dottedLineView = DottedLineView()
        insertSubview(dottedLineView, at: 0)

        bottomCircleView = UIView().applying(circleViewSetuper)
        addSubview(bottomCircleView)
    }

    private func stateDidChange(from oldState: State?) {
        guard state != oldState || !activated else { return }

        layoutDidChange(from: oldState?.layout)
        appearanceDidChange(from: oldState?.appearance)
    }

    private func layoutDidChange(from oldLayout: Layout?) {
        guard state?.layout != oldLayout || !activated else { return }
        invalidateIntrinsicContentSize()
        setNeedsUpdateConstraints()
        setNeedsLayout()
    }

    private func appearanceDidChange(from oldAppearance: Appearance?) {
        guard state?.appearance != oldAppearance || !activated else { return }

        topCircleView.applying {
            $0.layer.cornerRadius = state?.appearance.circleRadius ?? 0
        }

        bottomCircleView.applying {
            $0.layer.cornerRadius = state?.appearance.circleRadius ?? 0
        }
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

        topCircleView.frame.adjust { frame in
            frame.size.width = (state?.layout.circleRadius ?? 0) * 2
            frame.size.height = frame.width
        }

        dottedLineView.frame.adjust { frame in
            let dotRadius: CGFloat = 1
            frame.size.width = dotRadius * 2
            frame.size.height = bounds.height - dotRadius
            frame.center = bounds.center
        }

        bottomCircleView.frame.adjust { frame in
            frame.size.width = (state?.layout.circleRadius ?? 0) * 2
            frame.size.height = frame.width
            frame.origin.y = bounds.height - frame.size.height
        }
    }

    override var intrinsicContentSize: CGSize {
        .init(
            width: (state?.circleRadius ?? 0) * 2,
            height: UIView.noIntrinsicMetric
        )
    }
}

extension AnimationTimingDottedView {
    struct State: Equatable {
        var circleRadius: CGFloat
        var layout: Layout {
            .init(circleRadius: circleRadius)
        }
        var appearance: Appearance {
            .init(circleRadius: circleRadius)
        }
    }

    struct Layout: Equatable {
        var circleRadius: CGFloat
    }

    struct Appearance: Equatable {
        var circleRadius: CGFloat
    }
}
