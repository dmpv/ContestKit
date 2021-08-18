//
//  SearchModule.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 11.08.2021.
//

import Foundation
import UIKit

import Nuke

import ToolKit
import ComponentKit

class SearchModule {
    private let store: Str<SearchState>

    init(store: Str<SearchState>) {
        self.store = store
    }

    func searchView() -> UIView {
        let view = SearchView(components: self)
        _ = store.stateObservable
            .addObserver { [weak view] search in
                view?.state = .init(
                    data: .init(selectedSectionID: search.selectedSectionID)
                )
            }
        return view
    }
}

extension SearchModule: SearchViewComponents {
    func navigationBarView() -> UIView {
        let view = NavigationBarView(components: self)
        view.state = store.state.navigationBarView
        return view
    }

    func listView(for sectionID: SearchSection.ID) -> UIView {
        let view = SectionedListView<SearchResult, SearchModule>(components: self)
        _ = store.stateObservable
            .addObserver { [weak view] search in
                view?.state = search.searchResult(for: sectionID)?.sectionedListView(for: sectionID)
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
                search.selectedSectionID = SearchSection.ID(rawValue: tabID)!
            }
        }
        return view
    }
}

extension SearchModule: TopTabBarViewViewComponents {}

extension SearchModule: SectionedListViewComponents {
    typealias Section = SearchSection
    typealias Item = SearchItem

    func reusableID(for itemID: SearchItem.ID) -> String {
        switch itemID.sectionID {
        case .challenge:
            return "\(ChallengeSearchItemCollectionViewCell.self)"
        case .media:
            return "\(MediaSearchItemCollectionViewCell.self)"
        case .user:
            return "\(UserSearchItemCollectionViewCell.self)"
        }
    }

    func cellClass(for itemID: SearchItem.ID) -> AnyClass {
        switch itemID.sectionID {
        case .challenge:
            return ChallengeSearchItemCollectionViewCell.self
        case .media:
            return MediaSearchItemCollectionViewCell.self
        case .user:
            return UserSearchItemCollectionViewCell.self
        }
    }

    func setup(cell: UICollectionViewCell, for itemID: SearchItem.ID?) {
        if let itemID = itemID {
            switch (cell, itemID) {
            case (let cell as ChallengeSearchItemCollectionViewCell, _):
                cell.components = self
                cell.state = store.state.challengeItemCollectionViewCell(for: itemID)!
            case (let cell as MediaSearchItemCollectionViewCell, _):
                cell.components = self
                cell.state = store.state.mediaItemCollectionViewCell(for: itemID)!
            case (let cell as UserSearchItemCollectionViewCell, _):
                cell.components = self
                cell.state = store.state.userItemCollectionViewCell(for: itemID)!
            default:
                fatalError(.shouldNeverBeCalled())
            }
        } else {
            switch (cell, itemID) {
            case (let cell as ChallengeSearchItemCollectionViewCell, _):
                cell.state = nil
                cell.components = nil
            case (let cell as MediaSearchItemCollectionViewCell, _):
                cell.state = nil
                cell.components = nil
            case (let cell as UserSearchItemCollectionViewCell, _):
                cell.state = nil
                cell.components = nil
            default:
                fatalError(.shouldNeverBeCalled())
            }
        }
    }
}

extension SearchModule: ChallengeSearchItemCollectionViewCellComponents {}

extension SearchModule: MediaSearchItemCollectionViewCellComponents {
    func imagePipeline() -> ImagePipeline {
        ImagePipeline { config in
            config = .withDataCache
            config.dataCachePolicy = .automatic
        }
    }
}

extension SearchModule: UserSearchItemCollectionViewCellComponents {}

extension SearchModule {
    func query(_ str: String) -> (Str<SearchState>) -> Void {
        { store in
            store.adjust { search in
                search.status = .loading(query: str)
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                store.adjust { search in
//                    search.status = .loaded(result: Stub.searchResult(for: str))
                }
            }
        }
    }
}
