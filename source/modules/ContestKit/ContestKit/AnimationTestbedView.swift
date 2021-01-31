//
//  AnimationTestbedView.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 31.01.2021.
//

import Foundation
import UIKit

class AnimationTestbedView: UIView {
    private var boxView: UIView!

    init() {
        super.init(frame: .zero)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setup() {
        backgroundColor = .white

        boxView = UIView()
        addSubview(boxView)
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(didTapBox))
        boxView.addGestureRecognizer(tapGR)

        boxView.boxState = .inital
    }

    func run(with config: MessageAnimationConfigState) {
        switch config {
        case .smallText:
            runSmallText(with: config)
        default:
            break
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) { [self] in
            boxView.layer.removeAllAnimations()
            boxView.boxState = .inital
        }
    }

    func runSmallText(with config: MessageAnimationConfigState) {
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = config.duration
        animationGroup.animations = []
        for messageTiming in config.timings {
            switch messageTiming {
            case .positionY(let animationTiming):
                let animation = CABasicAnimation(keyPath: "position.y").applying {
                    $0.timingFunction = .init(animationTiming)
                    $0.fromValue = BoxState.inital.frame.center.y
                    $0.toValue = BoxState.final.frame.center.y
                    $0.beginTime = animationTiming.startsAt
                    $0.duration = animationTiming.endsAt - animationTiming.startsAt
                }
                animationGroup.animations?.append(animation)
            case .positionX(let animationTiming):
                let animation = CABasicAnimation(keyPath: "position.x").applying {
                    $0.timingFunction = .init(animationTiming)
                    $0.fromValue = BoxState.inital.frame.center.x
                    $0.toValue = BoxState.final.frame.center.x
                    $0.beginTime = animationTiming.startsAt
                    $0.duration = animationTiming.endsAt - animationTiming.startsAt
                }
                animationGroup.animations?.append(animation)
            case .timeAppears(_):
                break
            case .bubbleShape(_):
                break
            case .textPosition(_):
                break
            case .colorChange(_):
                break
            case .emojiScale(_):
                break
            }
        }

        boxView.layer.add(animationGroup, forKey: "group")

//        boxView.boxState = .final
    }

    @objc
    private func didTapBox() {
        let config = AppComponents.shared.store.state.selectedConfig
        run(with: config)
    }
}

extension CAMediaTimingFunction {
    convenience init(_ timing: AnimationTimingState) {
        self.init(
            controlPoints: timing.c1RelativeFraction,
            Float(timing.c1.y),
            Float(timing.c2RelativeFraction),
            Float(timing.c2.y)
        )
    }
}

extension UIView {
    var boxState: BoxState {
        get {
            .init(frame: frame, alpha: alpha, backgroundColor: backgroundColor)
        }
        set(newBoxState) {
            frame = newBoxState.frame
            alpha = newBoxState.alpha
            backgroundColor = newBoxState.backgroundColor
        }
    }
}

struct BoxState {
    var frame: CGRect
    var alpha: CGFloat
    var backgroundColor: UIColor?

    static let inital: Self = .init(
        frame: .init(x: 0, y: 0, width: 100, height: 100),
        alpha: 1,
        backgroundColor: .black
    )

    static let final: Self = .init(
        frame: .init(x: 200, y: 200, width: 100, height: 100),
        alpha: 1,
        backgroundColor: .black
    )
}
