//
//  QuicklyNSAttributedString.swift
//  QuicklySwift
//
//  Created by rztime on 2024/7/29.
//

import UIKit

public extension NSAttributedString {
    /// 取前to长度的字符串，如果长度不够，则返回本身
    /// length  和 count的区别：表情长度计算length=2、4、7等，而 count = 1
    func qsubstring(emoji: String.QEmoji, to: Int) -> NSAttributedString {
        switch emoji {
        case .count:
            let text = self.string
            if text.count <= to { return self }
            let range = text.startIndex..<(text.index(text.startIndex, offsetBy: to, limitedBy: text.endIndex) ?? text.endIndex)
            let attr = self.attributedSubstring(from: NSRange(range, in: text))
            return attr.qsafe
        case .length:
            let text = self.string as NSString
            if text.length <= to { return self }
            let attr = self.attributedSubstring(from: NSRange(location: 0, length: to))
            return attr.qsafe
        }
    }
    /// 从from截取至字符串末尾
    /// length  和 count的区别：表情长度计算length=2、4、7等，而 count = 1
    func qsubstring(emoji: String.QEmoji, from: Int) -> NSAttributedString {
        switch emoji {
        case .count:
            let text = self.string
            if text.count <= from { return .init()}
            let range = (text.index(text.startIndex, offsetBy: from, limitedBy: text.endIndex) ?? text.endIndex)..<text.endIndex
            let attr = self.attributedSubstring(from: NSRange(range, in: text))
            return attr.qsafe
        case .length:
            let text = self.string as NSString
            if text.length <= from { return .init()}
            let attr = self.attributedSubstring(from: NSRange(location: from, length: self.length - from))
            return attr.qsafe
        }
    }
    /// 截取字符串range里的文字
    /// length  和 count的区别：表情长度计算length=2、4、7等，而 count = 1
    func qsubstring(emoji: String.QEmoji, with range: NSRange) -> NSAttributedString {
        switch emoji {
        case .count:
            if range.location >= self.string.count { return .init()}
            let text = self.string
            let star = text.index(text.startIndex, offsetBy: range.location)
            let end = text.index(star, offsetBy: range.length, limitedBy: text.endIndex) ?? text.endIndex
            let range = star..<end
            let attr = self.attributedSubstring(from: NSRange(range, in: text))
            return attr.qsafe
        case .length:
            let text = self.string as NSString
            if range.location >= text.length { return .init()}
            let length = min(range.length, self.length - range.location)
            return self.attributedSubstring(from: .init(location: range.location, length: length)).qsafe
        }
    }
    var qsafe: NSAttributedString {
        if self.string.hasSuffix("�") {
            return self.attributedSubstring(from: .init(location: 0, length: self.length - 1)).qsafe
        }
        if self.string.hasPrefix("�") {
            return self.attributedSubstring(from: .init(location: 1, length: self.length - 1)).qsafe
        }
        return self
    }
}
