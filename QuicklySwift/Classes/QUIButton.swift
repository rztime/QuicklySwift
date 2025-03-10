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
    /// 行数
    @discardableResult
    func qnumberOfLines(_ line: Int) -> Self {
        self.titleLabel?.numberOfLines = line
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
    /// 给文字设置渐变色
    /// - Parameters:
    ///   - gradinent: 渐变色
    ///   - locations: 位置
    ///   - start: 起点
    ///   - end: 终点
    ///   - size: 渐变区域
    @discardableResult
    func qtitleColor(gradinent: [UIColor], locations: [NSNumber], start: CGPoint, end: CGPoint, size: CGSize, state: UIControl.State = .normal) -> Self {
        let image = UIImage.qimageBy(gradinentColors: gradinent, locations: locations, start: start, end: end, size: size)
        return self.qtitleColor(UIColor.init(patternImage: image), state)
    }
    /// 重绘图片的颜色，png适用
    /// - Parameter color:
    @discardableResult
    func qimageRedrawColor(_ color: UIColor?, for state: UIControl.State) -> Self {
        if color == nil {
            self.tintColor = nil
            let image = self.image(for: state)?.withRenderingMode(.alwaysOriginal)
            self.setImage(image, for: state)
        } else {
            let image = self.image(for: state)?.withRenderingMode(.alwaysTemplate)
            self.setImage(image, for: state)
            self.tintColor = color
        }
        return self
    }
    /// 重绘背景图片的颜色，png适用
    /// - Parameter color:
    @discardableResult
    func qbackgroundImageRedrawColor(_ color: UIColor?, for state: UIControl.State) -> Self {
        if color == nil {
            self.tintColor = nil
            let image = self.backgroundImage(for: state)?.withRenderingMode(.alwaysOriginal)
            self.setBackgroundImage(image, for: state)
        } else {
            let image = self.backgroundImage(for: state)?.withRenderingMode(.alwaysTemplate)
            self.setBackgroundImage(image, for: state)
            self.tintColor = color
        }
        return self
    }
}
