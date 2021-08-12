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
                leftIconImage: Stub.image(withSize: .init(width: 20, height: 20))
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

    var sectionedListView: XectionedListView<SearchState, SearchModule>.State {
        .init(
            data: .init(
                sectionedList: self
            ),
            appearance: .init(
                viewAppearance: .make(backgroundColor: .systemBlue)
            )
        )
    }

    func videoItemCollectionViewCell(for itemID: SearchItem.ID) -> VideoSearchItemCollectionViewCell.State? {
        guard let videoItem = items[itemID].video else { return nil }
        return .init(
            data: .init(item: videoItem)
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
    var video: VideoSearchItem? {
        guard case .video(let videoItem) = self else { return nil }
        return videoItem
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
