//
//  QuicklyUIControl.swift
//  QuicklySwift
//
//  Created by rztime on 2022/6/1.
//

import UIKit

public extension UIControl {
    @discardableResult
    func qisEnabled(_ enable: Bool) -> Self {
        self.isEnabled = enable
        return self
    }
    @discardableResult
    func qisSelected(_ selected: Bool) -> Self {
        self.isSelected = selected
        return self
    }
    @discardableResult
    func qisHighlighted(_ light: Bool) -> Self {
        self.isHighlighted = light
        return self
    }
    @discardableResult
    func qaddTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) -> Self {
        self.addTarget(target, action: action, for: controlEvents)
        return self
    }
    @discardableResult
    func qremoveTarget(_ target: Any?, action: Selector?, for controlEvents: UIControl.Event) -> Self {
        self.removeTarget(target, action: action, for: controlEvents)
        return self
    }
    @discardableResult
    func qsendAction(_ action: Selector, to target: Any?, for event: UIEvent?) -> Self {
        self.sendAction(action, to: target, for: event)
        return self
    }
    @discardableResult
    func qsendActions(for controlEvents: UIControl.Event) -> Self {
        self.sendActions(for: controlEvents)
        return self
    }
    /// 内容水平对齐方式（居左、居右、居中）
    @discardableResult
    func qHAlign(_ align: UIControl.ContentHorizontalAlignment) -> Self {
        self.contentHorizontalAlignment = align
        return self
    }
    /// 内容垂直对齐方式（居左、居右、居中）
    @discardableResult
    func qVAlign(_ align: UIControl.ContentVerticalAlignment) -> Self {
        self.contentVerticalAlignment = align
        return self
    }
}

public extension QuicklyProtocal where Self: UIControl {
    /// control的事件回调
    @discardableResult
    func qactionFor(_ event: UIControl.Event, handler:((_ sender: Self) -> Void)?) -> Self {
        let v = QControlHelper.init(target: self, event: event)
        v.handler = { sender in
            if let s = sender as? Self {
                handler?(s)
            }
        }
        return self
    }
    /// control isSelected 状态发生改变之后的回调
    @discardableResult
    func qisSelectedChanged(_ changed: ((_ sender: Self) -> Void)?) -> Self {
        self.qaddObserver(key: "selected", options: [.new, .old], context: nil) { sender, key, value in
            changed?(sender)
        }
        changed?(self)
        return self
    }
    /// control isEnabled 状态发生改变之后的回调
    @discardableResult
    func qisEnabledChanged(_ changed: ((_ sender: Self) -> Void)?) -> Self {
        self.qaddObserver(key: "enabled", options: [.new, .old], context: nil) { sender, key, value in
            changed?(sender)
        }
        changed?(self)
        return self
    }
    /// control isEnabled 状态发生改变之后的回调
    @discardableResult
    func qisHighlightedChanged(_ changed: ((_ sender: Self) -> Void)?) -> Self {
        self.qaddObserver(key: "highlighted", options: [.new, .old], context: nil) { sender, key, value in
            changed?(sender)
        }
        changed?(self)
        return self
    }
}

open class QControlHelper: UIView {
    open var handler: ((_ sender: UIControl) -> Void)?
    weak var target: UIControl?
    open var key: String = ""
    public init(target: UIControl, event: UIControl.Event) {
        super.init(frame: .zero)
        self.isHidden = true
        target.addSubview(self)
        target.addTarget(self, action: #selector(targetActions), for: event)
    }
    @objc open func targetActions(_ sender: UIControl) {
        self.handler?(sender)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
