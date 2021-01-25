//
//  fatalError.swift
//  ToolKit
//
//  Created by Dmitry Purtov on 26.04.2020.
//  Copyright © 2020 djpurtov. All rights reserved.
//

import Foundation

public func fatalError(_ reason: TerminateReason, file: StaticString = #file, line: UInt = #line) -> Never {
    Swift.fatalError(reason.message, file: file, line: line)
}

public enum TerminateReason {
    case notImplementedYet
    case shouldNeverBeCalled(_ message: String? = nil)
    case shouldBeOverriden

    var message: String {
        switch self {
        case .notImplementedYet:
            return "Not implemented yet"
        case .shouldNeverBeCalled(let message):
            return "Should never be called" + {
                guard let message = message else { return "" }
                return ": " + message
            }()
        case .shouldBeOverriden:
            return "Should be overriden"
        }
    }
}
