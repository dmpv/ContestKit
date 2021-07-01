//
//  SectionedListView.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 27.01.2021.
//

import Foundation
import UIKit

import ToolKit

public final class SectionedListView: UIView {
    var state: State? {
        didSet { stateDidChange(from: oldValue) }
    }

    var handlers = Handlers() {
        didSet { handlersDidChange() }
    }

    private var activated = false
    private var currentLayout: Layout?

    private var tableView: UITableView!

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
        tableView = module.tableView.applying(noAutoresize)
        addSubview(tableView)
    }

    private func stateDidChange(from oldState: State?) {
        guard state != oldState || !activated else { return }

        let sections = state?.sectionedList.sections ?? []
        let oldSections = oldState?.sectionedList.sections ?? []
        if sections.map(\.id) != oldSections.map(\.id) {
            tableView.reloadData()
        } else {
            var sectionsToReload: IndexSet = []
            for sectionIndex in sections.indices {
                let rows = sections[sectionIndex].rows
                let oldRows = oldSections[sectionIndex].rows
                if rows.map(\.id) != oldRows.map(\.id) {
                    sectionsToReload.insert(sectionIndex)
                }
            }
            if sectionsToReload.count > 0 {
                tableView.reloadSections(sectionsToReload, with: .automatic)
            }
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

    public override func updateConstraints() {
        defer {
            currentLayout = state?.layout
            super.updateConstraints()
        }
        guard state?.layout != currentLayout || !activated else { return }
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        tableView.frame = bounds
    }
}

extension SectionedListView {
    struct State: StateType {
        var sectionedList: SectionedListState = .init()
        var layout: Layout = .init()
        var appearance: Appearance = .init()
    }

    struct Layout: Equatable {
    }

    struct Appearance: Equatable {
    }

    struct Handlers {
    }
}
