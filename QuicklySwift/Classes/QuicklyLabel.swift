//
//  QuicklyLabel.swift
//  QuicklySwift
//
//  Created by rztime on 2022/6/1.
//

import UIKit

public extension UILabel {
    @discardableResult
    func qtext(_ text: String?) -> Self {
        self.text = text
        return self
    }
    @discardableResult
    func qfont(_ font: UIFont) -> Self {
        self.font = font
        return self
    }
    @discardableResult
    func qtextColor(_ color: UIColor?) -> Self {
        self.textColor = color
        return self
    }
    @discardableResult
    func qshadowText(_ color: UIColor?, _ offset: CGSize) -> Self {
        self.shadowColor = color
        self.shadowOffset = offset
        return self
    }
    @discardableResult
    func qtextAliginment(_ align: NSTextAlignment) -> Self {
        self.textAlignment = align
        return self
    }
    @discardableResult
    func qlineBreakMode(_ mode: NSLineBreakMode) -> Self {
        self.lineBreakMode = mode
        return self
    }
    @discardableResult
    func qattributedText(_ text: NSAttributedString?) -> Self {
        self.attributedText = text
        return self
    }
    @discardableResult
    func qnumberOfLines(_ lines: Int) -> Self {
        self.numberOfLines = lines
        return self
    }
    @discardableResult
    func qadjustsFontSizeToFitWidth(_ value: Bool) -> Self {
        self.adjustsFontSizeToFitWidth = value
        return self
    }
    @discardableResult
    func qpreferredMaxLayoutWidth(_ width: CGFloat) -> Self {
        self.preferredMaxLayoutWidth = width
        return self
    }
    /// 给文字设置渐变色
    /// - Parameters:
    ///   - gradinent: 渐变色
    ///   - locations: 位置
    ///   - start: 起点
    ///   - end: 终点
    ///   - size: 渐变区域
    @discardableResult
    func qtextColor(gradinent: [UIColor], locations: [NSNumber], start: CGPoint, end: CGPoint, size: CGSize) -> Self {
        let image = UIImage.qimageBy(gradinentColors: gradinent, locations: locations, start: start, end: end, size: size)
        self.textColor = UIColor.init(patternImage: image)
        return self
    }
}
