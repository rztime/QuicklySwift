//
//  QuicklyButton.swift
//  QuicklySwift
//
//  Created by rztime on 2022/6/2.
//

import UIKit

public extension UIButton {
    /// 设置标题
    @discardableResult
    func qtitle(_ title: String?, _ state: UIControl.State = .normal) -> Self {
        self.setTitle(title, for: state)
        return self
    }
    /// 设置字体
    @discardableResult
    func qfont(_ font: UIFont) -> Self {
        self.titleLabel?.font = font
        return self
    }
    /// 设置标题颜色
    @discardableResult
    func qtitleColor(_ color: UIColor?, _ state: UIControl.State = .normal) -> Self {
        self.setTitleColor(color, for: state)
        return self
    }
    /// 设置标题阴影
    @discardableResult
    func qtitleShadow(_ color: UIColor?, _ state: UIControl.State = .normal) -> Self {
        self.setTitleShadowColor(color, for: state)
        return self
    }
    /// 设置图片
    @discardableResult
    func qimage(_ image: UIImage?, _ state: UIControl.State = .normal) -> Self {
        self.setImage(image, for: state)
        return self
    }
    /// 设置背景图片
    @discardableResult
    func qbackgroundImage(_ image: UIImage?, _ state: UIControl.State = .normal) -> Self {
        self.setBackgroundImage(image, for: state)
        return self
    }
    /// 设置富文本
    @discardableResult
    func qAttributedTitle(_ title: NSAttributedString?, _ state: UIControl.State = .normal) -> Self {
        self.setAttributedTitle(title, for: state)
        return self
    }
    /// 设置内容（包含图片、文字）边距
    @discardableResult
    func qcontentEdge(_ edges: UIEdgeInsets) -> Self {
        self.titleEdgeInsets = edges
        self.imageEdgeInsets = edges
        return self
    }
    /// 设置文本边距
    @discardableResult
    func qtitleEdge(_ edges: UIEdgeInsets) -> Self {
        self.titleEdgeInsets = edges
        return self
    }
    /// 设置图片边距
    @discardableResult
    func qimageEdge(_ edges: UIEdgeInsets) -> Self {
        self.imageEdgeInsets = edges
        return self
    }
}
