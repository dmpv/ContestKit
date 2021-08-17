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
    var tabSelectionState: SelectionState<SearchSectionID> {
        .init(values: SearchSectionID.allCases, selectedValue: selectedSectionID)
    }

    var topTabBarView: TopTabBarView.State {
        .init(
            data: .init(
                selectedTabID: tabSelectionState.selectedValue.rawValue,
                tabs: tabSelectionState.values.map { sectionID in
                    TabState(id: sectionID.rawValue, name: "\(sectionID)")
                }
            ),
            layout: .init(selectedTabIndex: tabSelectionState.selectedIndex)
        )
    }

    var searchFieldView: TextFieldView.State {
        .make(
            data: .make(
                text: status.query,
                placeholder: selectedSectionID.rawValue,
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
                    backgroundColor: .grey_90,
                    cornerRadius: 18
                ),
                textColor: .fullBlack,
                textFont: .regular(withSize: 16),
                placeholderColor: .grey_70
            )
        )
    }

    var sectionedListView: SectionedListView<SearchState, SearchModule>.State {
        .init(
            data: .init(
                sectionedList: self,
                mode: {
                    switch selectedSectionID {
                    case .challenge:
                        return .challenge
                    case .media:
                        return .media
                    case .user:
                        return .user
                    }
                }()
            ),
            appearance: .init(
                viewAppearance: .make(backgroundColor: .fullWhite)
            )
        )
    }

    func challengeItemCollectionViewCell(for itemID: SearchItem.ID) -> ChallengeSearchItemCollectionViewCell.State? {
        guard let challengeItem = items[itemID].challenge else { return fallback(nil) }
        return .init(
            data: .init(item: challengeItem)
        )
    }

    func mediaItemCollectionViewCell(for itemID: SearchItem.ID) -> MediaSearchItemCollectionViewCell.State? {
        guard let mediaItem = items[itemID].media else { return fallback(nil) }
        return .init(
            data: .init(item: mediaItem)
        )
    }

    func userItemCollectionViewCell(for itemID: SearchItem.ID) -> UserSearchItemCollectionViewCell.State? {
        guard let userItem = items[itemID].user else { return fallback(nil) }
        return .init(
            data: .init(item: userItem)
        )
    }
}

extension SearchStatus {
    var result: SearchResult? {
        get {
            switch self {
            case .loaded(let result):
                return result
            case .loading:
                return nil
            }
        }
        set {
            fatalError(.notImplementedYet)
        }
    }

    var query: String {
        switch self {
        case .loaded(let result):
            return result.query
        case .loading(let query):
            return query
        }
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
