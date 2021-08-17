//
//  NutsonTestbed.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 11.08.2021.
//

import Foundation
import UIKit

import ToolKit
import ComponentKit

public class NutsonTestbed {
    public static func run() -> UIViewController {
        let store = Str<SearchState>(state: .init())

//        store.adjust { search in
//            search = .init(
//                status: .loaded(
//                    result: Stub.searchResult(for: "Group 0")
//                )
//            )
//        }

        let searchModule = SearchModule(store: store)

        let searchView = searchModule.searchView() as! SearchView

        return ViewController(view: searchView)
    }
}
