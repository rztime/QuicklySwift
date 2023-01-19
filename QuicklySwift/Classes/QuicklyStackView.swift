//
//  QuicklyStackView.swift
//  QuicklySwift
//
//  Created by rztime on 2022/6/2.
//

import UIKit
/// 垂直UIStackView
public struct VStackView {
    /// 垂直UIStackView
    @discardableResult
    static public func qbody(_ views: [UIView]) -> QStackView {
        return QStackView.qbody(.vertical, 0, .fill, .equalSpacing, views)
    }
}
/// 水平UIStackView
public struct HStackView {
    /// 水平UIStackView
    @discardableResult
    static public func qbody(_ views: [UIView]) -> QStackView {
        return QStackView.qbody(.horizontal, 0, .fill, .equalSpacing, views)
    }
}
// MARK: - 初始化方法
public extension UIStackView {
    /// 生成QStackView
    @discardableResult
    class func qbody(_ axis: NSLayoutConstraint.Axis, _ space: CGFloat, _ align: UIStackView.Alignment, _ distribution: UIStackView.Distribution, _ views: [UIView]?) -> QStackView {
        let stackView = QStackView.init(frame: .zero)
        stackView.qaxis(axis).qspacing(space).qalignment(align).qdistribution(distribution)
        if let views = views, views.count > 0 {
            stackView.qbody(views)
        }
        return stackView
    }
}
// MARK: - 方法
public extension UIStackView {
    /// 添加子视图
    @discardableResult
    func qaddArrangedSubview(_ view: UIView) -> Self {
        self.addArrangedSubview(view)
        return self
    }
    /// 插入子视图
    @discardableResult
    func qinsertArrangedSubview(_ view: UIView, at stackIndex: Int) -> Self {
        self.insertArrangedSubview(view, at: stackIndex)
        return self
    }
    /// 视图排列方式
    @discardableResult
    func qaxis( _ axis: NSLayoutConstraint.Axis) -> Self {
        self.axis = axis
        return self
    }
    /// 视图在父视图的分布
    @discardableResult
    func qdistribution(_ distribution: UIStackView.Distribution) -> Self {
        self.distribution = distribution
        return self
    }
    /// 子视图之间的对齐方式
    @discardableResult
    func qalignment(_ alignment: UIStackView.Alignment) -> Self {
        self.alignment = alignment
        return self
    }
    /// 子视图之间的间距
    @discardableResult
    func qspacing(_ spacing: CGFloat) -> Self {
        self.spacing = spacing
        return self
    }
    @discardableResult
    func qsetCustomSpacing(_ spacing: CGFloat, after arrangedSubview: UIView) -> Self {
        if #available(iOS 11.0, *) {
            self.setCustomSpacing(spacing, after: arrangedSubview)
        }
        return self
    }
    @discardableResult
    func qisBaselineRelativeArrangement(_ value: Bool) -> Self {
        self.isBaselineRelativeArrangement = value
        return self
    }
    @discardableResult
    func qisLayoutMarginsRelativeArrangement(_ value: Bool) -> Self {
        self.isLayoutMarginsRelativeArrangement = value
        return self
    }
    /// 移除子视图
    @discardableResult
    func qremoveArrangedSubview(_ view: UIView) -> Self {
        self.removeArrangedSubview(view)
        view.removeFromSuperview()
        return self
    }
    /// 移除所有的子视图
    @discardableResult
    func qremoveAllArrangedSubviews() -> Self {
        let subviews = self.arrangedSubviews
        subviews.forEach({self.qremoveArrangedSubview($0)})
        return self
    }
}

/// QStackView 当所有子视图隐藏时，自身也隐藏
open class QStackView: UIStackView {
    /// 记录本身是否隐藏
    private var tempIsHidden : Bool = false
    
    open override var isHidden: Bool {
        didSet {
            tempIsHidden = isHidden
        }
    }
    /// 如果所有子视图都隐藏，自己也隐藏
    open var isHiddenWhenSubviewAllHidden: Bool = true
    
    open override func layoutSubviews() {
        defer {
            super.layoutSubviews()
        }
        if self.isHiddenWhenSubviewAllHidden == false {
            return
        }
        if tempIsHidden { /// 自己本身是隐藏的，就不管下边的
            return
        }
        let tempHidden = tempIsHidden
        let subviews = self.arrangedSubviews
        if let _ = subviews.first(where: {!$0.isHidden}) {
            self.isHidden = false
        } else {
            self.isHidden = true
        }
        self.tempIsHidden = tempHidden
    }
    open override func removeArrangedSubview(_ view: UIView) {
        super.removeArrangedSubview(view)
        view.removeFromSuperview()
    }
}
