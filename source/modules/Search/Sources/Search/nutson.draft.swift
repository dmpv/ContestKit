//
//  nutson.draft.swift
//  ContestKit
//
//  Created by Dmitry Purtov on 11.08.2021.
//

import Foundation
import UIKit

import ToolKit
import ComponentKit

extension UIView.State {
    func image(with size: CGSize) -> UIImage {
        let view = UIView()
        view.viewState = self
        view.frame.size = size
//        view.frame.adjust { frame in
//            frame.origin = -imageFrame.origin
//            frame.size = layout.size
//        }
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        defer { UIGraphicsEndImageContext() }
        let context = UIGraphicsGetCurrentContext()!
        view.layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        return image
    }
}

extension Stub {
    static func image(withSize size: CGSize) -> UIImage {
        UIView.State.make(
            appearance: .make(
                backgroundColor: .black.withAlphaComponent(0.3),
                cornerRadius: 5,
                hasSmoothCorners: true
            )
        ).image(with: size)
    }

    static func url(forImageWithSize size: CGSize) -> URL {
        URL(string: "https://placekitten.com/\(Int(size.width))/\(Int(size.height))")!
    }

    static func avatarImageURL() -> URL {
        Self.url(
            forImageWithSize: .init(
                width: 200 + (-5...5).randomElement()!,
                height: 200 + (-5...5).randomElement()!
            )
        )
    }
}
