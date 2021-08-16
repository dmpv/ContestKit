//
//  NavigationBar.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 11.08.2021.
//

import Foundation
import UIKit

import SnapKit

import ToolKit

public protocol NavigationBarViewComponents {
    func searchFieldView() -> UIView
    func filterView() -> UIView
}

public final class NavigationBarView: UIView {
    var state: State? {
        didSet(oldState) {
            if state?.data != oldState?.data {
                dataDidChange(from: oldState?.data)
            }

            if state?.appearance != oldState?.appearance {
                appearanceDidChange(from: oldState?.appearance)
            }

            if state?.layout != oldState?.layout {
                layoutDidChange(from: oldState?.layout)
            }
        }
    }

    var handlers = Handlers() {
        didSet { handlersDidChange() }
    }

    private var currentLayout: Layout?

    private var vertStackView: UIStackView!
    private var searchFieldView: UIView!
    private var filterView: UIView!

    private let components: NavigationBarViewComponents

    public init(components: NavigationBarViewComponents) {
        self.components = components
        super.init(frame: .zero)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setup() {
        vertStackView = UIStackView().applying {
            $0.axis = .vertical
        }
        addSubview(vertStackView)

        searchFieldView = components.searchFieldView()
        vertStackView.addArrangedSubview(searchFieldView)

        filterView = components.filterView()
        vertStackView.addArrangedSubview(filterView)
    }

    private func dataDidChange(from oldData: Data?) {
        viewData = state?.data.viewData
    }

    private func layoutDidChange(from oldLayout: Layout?) {
        viewLayout = state?.layout.viewLayout
        setNeedsUpdateConstraints()
        setNeedsLayout()
    }

    private func appearanceDidChange(from oldAppearance: Appearance?) {
        viewAppearance = state?.appearance.viewAppearance
    }

    private func handlersDidChange() {
    }

    public override func updateConstraints() {
        defer {
            currentLayout = state?.layout
            super.updateConstraints()
        }
        guard state?.layout != currentLayout else { return }

        vertStackView.snp.updateConstraints {
            $0.edges.equalTo(layoutMarginsGuide)
        }

        searchFieldView.snp.updateConstraints {
            $0.height.equalTo(36)
        }
    }
}

extension NavigationBarView {
    public struct State: StateType {
        var data: Data = .init()
        var layout: Layout = .init()
        var appearance: Appearance = .init()
    }

    public struct Data: StateType {
        var viewData: UIView.Data = .make()
    }

    public struct Layout: StateType {
        var viewLayout: UIView.Layout = .make(layoutMargins: .zero)
    }

    public struct Appearance: StateType {
        var viewAppearance: UIView.Appearance = .make()
    }

    struct Handlers {
    }
}
