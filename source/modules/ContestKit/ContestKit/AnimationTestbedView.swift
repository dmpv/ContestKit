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
        refresh()
    }

    func refresh() {
        boxView.layer.removeAllAnimations()
        boxView.frame.adjust {
            $0.origin = .init(x: 100, y: 50)
            $0.size = .init(width: 100, height: 100)
        }
        boxView.applying {
            $0.alpha = 1.0
            $0.backgroundColor = .black
        }
    }

    func run(with config: MessageAnimationConfigState) {
        switch config {
        case .smallText(let timings):
            runSmallText(with: timings)
        default:
            break
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) { [self] in
            refresh()
        }
    }

    func runSmallText(with messageTimings: [MessageAnimationTimingState]) {
        var animations: [CAAnimation] = []
        for messageTiming in messageTimings {
            switch messageTiming {
            case .positionX(let animationTiming):
                break
//                animations.append()
            default:
                break
            }
        }

        let fadeAnim = CABasicAnimation(keyPath: "opacity")
        fadeAnim.fromValue = NSNumber(floatLiteral: 1.0)
        fadeAnim.toValue = NSNumber(floatLiteral: 0.0)
        fadeAnim.duration = 1.0
        boxView.layer.add(fadeAnim, forKey: "opacity")
        boxView.layer.opacity = 0.0

        //        boxView.layer.add(, forKey: "frame.origin.x")

//        CABasicAnimation* fadeAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
//        fadeAnim.fromValue = [NSNumber numberWithFloat:1.0];
//        fadeAnim.toValue = [NSNumber numberWithFloat:0.0];
//        fadeAnim.duration = 1.0;
//        [theLayer addAnimation:fadeAnim forKey:@"opacity"];
    }

    @objc
    private func didTapBox() {
        let config = AppComponents.shared.store.state.selectedConfig
        run(with: config)
    }
}
