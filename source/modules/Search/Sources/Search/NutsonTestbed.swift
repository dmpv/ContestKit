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
        let store = Str(state: SearchState())

        let searchService = SearchService()

        let searchModule = SearchModule(store: store, searchService: searchService)

        let searchView = searchModule.searchView() as! SearchView

        return ViewController(view: searchView)
    }
}
