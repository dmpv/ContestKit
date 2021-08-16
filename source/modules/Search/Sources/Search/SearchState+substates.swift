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
            layout: .init(selectedTabIndex: tabSelectionState.selectedIndex),
            appearance: .init(
                viewAppearance: .make(backgroundColor: .systemTeal)
            )
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
                    layoutMargins: .init(top: 0, left: 8, bottom: 0, right: 8)
                ),
                textInsets: .init(top: 0, left: 35, bottom: 0, right: 20)
            ),
            appearance: .make(
                textFieldViewAppearance: .make(
                    backgroundColor: .gray,
                    cornerRadius: 18
                )
            )
        )
    }

    var sectionedListView: SectionedListView<SearchState, SearchModule>.State {
        .init(
            data: .init(
                sectionedList: self,
                columnCount: {
                    switch selectedSectionID {
                    case .challenge:
                        return 1
                    case .media:
                        return 2
                    case .user:
                        return 1
                    }
                }()
            ),
            appearance: .init(
                viewAppearance: .make(backgroundColor: .systemBlue)
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
