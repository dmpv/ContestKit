//
//  DottedLineView.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 29.01.2021.
//

import Foundation
import UIKit

class DottedLineView: UIView {
    init() {
        super.init(frame: .zero)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setup() {
        backgroundColor = .clear
    }

    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        let dotRadius = rect.width * 0.5
        let dotCount = 19
        let dotGap = (rect.height - dotRadius * 2) / CGFloat(dotCount)
        path.move(to: .init(x: dotRadius, y: dotRadius))
        path.addLine(to: .init(x: dotRadius, y: rect.height))
        path.setLineDash([0, dotGap], count: 2, phase: 0)
        path.lineWidth = dotRadius * 2
        path.lineCapStyle = .round
        UIColor.systemYellow.set()
        path.stroke()
    }
}
