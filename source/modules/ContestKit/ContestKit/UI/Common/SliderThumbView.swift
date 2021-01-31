//
//  SliderThumbView.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 30.01.2021.
//

import Foundation
import UIKit

final class SliderThumbView: UIView {
    var state: State? {
        didSet { stateDidChange(from: oldValue) }
    }

    private var activated = false
    private var currentLayout: Layout?

    private var mainShadowView: UIView!

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

        mainShadowView = UIView()
        addSubview(mainShadowView)
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

        applying {
            let minSide = min(state?.layout.size.width ?? 0, state?.layout.size.height ?? 0)
            $0.layer.cornerRadius = minSide * 0.5
            $0.layer.shadow = state?.appearance.ambientShadow ?? .init()
        }

        mainShadowView.applying {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = layer.cornerRadius
            $0.layer.shadow = state?.appearance.mainShadow ?? .init()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        mainShadowView.frame = bounds
    }

    override var intrinsicContentSize: CGSize {
        state?.layout.size ?? .zero
    }
}

extension SliderThumbView {
    struct State: StateType {
        var layout: Layout
        var appearance: Appearance
    }

    struct Layout: Equatable {
        var size: CGSize
    }

    struct Appearance: Equatable {
        let mainShadow: ShadowState
        let ambientShadow: ShadowState
    }
}

extension SliderThumbView.State {
    var imageFrame: CGRect {
        let inset = appearance.ambientShadow.radius + appearance.ambientShadow.offset.height
        return CGRect(origin: .zero, size: layout.size).inset(by: -.init(uniform: inset))
    }

    var image: UIImage {
        let view = SliderThumbView()
        view.state = self
        view.frame.adjust { frame in
            frame.origin = -imageFrame.origin
            frame.size = layout.size
        }
        UIGraphicsBeginImageContextWithOptions(imageFrame.size, false, 0)
        defer { UIGraphicsEndImageContext() }
        let context = UIGraphicsGetCurrentContext()!
        context.translateBy(x: view.frame.origin.x, y: view.frame.origin.y)
        view.layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        return image
    }

    static let iOSSystemPreferences: Self = .init(
        layout: .init(
            size: .init(width: 16, height: 16)
        ),
        appearance: system.appearance
    )

    static let telegram: Self = .init(
        layout: .init(
            size: .init(width: 18, height: 18)
        ),
        appearance: system.appearance
    )

    static let telegramVertical: Self = .init(
        layout: .init(
            size: .init(width: 12, height: 24)
        ),
        appearance: system.appearance
    )

    static let system: Self = .init(
        layout: .init(
            size: .init(width: 28, height: 28)
        ),
        appearance: .init(
            mainShadow: .systemSliderThumbMain,
            ambientShadow: .systemSliderThumbAmbient
        )
    )
}

extension UIView {
    var viewState: State? {
        get { fatalError(.notImplementedYet) }
        set(newState) {
            backgroundColor = newState?.backgroundColor
            alpha = newState?.alpha ?? 1
            frame = newState?.layout.frame ?? .zero
        }
    }
}

extension UIView {
    struct State {
        var backgroundColor: UIColor?
        var alpha: CGFloat = 1
        var layout: Layout = .init()
    }

    struct Layout {
        var frame: CGRect = .zero
    }
}

extension UIView.State {
    var image: UIImage {
        let view = UIView()
        view.viewState = self
        UIGraphicsBeginImageContextWithOptions(layout.frame.size, false, 0)
        defer { UIGraphicsEndImageContext() }
        let context = UIGraphicsGetCurrentContext()!
        view.layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        return image
    }
}

struct ShadowState: StateType {
    var radius: CGFloat = 0
    var color: UIColor = .black
    var opacity: CGFloat = 0
    var offset: CGSize = .zero
}

extension ShadowState {
    static let systemSliderThumbMain: Self = .init(
        radius: 2,
        opacity: 0.12,
        offset: .init(width: 0, height: 0.5)
    )

    static let systemSliderThumbAmbient: Self = .init(
        radius: 6.5,
        opacity: 0.12,
        offset: .init(width: 0, height: 6)
    )
}

extension CALayer {
    var shadow: ShadowState {
        get {
            fatalError(.notImplementedYet)
        }
        set(newShadow) {
            shadowRadius = newShadow.radius
            shadowColor = newShadow.color.cgColor
            shadowOpacity = Float(newShadow.opacity)
            shadowOffset = newShadow.offset
        }
    }
}
