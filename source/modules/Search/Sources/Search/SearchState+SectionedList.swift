//
//  File.swift
//  
//
//  Created by Dmitry Purtov on 18.08.2021.
//

import Foundation

import ComponentKit

//extension SearchState: SectionedListType {
//    typealias Section = SearchSection
//
//    var sections: [SearchSection] {
//        status.result?.sections ?? []
//    }
//}

extension SearchResult: SectionedListType {}

extension SearchSection: SectionType {}

extension SearchItem: ItemType {}
