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

protocol SearchViewComponents {
    func navigationBarView() -> UIView
    func listView(for sectionID: SearchSection.ID) -> UIView
}

final class SearchView: UIView {
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

    private var listContainerView: UIView!
    private var challengeListView: UIView!
    private var mediaListView: UIView!
    private var userListView: UIView!

    private let components: SearchViewComponents

    init(components: SearchViewComponents) {
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

        listContainerView = UIView()
        vertStackView.addArrangedSubview(listContainerView)

        challengeListView = components.listView(for: .challenge)
        listContainerView.addSubview(challengeListView)

        mediaListView = components.listView(for: .media)
        listContainerView.addSubview(mediaListView)

        userListView = components.listView(for: .user)
        listContainerView.addSubview(userListView)
    }

    private func dataDidChange(from oldData: Data?) {
        viewData = state?.data.viewData

        challengeListView.isHidden = state?.data.selectedSectionID != .challenge
        mediaListView.isHidden = state?.data.selectedSectionID != .media
        userListView.isHidden = state?.data.selectedSectionID != .user
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

    override func updateConstraints() {
        defer {
            currentLayout = state?.layout
            super.updateConstraints()
        }
        guard state?.layout != currentLayout else { return }

        vertStackView.snp.updateConstraints {
            $0.edges.equalTo(0).flexible()
        }

        challengeListView.snp.updateConstraints {
            $0.edges.equalTo(0)
        }

        mediaListView.snp.updateConstraints {
            $0.edges.equalTo(0)
        }

        userListView.snp.updateConstraints {
            $0.edges.equalTo(0)
        }
    }
}

extension SearchView {
    struct State: StateType {
        var data: Data
        var layout: Layout = .init()
        var appearance: Appearance = .init()
    }

    struct Data: StateType {
        var viewData: UIView.Data = .make()
        var selectedSectionID: SearchSection.ID
    }

    struct Layout: StateType {
        var viewLayout: UIView.Layout = .make()
    }

    struct Appearance: StateType {
        var viewAppearance: UIView.Appearance = .make()
    }

    struct Handlers {
    }
}
