//
//  TopTabBarView.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 11.08.2021.
//

import Foundation
import UIKit

import SnapKit

import ToolKit
import ComponentKit

public protocol TopTabBarViewViewComponents {
}

public final class TopTabBarView: UIView {
    var state: State? {
        didSet(oldState) {
            if state?.data != oldState?.data {
                dataDidChange(from: oldState?.data)
            }

            if state?.appearance != oldState?.appearance {
                appearanceDidChange(from: oldState?.appearance)
            }

            if state?.layout != oldState?.layout {
                ToolKit.perform(with: .make(duration: .short)) { [self] in
                    layoutDidChange(from: oldState?.layout)
                    layoutIfNeeded()
                }
            }
        }
    }

    var handlers = Handlers() {
        didSet { handlersDidChange() }
    }

    private var currentLayout: Layout?

    private var horStackView: UIStackView!
    private var tabViews: [UIView] = []
    private var pointerView: UIView!

    private let components: TopTabBarViewViewComponents

    public init(components: TopTabBarViewViewComponents) {
        self.components = components
        super.init(frame: .zero)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setup() {
        horStackView = UIStackView().applying {
            $0.distribution = .fillEqually
        }
        addSubview(horStackView)

        pointerView = UIView().applying {
            $0.backgroundColor = .black
        }
        addSubview(pointerView)
    }

    private func dataDidChange(from oldData: Data?) {
        viewData = state?.data.viewData

        let tabs = state?.data.tabs ?? []
        let oldTabs = oldData?.tabs ?? []

        tabs.map(\.id).difference(from: oldTabs.map(\.id)).forEach { change in
            switch change {
            case .remove(let index, _, _):
                let view = tabViews[index]
                view.removeFromSuperview()
                tabViews.remove(at: index)
            case .insert(let index, _, _):
                let buttonView = ButtonView()
                horStackView.insertArrangedSubview(buttonView, at: index)
                tabViews.insert(buttonView, at: index)
            }
        }

        for (index, tabView) in tabViews.enumerated() {
            let buttonView = tabView as! ButtonView
            buttonView.state = .make(
                data: .make(
                    title: tabs[index].name,
                    image: tabs[index].iconImage
                ),
                appearance: .make(
                    buttonAppearance: .make(
                        tintColor: tabs[index].id == state?.data.selectedTabID
                            ? .fullBlack
                            : .grey_70
                    ),
                    titleColor: tabs[index].id == state?.data.selectedTabID
                        ? .fullBlack
                        : .grey_70,
                    titleFont: .regular(withSize: 12)
                )
            )
            buttonView.handlers.onPress = { [weak self] in
                self?.handlers.onSelect?(tabs[index].id)
            }
        }
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

        guard let layout = state?.layout else { return }

        horStackView.snp.updateConstraints {
            $0.edges.equalTo(layoutMarginsGuide).flexible()
        }

        pointerView.snp.remakeConstraints {
            $0.leading.bottom.trailing.equalTo(tabViews[layout.selectedTabIndex])
            $0.height.equalTo(1)
        }
    }
}

extension TopTabBarView {
    public struct State: StateType {
        var data: Data = .init()
        var layout: Layout
        var appearance: Appearance = .init()
    }

    public struct Data: StateType {
        var viewData: UIView.Data = .make()
        var selectedTabID: TabState.ID?
        var tabs: [TabState] = []
    }

    public struct Layout: StateType {
        var viewLayout: UIView.Layout = .make(layoutMargins: .zero)
        var selectedTabIndex: Int
    }

    public struct Appearance: StateType {
        var viewAppearance: UIView.Appearance = .make()
    }

    struct Handlers {
        var onSelect: ((TabState.ID) -> Void)?
    }
}

struct TabState: StateType, Identifiable {
    var id: String
    var name: String
    var iconImage: UIImage?
}
