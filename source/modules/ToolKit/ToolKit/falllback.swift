//
//  falllback.swift
//  ToolKit
//
//  Created by Dmitry Purtov on 19.04.2020.
//  Copyright © 2020 djpurtov. All rights reserved.
//

import Foundation

public func fallback(
    message: String = "fallback",
    function: String = #function,
    file: StaticString = #file,
    line: UInt = #line
) {
    assertionFailure(message + " " + String(function), file: file, line: line)
}

public func fallback<ValueT>(
    _ value: ValueT,
    message: String = "fallback",
    function: String = #function,
    file: StaticString = #file,
    line: UInt = #line
) -> ValueT {
    fallback(message: message, function: function, file: file, line: line)
    return value
}
