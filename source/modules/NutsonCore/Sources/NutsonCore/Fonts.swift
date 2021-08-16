//
//  File.swift
//  
//
//  Created by Dmitry Purtov on 17.08.2021.
//

import Foundation
import UIKit

extension UIFont {
    public static func font(
        withName name: String,
        size: CGFloat,
        fileName: String,
        fileExtension: String
    ) -> UIFont? {
        .init(name: name, size: size) ?? {
            registerFont(withFileName: fileName, fileExtension: fileExtension)
            return .init(name: name, size: size)
        }()
    }

    // https://stackoverflow.com/a/65815224
    private static func registerFont(withFileName fileName: String, fileExtension: String) {
        guard let fontURL = Bundle.module.url(forResource: fileName, withExtension: fileExtension) else {
            let errorDescription = "No font named \(fileName).\(fileExtension) was found in the module bundle"
            print("ERROR \(#file) \(#function) \(errorDescription)")
            return
        }

        var error: Unmanaged<CFError>?
        CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, &error)
        if let error = error {
            print("ERROR \(#file) \(#function) \(error)")
        }
    }
}

extension UIFont {
//    public static func light(withSize size: CGFloat) -> UIFont {
//        font(
//            withName: "SFProText-Regular",
//            size: size,
//            fileName: "SF-Pro-Text-Regular",
//            fileExtension: ".otf"
//        )!
//    }

    public static func regular(withSize size: CGFloat) -> UIFont {
        font(
            withName: "SFProText-Regular",
            size: size,
            fileName: "SF-Pro-Text-Regular",
            fileExtension: ".otf"
        )!
    }

//    public static func semibold(withSize size: CGFloat) -> UIFont {
//        font(
//            withName: "SFProText-Regular",
//            size: size,
//            fileName: "SF-Pro-Text-Regular",
//            fileExtension: ".otf"
//        )!
//    }

    public static func bold(withSize size: CGFloat) -> UIFont {
        font(
            withName: "SFProText-Bold",
            size: size,
            fileName: "SF-Pro-Text-Bold",
            fileExtension: ".otf"
        )!
    }
}
