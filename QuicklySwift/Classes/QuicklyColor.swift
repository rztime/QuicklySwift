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
    class var qrandom: UIColor {
        let r = Int.random(in: 0...255)
        let g = Int.random(in: 0...255)
        let b = Int.random(in: 0...255)
        return qrgb(r, g, b)
    }
    /// 颜色转换图片
    func qtoImage(_ size: CGSize = .init(width: 1, height: 1)) -> UIImage? {
        return self.cgColor.qtoImage(size)
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
    class var qrandom: CGColor {
        let r = Int.random(in: 0...255)
        let g = Int.random(in: 0...255)
        let b = Int.random(in: 0...255)
        return qrgb(r, g, b)
    }
    /// 颜色转换图片
    func qtoImage(_ size: CGSize = .init(width: 1, height: 1)) -> UIImage? {
        var res: UIImage? = nil
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(self)
        context?.fill(rect)
        res = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return res
    }
}
