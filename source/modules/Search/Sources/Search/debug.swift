//
//  File.swift
//  
//
//  Created by Dmitry Purtov on 18.08.2021.
//

import Foundation

let logLevels: [LogLevel] = []

enum LogLevel {
    case debug
    case info
}

func log(_ message: String, level: LogLevel = .info) {
    guard logLevels.contains(level) else { return }
    print(message)
}
