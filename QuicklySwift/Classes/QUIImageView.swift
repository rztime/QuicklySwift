//
//  QuicklyImageView.swift
//  QuicklySwift
//
//  Created by rztime on 2022/6/2.
//

import UIKit

public extension UIImageView {
    /// 设置图片
    @discardableResult
    func qimage(_ image: UIImage?) -> Self {
        self.image = image
        return self
    }
    @discardableResult
    func qhighlightedImage(_ image: UIImage?) -> Self {
        self.highlightedImage = image
        return self
    }
    @discardableResult
    func qisHighlighted(_ high: Bool) -> Self {
        self.isHighlighted = high
        return self
    }
    /// 重绘图片的颜色，png适用
    /// - Parameter color:
    @discardableResult
    func qimageRedrawColor(_ color: UIColor?) -> Self {
        if color == nil {
            self.tintColor = nil
            self.image = self.image?.withRenderingMode(.alwaysOriginal)
        } else {
            self.image = self.image?.withRenderingMode(.alwaysTemplate)
            self.tintColor = color
        }
        return self
    }
    /// 重绘图片的颜色，png适用
    /// - Parameter color:
    @discardableResult
    func qhighlightedImageRedrawColor(_ color: UIColor?) -> Self {
        if color == nil {
            self.tintColor = nil
            self.highlightedImage = self.highlightedImage?.withRenderingMode(.alwaysOriginal)
        } else {
            self.highlightedImage = self.highlightedImage?.withRenderingMode(.alwaysTemplate)
            self.tintColor = color
        }
        return self
    }
}
