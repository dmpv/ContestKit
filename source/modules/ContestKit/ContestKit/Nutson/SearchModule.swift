//
//  SearchModule.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 11.08.2021.
//

import Foundation
import UIKit

import ToolKit
import ComponentKit

class SearchModule {
    private let store: Str<SearchState>

    init(store: Str<SearchState>) {
        self.store = store
    }

    func searchView() -> UIView {
        SearchView(components: self).applying {
            $0.backgroundColor = .systemGreen
        }
    }
}

extension SearchModule: SearchViewComponents {
    func navigationBarView() -> UIView {
        let navigationBarView = NavigationBarView(components: self)
        navigationBarView.state = .init()
        navigationBarView.state?.appearance.viewAppearance.backgroundColor = .systemRed
        return navigationBarView
    }

    func listView() -> UIView {
        let view = XectionedListView<SearchState, SearchModule>(components: self)
        _ = store.stateObservable
            .addObserver { [weak view] search in
                view?.state = search.sectionedListView
            }
        return view
    }
}

extension SearchModule: NavigationBarViewComponents {
    func searchFieldView() -> UIView {
        let view = TextFieldView()
        _ = store.stateObservable
            .addObserver { [weak view] search in
                view?.state = search.searchFieldView
            }
        view.handlers.onChangeText = { [self, weak store] text in
            store?.dispatch(self.query(text ?? ""))
        }
        return view
    }

    func filterView() -> UIView {
        let view = TopTabBarView(components: self)
        _ = store.stateObservable
            .addObserver { [weak view] search in
                view?.state = search.topTabBarView
            }
        view.handlers.onSelect = { [weak store] tabID in
            store?.adjust { search in
                search.selectedSectionID = SearchSectionID(rawValue: tabID)!
            }
        }
        return view
    }
}

extension SearchModule: TopTabBarViewViewComponents {}

extension SearchModule: XectionedListViewComponents {
    typealias Section = SearchSection
    typealias Item = SearchItem

    func reusableID(for itemID: SearchItem.ID) -> String {
        "\(VideoSearchItemCollectionViewCell.self)"
    }

    func cellClass(for itemID: SearchItem.ID) -> AnyClass {
        VideoSearchItemCollectionViewCell.self
    }

    func setup(cell: UICollectionViewCell, for itemID: SearchItem.ID?) {
        if let itemID = itemID {
            switch (cell, itemID) {
            case (let cell as VideoSearchItemCollectionViewCell, _):
                cell.state = store.state.videoItemCollectionViewCell(for: itemID)!
                cell.components = self
            default:
                fatalError(.shouldNeverBeCalled())
            }
        } else {
            switch (cell, itemID) {
            case (let cell as VideoSearchItemCollectionViewCell, _):
                cell.state = nil
                cell.components = nil
            default:
                fatalError(.shouldNeverBeCalled())
            }
        }
    }
}

extension SearchModule: VideoSearchItemCollectionViewCellComponents {}

extension SearchModule {
    func query(_ str: String) -> (Str<SearchState>) -> Void {
        { store in
            store.adjust { search in
                search.status = .loading(query: str)
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                store.adjust { search in
                    search.status = .loaded(result: Stub.searchResult(for: str))
                }
            }
        }
    }
}
