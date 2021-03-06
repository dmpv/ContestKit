//
//  SearchState+substates.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 13.08.2021.
//

import Foundation
import UIKit

import ToolKit
import ComponentKit

extension SearchState {
    var result: SearchResult {
        .init(
            query: query,
            sections: paginatedSections.compactMap(\.status.data)
        )
    }

    func searchResult(for sectionID: SearchSection.ID) -> SearchResult {
        if sectionID == selectedSectionID {
            return result.reduce { result in
                result.sections = [result.sections[safe: sectionID]].compactMap { $0 }
            }
        } else {
            return SearchResult()
        }
    }

    var tabSelectionState: SelectionState<SearchSection.ID> {
        .init(values: SearchSection.ID.allCases, selectedValue: selectedSectionID)
    }

    var navigationBarView: NavigationBarView.State {
        .init(
            appearance: .init(
                viewAppearance: .make(backgroundColor: .fullWhite)
            )
        )
    }

    var topTabBarView: TopTabBarView.State {
        .init(
            data: .init(
                selectedTabID: tabSelectionState.selectedValue.rawValue,
                tabs: tabSelectionState.values.map { sectionID in
                    TabState(
                        id: sectionID.rawValue,
                        name: {
                            switch sectionID {
                            case .challenge:
                                return L10n.stub("Challenges")
                            case .media:
                                return L10n.stub("Videos")
                            case .user:
                                return L10n.stub("Users")
                            }
                        }(),
                        iconImage: {
                            switch sectionID {
                            case .challenge:
                                return UIImage(named: "icon-basic-challenge", in: .module, with: nil)?
                                    .withRenderingMode(.alwaysTemplate)
                            case .media:
                                return UIImage(named: "icon-basic-media", in: .module, with: nil)?
                                    .withRenderingMode(.alwaysTemplate)
                            case .user:
                                return UIImage(named: "icon-basic-user", in: .module, with: nil)?
                                    .withRenderingMode(.alwaysTemplate)
                            }
                        }()
                    )
                }
            ),
            layout: .init(selectedTabIndex: tabSelectionState.selectedIndex)
        )
    }

    var searchFieldView: TextFieldView.State {
        .make(
            data: .make(
                text: query,
                placeholder: {
                    switch selectedSectionID {
                    case .challenge:
                        return L10n.stub("challenges")
                    case .media:
                        return L10n.stub("videos")
                    case .user:
                        return L10n.stub("users")
                    }
                }(),
                leftIconImage: UIImage(named: "icon-basic-search", in: .module, with: nil)
            ),
            layout: .make(
                viewLayout: .make(
                    layoutMargins: .init(top: 4, left: 16, bottom: 4, right: 16)
                ),
                textInsets: .init(top: 0, left: 35, bottom: 0, right: 20)
            ),
            appearance: .make(
                textFieldViewAppearance: .make(
                    backgroundColor: .grey_90.withAlphaComponent(0.52),
                    tintColor: .fullBlack,
                    cornerRadius: 18
                ),
                textColor: .fullBlack,
                textFont: .regular(withSize: 16),
                placeholderColor: .grey_70
            )
        )
    }

    func challengeItemCollectionViewCell(for itemID: SearchItem.ID) -> ChallengeSearchItemCollectionViewCell.State? {
        guard let challengeItem = result.items[itemID].challenge else { return fallback(nil) }
        return .init(
            data: .init(item: challengeItem)
        )
    }

    func mediaItemCollectionViewCell(for itemID: SearchItem.ID) -> MediaSearchItemCollectionViewCell.State? {
        guard let mediaItem = result.items[itemID].media else { return fallback(nil) }
        return .init(
            data: .init(item: mediaItem)
        )
    }

    func userItemCollectionViewCell(for itemID: SearchItem.ID) -> UserSearchItemCollectionViewCell.State? {
        guard let userItem = result.items[itemID].user else { return fallback(nil) }
        return .init(
            data: .init(item: userItem)
        )
    }
}

extension SearchResult {
    func sectionedListView(for sectionID: SearchSection.ID) -> SectionedListView<Self, SearchModule>.State {
        .init(
            data: .init(
                sectionedList: self,
                mode: sectionID.sectionedListViewMode
            ),
            appearance: .init(
                viewAppearance: .make(backgroundColor: .fullWhite)
            )
        )
    }
}

extension SearchItem {
    var media: MediaSearchItem? {
        guard case .media(let mediaItem) = self else { return nil }
        return mediaItem
    }

    var challenge: ChallengeSearchItem? {
        guard case .challenge(let challengeItem) = self else { return nil }
        return challengeItem
    }

    var user: UserSearchItem? {
        guard case .user(let userItem) = self else { return nil }
        return userItem
    }
}

extension SearchSection.ID {
    var sectionedListViewMode: SectionedListView<SearchResult, SearchModule>.Mode {
        switch self {
        case .challenge:
            return .challenge
        case .media:
            return .media
        case .user:
            return .user
        }
    }
}

extension SearchPaginationStatus {
    var data: SearchSection? {
        switch self {
        case .empty:
            return nil
        case .partial(let data, _, _):
            return data
        case .full(let data):
            return data
        }
    }

    var loadingStatus: LoadingStatus {
        switch self {
        case .empty(let loadingStatus), .partial(_, _, let loadingStatus):
            return loadingStatus
        case .full:
            return .idle
        }
    }
}
