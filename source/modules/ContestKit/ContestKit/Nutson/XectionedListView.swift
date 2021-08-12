//
//  XectionedListView.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 12.08.2021.
//

import Foundation
import UIKit

import SnapKit

import ToolKit

protocol XectionedListViewComponents {
    associatedtype Section: XectionType
    associatedtype Item: ItemType
    func reusableID(for itemID: Item.ID) -> String
    func cellClass(for itemID: Item.ID) -> AnyClass
    func setup(cell: UICollectionViewCell, for itemID: Item.ID?)
}

final class XectionedListView<
    SectionedListT: XectionedListType,
    ComponentsT: XectionedListViewComponents
>: UIView, UICollectionViewDelegate
where
    SectionedListT.Section == ComponentsT.Section,
    SectionedListT.Section.Item == ComponentsT.Item
{
    typealias Section = SectionedListT.Section
    typealias Item = SectionedListT.Section.Item

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

    private var collectionView: UICollectionView!
    private var collectionViewDataSource: UICollectionViewDiffableDataSource<Section.ID, Item.ID>!

    private let components: ComponentsT

    init(components: ComponentsT) {
        self.components = components
        super.init(frame: .zero)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setup() {
        let layout: UICollectionViewLayout = {
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
            let fullPhotoItem = NSCollectionLayoutItem(layoutSize: itemSize)
            fullPhotoItem.contentInsets = NSDirectionalEdgeInsets(
                top: 2,
                leading: 2,
                bottom: 2,
                trailing: 2
            )

            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(0.7)
            )
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitem: fullPhotoItem,
                count: 2
            )

            let section = NSCollectionLayoutSection(group: group)
            return UICollectionViewCompositionalLayout(section: section)
        }()

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).applying {
            $0.backgroundColor = nil
        }
        collectionView.delegate = self
        addSubview(collectionView)

        collectionViewDataSource = UICollectionViewDiffableDataSource(
            collectionView: collectionView
        ) { [self] collectionView, indexPath, itemID in
            collectionView.register(
                components.cellClass(for: itemID),
                forCellWithReuseIdentifier: components.reusableID(for: itemID)
            )

            return collectionView.dequeueReusableCell(
                withReuseIdentifier: components.reusableID(for: itemID),
                for: indexPath
            )
        }
    }

    private func dataDidChange(from oldData: Data?) {
        viewData = state?.data.viewData

        var snapshot = NSDiffableDataSourceSnapshot<Section.ID, Item.ID>()
        if let sectionedList = state?.data.sectionedList {
            snapshot.appendSections(sectionedList.sections.map(\.id))

            for section in sectionedList.sections {
                snapshot.appendItems(section.items.map(\.id), toSection: section.id)
            }
        }

        collectionViewDataSource.apply(snapshot)
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

        collectionView.snp.updateConstraints {
            $0.edges.equalTo(0)
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        components.setup(cell: cell, for: item(at: indexPath).id)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        didEndDisplaying cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        components.setup(cell: cell, for: nil)
    }
}

extension XectionedListView {
    struct State: StateType {
        var data: Data
        var layout: Layout = .init()
        var appearance: Appearance = .init()
    }

    struct Data: StateType {
        var viewData: UIView.Data = .make()
        var sectionedList: SectionedListT
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

extension XectionedListView {
    fileprivate func item(at indexPath: IndexPath) -> Item {
        section(at: indexPath.section).items[indexPath.item]
    }

    fileprivate func section(at index: Int) -> Section {
        state!.data.sectionedList.sections[index]
    }
}
