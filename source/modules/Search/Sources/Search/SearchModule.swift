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
    private let searchService: SearchService

    init(store: Str<SearchState>, searchService: SearchService) {
        self.store = store
        self.searchService = searchService
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
                log("sectionedListView init", level: .debug)
                view?.state = search.searchResult(for: sectionID).sectionedListView(for: sectionID)
            }
        view.handlers.onDidScroll = { [self, weak store] staticScrollState in
//            log("onDidScroll(\(sectionID)): \(staticScrollState)")
            if staticScrollState.contentOffsetBottom < 1500 {
                log("loadNextPage")
                store?.dispatch(
                    loadNextPageIfNeeded(for: sectionID)
                )
            }
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
            store?.dispatch(
                query(text ?? "")
            )
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
    func query(_ query: String) -> (Str<SearchState>) -> Void {
        { [self] store in
            guard store.state.query != query else { return }
            store.adjust { search in
                search.query = query
                search.paginatedSections = [
                    .init(id: .challenge, status: .empty(loadingStatus: .loading)),
                    .init(id: .media, status: .empty(loadingStatus: .loading)),
                    .init(id: .user, status: .empty(loadingStatus: .loading)),
                ]
            }

            for sectionID in store.state.paginatedSections.map(\.id) {
                store.dispatch(
                    execute(request: store.state.searchRequest(for: sectionID)!)
                )
            }
        }
    }

    func loadNextPageIfNeeded(for sectionID: SearchSection.ID) -> (Str<SearchState>) -> Void {
        { [self] store in
            guard store.state.paginatedSections[sectionID].status.loadingStatus == .idle else { return }

            store.adjust { search in
                search.paginatedSections[sectionID].status.adjust { status in
                    switch status {
                    case .empty(.idle):
                        status = .empty(loadingStatus: .loading)
                    case .partial(let data, let nextPageID, .idle):
                        status = .partial(data: data, nextPageID: nextPageID, loadingStatus: .loading)
                    case .full:
                        break
                    default:
                        fatalError(.shouldNeverBeCalled())
                    }
                }
            }

            guard let searchRequest = store.state.searchRequest(for: sectionID) else { return }

            store.dispatch(
                execute(request: searchRequest)
            )
        }
    }

    func execute(request: SearchRequest) -> (Str<SearchState>) -> Void {
        { [self] store in
            searchService.fetchSearchResult(for: request) { result in
                switch result {
                case .success(let response):
                    guard request.query == store.state.query else {
                        log("Handle: IGNORE (query changed)")
                        return
                    }
                    log("Handle: USE")
                    store.adjust { search in
                        search.paginatedSections[request.sectionID].adjust { paginatedSection in
                            let newItems = (paginatedSection.status.data?.items ?? []) + (response.section?.items ?? [])
                            let newData: SearchSection? = newItems == []
                                ? nil
                                : .init(items: newItems)
                            paginatedSection.status = {
                                switch (newData, response.nextPageID) {
                                case (let newData?, let nextPageID?):
                                    return .partial(
                                        data: newData,
                                        nextPageID: nextPageID,
                                        loadingStatus: .idle
                                    )
                                case (let newData, nil):
                                    return .full(data: newData)
                                case (nil, _?):
                                    fatalError(.shouldNeverBeCalled())
                                }
                            }()
                        }
                    }
                case .failure:
                    break
                }
            }
        }
    }
}

extension SearchState {
    func searchRequest(for sectionID: SearchSection.ID) -> SearchRequest? {
        switch paginatedSections[sectionID].status {
        case .empty:
            return .init(query: query, sectionID: sectionID, pageID: nil)
        case .partial(_, let nextPageID, _):
            return .init(query: query, sectionID: sectionID, pageID: nextPageID)
        case .full:
            return nil
        }
    }
}
