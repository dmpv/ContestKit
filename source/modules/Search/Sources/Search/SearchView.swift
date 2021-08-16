//
//  SearchView.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 11.08.2021.
//

import Foundation
import UIKit

import SnapKit

import ToolKit

public protocol SearchViewComponents {
    func navigationBarView() -> UIView
    func listView() -> UIView
}

public final class SearchView: UIView {
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
    private var navigationBarView: UIView!
    private var listView: UIView!

    private let components: SearchViewComponents

    public init(components: SearchViewComponents) {
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

        navigationBarView = components.navigationBarView()
        vertStackView.addArrangedSubview(navigationBarView)

        listView = components.listView()
        vertStackView.addArrangedSubview(listView)
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
            $0.edges.equalTo(0)
        }
    }
}

extension SearchView {
    public struct State: StateType {
        var data: Data = .init()
        var layout: Layout = .init()
        var appearance: Appearance = .init()
    }

    public struct Data: StateType {
        var viewData: UIView.Data = .make()
    }

    public struct Layout: StateType {
        var viewLayout: UIView.Layout = .make()
    }

    public struct Appearance: StateType {
        var viewAppearance: UIView.Appearance = .make()
    }

    struct Handlers {
    }
}
