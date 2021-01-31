//
//  MessageAnimationEditorView.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 27.01.2021.
//

import Foundation
import UIKit

public final class MessageAnimationEditorView: UIView {
    var state: State? {
        didSet { stateDidChange(from: oldValue) }
    }

    var handlers = Handlers() {
        didSet { handlersDidChange() }
    }

    private var activated = false
    private var currentLayout: Layout?

    private var sectionedListView: SectionedListView!

    private let module: SectionedListModule

    public init(module: SectionedListModule) {
        self.module = module
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
        sectionedListView = module.view.applying(noAutoresize)
        addSubview(sectionedListView)
    }

    private func stateDidChange(from oldState: State?) {
        guard state != oldState || !activated else { return }

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

    public override func updateConstraints() {
        defer {
            currentLayout = state?.layout
            super.updateConstraints()
        }
        guard state?.layout != currentLayout || !activated else { return }
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        sectionedListView.frame = bounds
    }
}

extension MessageAnimationEditorView {
    struct State: Equatable {
        var layout = Layout()
        var appearance = Appearance()
    }

    struct Layout: Equatable {
    }

    struct Appearance: Equatable {
    }

    struct Handlers {
    }
}
