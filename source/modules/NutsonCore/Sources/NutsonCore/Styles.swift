//
//  File.swift
//  
//
//  Created by Dmitry Purtov on 16.08.2021.
//

import Foundation
import UIKit

extension UIFont {
    public static func light(withSize size: CGFloat) -> UIFont {
        .init(name: "SFProDisplay-Light", size: size)!
    }

    public static func regular(withSize size: CGFloat) -> UIFont {
        .init(name: "SFProText-Regular", size: size)!
    }

    public static func semibold(withSize size: CGFloat) -> UIFont {
        .init(name: "SFProDisplay-Semibold", size: size)!
    }

    public static func bold(withSize size: CGFloat) -> UIFont {
        .init(name: "SFProText-Bold", size: size)!
    }
}

extension UIColor {
//    static let red_50 = UIColor(hex: "#FF0000")!
//
//    static let orange_40 = UIColor(hex: "#CC6700")!
//
//    static let turquoise_60 = UIColor(hex: "#3DF5EE")!
//
//    static let green_50 = UIColor(hex: "#8CFF00")!
//    static let green_60 = UIColor(hex: "#A3FF33")!
//    static let green_90 = UIColor(hex: "#E8FFCC")!
//
//    static let yellow_60 = UIColor(hex: "#FFFF33")!
//    static let yellow_50 = UIColor(hex: "#FFFF00")!
//
//    static let grey_10 = UIColor(hex: "#1A1A1A")!
//    static let grey_40 = UIColor(hex: "#666666")!
//    static let grey_50 = UIColor(hex: "#808080")!
//    static let grey_60 = UIColor(hex: "#999999")!
    public static let grey_70 = UIColor(hex: "#B2B2B2")!
//    static let grey_80 = UIColor(hex: "#CCCCCC")!
//    static let grey_90 = UIColor(hex: "#E5E5E5")!
//
    public static let fullBlack = UIColor(hex: "#000000")!
//
    public static let fullWhite = UIColor(hex: "#FFFFFF")!
//
//    static let purple = UIColor(hex: "#C779FF")!
//    static let lightPurple = UIColor(hex: "#ffb6ff")!
}

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                    b = CGFloat(hexNumber & 0x0000ff) / 255
                    a = 1.0

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            } else if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}
