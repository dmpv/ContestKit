//
//  XectionedListState.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 12.08.2021.
//

import Foundation

import ToolKit

protocol XectionedListType: StateType  {
    associatedtype Section: XectionType
    var sections: [Section] { get }
}

protocol XectionType: StateType, Identifiable {
    associatedtype Item: ItemType
    var items: [Item] { get set }
}

protocol ItemType: StateType, Identifiable {}


extension XectionedListType {
    var items: [Section.Item] {
        sections.flatMap(\.items)
    }
}
