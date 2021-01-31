//
//  PasteboardService.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 31.01.2021.
//

import Foundation
import UIKit

class PasteboardService {
    func fetchMessageAnimationConfigs() -> [MessageAnimationConfigState]? {
        guard let utf8StringData = UIPasteboard.general.string?.data(using: .utf8) else {
            return nil
        }
        let decoder = JSONDecoder()
        return try? decoder.decode([MessageAnimationConfigState].self, from: utf8StringData)
    }

    func sendMessageAnimationConfigs(_ messageAnimationConfigs: [MessageAnimationConfigState]) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        guard let jsonData = try? encoder.encode(messageAnimationConfigs),
              let jsonString = String(data: jsonData, encoding: .utf8) else { return fallback() }
        UIPasteboard.general.string = jsonString
    }
}
