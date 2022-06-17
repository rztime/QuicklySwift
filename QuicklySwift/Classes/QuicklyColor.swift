//
//  QuicklyColor.swift
//  QuicklySwift
//
//  Created by rztime on 2022/6/7.
//

import UIKit

public extension UIColor {
    class func qrgb(_ r: Int, _ g: Int, _ b: Int) -> UIColor {
        return qrgba(r, g, b, a: 1)
    }
    class func qrgba(_ r: Int, _ g: Int, _ b: Int, a: CGFloat) -> UIColor {
        return UIColor.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: a)
    }
    /// 16进制颜色 0xff33ee
    class func qhex(_ hex: Int) -> UIColor {
        return qhex(hex, a: 1)
    }
    /// 16进制颜色 0xff33ee
    class func qhex(_ hex: Int, a: CGFloat) -> UIColor {
        return qrgba((hex >> 16) & 0xff, (hex >> 8) & 0xFF, hex & 0xFF, a: a)
    }
    /// 随机颜色
    class var random: UIColor {
        let r = Int.random(in: 0...255)
        let g = Int.random(in: 0...255)
        let b = Int.random(in: 0...255)
        return qrgb(r, g, b)
    }
}
public extension CGColor {
    class func qrgb(_ r: Int, _ g: Int, _ b: Int) -> CGColor {
        return qrgba(r, g, b, a: 1)
    }
    class func qrgba(_ r: Int, _ g: Int, _ b: Int, a: CGFloat) -> CGColor {
        return UIColor.qrgba(r, g, b, a: a).cgColor
    }
    /// 16进制颜色 0xff33ee
    class func qhex(_ hex: Int) -> CGColor {
        return qhex(hex, a: 1)
    }
    /// 16进制颜色 0xff33ee
    class func qhex(_ hex: Int, a: CGFloat) -> CGColor {
        return qrgba((hex >> 16) & 0xff, (hex >> 8) & 0xFF, hex & 0xFF, a: a)
    }
    /// 随机颜色
    class var random: CGColor {
        let r = Int.random(in: 0...255)
        let g = Int.random(in: 0...255)
        let b = Int.random(in: 0...255)
        return qrgb(r, g, b)
    }
}
