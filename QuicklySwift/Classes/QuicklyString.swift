//
//  QuicklyString.swift
//  QuicklySwift
//
//  Created by rztime on 2023/1/19.
//

import UIKit

public extension String {
    /// emoji表情 长度计算
    enum QEmoji {
        case count  /// 长度永远为1
        case length /// 实际占用长度，可能为2,4,7等等
    }
    /// 取前to长度的字符串，如果长度不够，则返回本身
    /// length  和 count的区别：表情长度计算length=2、4、7等，而 count = 1
    func qsubstring(emoji: String.QEmoji, to: Int) -> String {
        switch emoji {
        case .count:
            if self.count <= to { return self}
            let text = self.prefix(upTo: self.index(self.startIndex, offsetBy: to))
            return String(text).qsafe
        case .length:
            let text = self as NSString
            if text.length <= to { return self }
            return text.substring(to: to).qsafe
        }
    }
    /// 从from截取至字符串末尾
    /// length  和 count的区别：表情长度计算length=2、4、7等，而 count = 1
    func qsubstring(emoji: String.QEmoji, from: Int) -> String {
        switch emoji {
        case .count:
            if self.count <= from { return ""}
            let text = self.suffix(from: self.index(self.startIndex, offsetBy: from))
            return String(text).qsafe
        case .length:
            let text = self as NSString
            if text.length <= from { return ""}
            return text.substring(from: from).qsafe
        }
    }
    /// 截取字符串range里的文字
    /// length  和 count的区别：表情长度计算length=2、4、7等，而 count = 1
    func qsubstring(emoji: String.QEmoji, with range: NSRange) -> String {
        switch emoji {
        case .count:
            if range.location >= self.count { return ""}
            let star = self.index(self.startIndex, offsetBy: range.location)
            if range.location + range.length >= self.count {
                return String(self[star..<self.endIndex]).qsafe
            }
            let end = self.index(star, offsetBy: range.length)
            return String(self[star..<end]).qsafe
        case .length:
            let text = self as NSString
            if range.location >= text.length { return ""}
            if range.location + range.length >= text.length {
                return text.substring(from: range.location).qsafe
            }
            return text.substring(with: range).qsafe
        }
    }
    /// 安全字符串，当截取了表情时，可能会出现“�”，这里去掉它
    var qsafe: String {
        let newText = self
        if let data = newText.data(using: .utf8), let temp = NSString.init(data: data, encoding: String.Encoding.utf8.rawValue), temp.contains("\u{0000fffd}") {
            return temp.replacingOccurrences(of: "\u{0000fffd}", with: "") as String
        }
        return self
    }
    /// 将字符串转换为URL
    var qtoURL: URL? {
        if self.isEmpty {
            return nil
        }
        if self.hasPrefix("http") || self.hasPrefix("file://") {
            if let url = URL.init(string: self) {
                return url
            }
            if let u = self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL.init(string: u) {
                return url
            }
            return nil
        }
        return URL.init(fileURLWithPath: self)
    }
    var qasNSString: NSString {
        return NSString(string: self)
    }
}
