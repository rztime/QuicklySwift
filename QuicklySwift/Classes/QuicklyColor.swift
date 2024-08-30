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
    class func qhex(_ hex: Int, a: CGFloat = 1) -> UIColor {
        return qrgba((hex >> 16) & 0xff, (hex >> 8) & 0xFF, hex & 0xFF, a: a)
    }
    /// 16进制颜色(字符串)  #ff33ee
    class func qhex(_ hex: String, a: CGFloat? = nil) -> UIColor {
        var hex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hex = hex.replacingOccurrences(of: "#", with: "")
        if hex.count != 6 && hex.count != 8 {
            return UIColor.clear
        }
        var rgbValue: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&rgbValue)
        
        let r, g, b: CGFloat
        var tempa: CGFloat
        if hex.count == 6 {
            r = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgbValue & 0x0000FF) / 255.0
            tempa = 1.0
        } else {
            r = CGFloat((rgbValue & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgbValue & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgbValue & 0x0000FF00) >> 8) / 255.0
            tempa = CGFloat(rgbValue & 0x000000FF) / 255.0
        }
        if let a = a {
            tempa = a
        }
        return UIColor(red: r, green: g, blue: b, alpha: tempa)
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
    /// 颜色对应的16进制  ff9900
    /// 如果有透明值，则有八位，最后两位是透明值
    var qhexString: String {
        return self.cgColor.qhexString;
    }
    /// R  0-255
    var qR: Int {
        return self.cgColor.qR
    }
    /// G  0-255
    var qG: Int {
        return self.cgColor.qG
    }
    /// B  0-255
    var qB: Int {
        return self.cgColor.qB
    }
    /// A  0.0-1.0
    var qA: CGFloat {
        return self.cgColor.qA
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
    /// 16进制颜色 #ff33ee
    class func qhex(_ hex: String, a: CGFloat? = nil) -> CGColor {
        return UIColor.qhex(hex, a: a).cgColor
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
    /// 颜色对应的16进制  ff9900
    /// 如果有透明值，则有八位，最后两位是透明值
    var qhexString: String {
        let r = self.qR
        let g = self.qG
        let b = self.qB
        let a = Int(self.qA * 255)
        if a == 255 {
            return String(format: "%02X%02X%02X", r, g, b)
        }
        return String(format: "%02X%02X%02X%02X", r, g, b, a)
    }
    /// R  0-255
    var qR: Int {
        if let r = self.components?[qsafe: 0] { return Int(r * 255) }
        return 0
    }
    /// G  0-255
    var qG: Int {
        if self.numberOfComponents == 4, let v = self.components?[1] {
            return Int(v * 255)
        }
        return self.qR
    }
    /// B  0-255
    var qB: Int {
        if self.numberOfComponents == 4, let v = self.components?[2] {
            return Int(v * 255)
        }
        return self.qR
    }
    /// A  0.0-1.0
    var qA: CGFloat {
        if self.numberOfComponents == 4, let v = self.components?[3] {
            return v
        }
        if self.numberOfComponents == 2, let v = self.components?[1] {
            return v
        }
        return 1
    }
}
