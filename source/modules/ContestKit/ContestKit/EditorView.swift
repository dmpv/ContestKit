//
//  EditorView.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 27.01.2021.
//

import Foundation
import UIKit

public final class EditorView: UIView {
    var state: State? {
        didSet { stateDidChange(from: oldValue) }
    }

    var handlers = Handlers() {
        didSet { handlersDidChange() }
    }

    private var activated = false
    private var currentLayout: Layout?

    private var tableView: UITableView!

    public init() {
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
        tableView = UITableView(frame: .zero, style: .grouped)
        addSubview(tableView)
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

        [
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ].forEach { $0.isActive = true }
    }
}

extension EditorView {
    struct State: Equatable {
        var typePickerCell: PickerCell.State
        var durationPickerCell: PickerCell.State
        var shareButtonCell: ButtonCell.State
        var importButtonCell: ButtonCell.State
        var restoreDefaultsButtonCell: ButtonCell.State
        var timingCells: [AnimationTimingCell.State] = []
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

extension EditorView.State {
    var list: SectionedList {
        .init(
            sections: [
                .init(
                    rows: [
                        .init(id: "type"),
                        .init(id: "duration"),
                        .init(id: "share"),
                        .init(id: "import"),
                    ]
                ),
            ]
        )
    }
}

struct SectionedList {
    var sections: [ListSection] = []
}

struct ListSection {
    var name: String?
    var rows: [ListRow] = []
}

struct ListRow: CKIdentifiable {
    var id: String
}
