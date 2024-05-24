//
//  QuicklyView.swift
//  QuicklySwift
//
//  Created by rztime on 2022/6/1.
//

import UIKit
import SnapKit

// MARK: - 添加视图方法
public extension UIView {
    /// 添加子视图
    @discardableResult
    func qaddSubviews(_ views: [UIView]) -> Self {
        return self.qbody(views)
    }
    
    /// 添加子视图, 如果是stackView，会添加addArrangedSubview
    @discardableResult
    func qbody(_ views: [UIView]) -> Self {
        if let stackView = self as? UIStackView {
            views.forEach({stackView.addArrangedSubview($0)})
        } else {
            views.forEach({self.addSubview($0)})
        }
        /// 激活约束
        views.forEach({$0.qactiveConstraints()})
        return self
    }
    /// 初始化Self并添加子视图
    @discardableResult
    class func qaddSubviews(_ views: [UIView]) -> Self {
        return self.qbody(views)
    }
    /// 初始化Self并添加子视图
    @discardableResult
    class func qbody(_ views: [UIView]) -> Self {
        let superView = Self.init()
        return superView.qbody(views)
    }
    @discardableResult
    func qremoveAllSubViews() -> Self {
        if let stackView = self as? UIStackView {
            stackView.qremoveAllArrangedSubviews()
        } else {
            let views = self.subviews
            views.forEach({$0.removeFromSuperview()})
        }
        return self
    }
    /// 快速将views组装成一个stackView
    @discardableResult
    class func qjoined(_ views: [UIView], aixs: NSLayoutConstraint.Axis, spacing: CGFloat, align: UIStackView.Alignment, distribution: UIStackView.Distribution) -> QStackView {
        return QStackView.qbody(aixs, spacing, align, distribution, views)
    }
    /// 直接将views组成一个stackView，并添加到自己上边
    @discardableResult
    func qjoined(_ views: [UIView], aixs: NSLayoutConstraint.Axis, spacing: CGFloat, align: UIStackView.Alignment, distribution: UIStackView.Distribution) -> Self {
        let v = UIView.qjoined(views, aixs: aixs, spacing: spacing, align: align, distribution: distribution)
        self.qbody([
            v.qmakeConstraints({ make in
                make.edges.equalToSuperview()
            })
        ])
        return self
    }
    /// 设置约束。 注意，这个方法仅仅是方便qaddSubviews()  qbody() 方法里的view使用
    /// 需要调用qactiveConstraints() 激活,
    /// 方法里已经激活了，可以不需要调用
    @discardableResult
    func qmakeConstraints(_ closure: ((_ make: ConstraintMaker) -> Void)?) -> Self {
        self.qconstraintMake = closure
        return self
    }
    /// 激活snap的约束
    @discardableResult
    func qactiveConstraints() -> Self {
        if let constraintMake = qconstraintMake {
            self.snp.makeConstraints(constraintMake)
            self.qconstraintMake = nil
        }
        return self
    }
}
// MARK: - 属性设置方法
public extension UIView {
    @discardableResult
    func qalpha(_ alpha: CGFloat) -> Self {
        self.alpha = alpha
        return self
    }
    @discardableResult
    func qisHidden(_ hidden: Bool) -> Self {
        self.isHidden = hidden
        return self
    }
    @discardableResult
    func qbackgroundColor(_ color: UIColor?) -> Self {
        self.backgroundColor = color
        return self
    }
    @discardableResult
    func qcontentMode(_ mode: UIView.ContentMode) -> Self {
        self.contentMode = mode
        return self
    }
    /// 设置圆角
    @discardableResult
    func qcornerRadius(_ radius: CGFloat, _ maskToBounds: Bool) -> Self {
        self.layer.qcornerRadius(radius, maskToBounds)
        return self
    }
    /// 边框
    @discardableResult
    func qborder(_ color: UIColor?, _ width: CGFloat) -> Self {
        self.layer.qborder(color, width)
        return self
    }
    @discardableResult
    func qisUserInteractionEnabled(_ enable: Bool) -> Self {
        self.isUserInteractionEnabled = enable
        return self
    }
    @discardableResult
    func qtag(_ tag: Int) -> Self {
        self.tag = tag
        return self
    }
    /// 结束编辑
    @discardableResult
    func qendEditing(_ force: Bool) -> Self {
        self.endEditing(force)
        return self
    }
    /// 设置阴影
    @discardableResult
    func qshadow(_ color: UIColor?, _ offset: CGSize, radius: CGFloat, _ opacity: Float = 1) -> Self {
        self.layer.qshadow(color, offset, radius: radius, opacity)
        return self
    }
}
public extension UIView {
    @discardableResult
    func qframe(_ frame: CGRect) -> Self {
        self.frame = frame
        return self
    }
    @discardableResult
    func qbounds(_ bounds: CGRect) -> Self {
        self.bounds = bounds
        return self
    }
    @discardableResult
    func qcenter(_ center: CGPoint) -> Self {
        self.center = center
        return self
    }
    @discardableResult
    func qorigin(_ origin: CGPoint) -> Self {
        self.frame.origin = origin
        return self
    }
    @discardableResult
    func qsize(_ size: CGSize) -> Self {
        self.frame.size = size
        return self
    }
    @discardableResult
    func qx(_ x: CGFloat) -> Self {
        self.frame.origin.x = x
        return self
    }
    @discardableResult
    func qy(_ y: CGFloat) -> Self {
        self.frame.origin.y = y
        return self
    }
    @discardableResult
    func qwidth(_ width: CGFloat) -> Self {
        self.frame.size.width = width
        return self
    }
    @discardableResult
    func qheight(_ height: CGFloat) -> Self {
        self.frame.size.height = height
        return self
    }
}
public extension QuicklyProtocal where Self: UIView {
    /// view isHidden 改变的回调
    @discardableResult
    func qisHiddenChanged(_ changed: ((_ view: Self) -> Void)?) -> Self {
        self.qaddObserver(key: "hidden", options: [.new, .old], context: nil) { sender, key, value in
            changed?(sender)
        }
        changed?(self)
        return self
    }
    /// view isUserInteractionEnabled 改变的回调
    @discardableResult
    func qisUserInteractionEnabledChanged(_ changed: ((_ view: Self) -> Void)?) -> Self {
        self.qaddObserver(key: "userInteractionEnabled", options: [.new, .old], context: nil) { sender, key, value in
            changed?(sender)
        }
        changed?(self)
        return self
    }
    /// view frame 改变的回调
    @discardableResult
    func qframeChanged(_ changed: ((_ view: Self) -> Void)?) -> Self {
        var lastFrame = CGRect.init(x: -1, y: -1, width: -1, height: -1)
        self.qaddObserver(key: "bounds", options: [.new, .old], context: nil) { sender, key, value in
            if sender.frame.equalTo(lastFrame) { return }
            lastFrame = sender.frame
            changed?(sender)
        }
        self.qaddObserver(key: "frame", options: [.new, .old], context: nil) { sender, key, value in
            if sender.frame.equalTo(lastFrame) { return }
            lastFrame = sender.frame
            changed?(sender)
        }
        changed?(self)
        return self
    }
    /// view size 改变的回调
    @discardableResult
    func qsizeChanged(_ changed: ((_ view: Self) -> Void)?) -> Self {
        var boundsSize = CGSize.init(width: -1, height: -1)
        self.qaddObserver(key: "bounds", options: [.new, .old], context: nil) { sender, key, value in
            if sender.frame.size.equalTo(boundsSize) { return }
            boundsSize = sender.bounds.size
            changed?(sender)
        }
        self.qaddObserver(key: "frame", options: [.new, .old], context: nil) { sender, key, value in
            if sender.frame.size.equalTo(boundsSize) { return }
            boundsSize = sender.bounds.size
            changed?(sender)
        }
        changed?(self)
        return self
    }
    /// 是否显示在window上（view所在vc在栈顶，如果push到其他页面，则为false）
    @discardableResult
    func qshowToWindow(_ show: ((_ view: Self, _ showed: Bool) -> Void)?) -> Self {
        let v = QuicklyObjectHelper.init(targetView: self)
        v.showToWindow = { view, s in
            if let view = view as? Self {
                show?(view, s)
            }
        }
        show?(self, self.window != nil)
        return self
    }
}
// MARK: - 其他方法
public extension UIView {
    /// 设置部分圆角，可选某一个圆角
    @discardableResult
    func qcornerRadiusCustom(_ corners: UIRectCorner, radii: CGFloat) -> Self {
        self.qsizeChanged { view in
            view.layer.qcornerRadiusCustom(corners, radii: radii, frame: view.bounds)
        }
        return self
    }
    /// 高斯模糊
    @discardableResult
    func qgaussBlur(_ style: UIBlurEffect.Style = .light, _ alpha: CGFloat = 1) -> Self {
        self.qsizeChanged { view in
            let blur : UIVisualEffectView
            if let v = view.subviews.first(where: {$0.isKind(of: UIVisualEffectView.self)}) as? UIVisualEffectView {
                blur = v
            } else {
                blur = UIVisualEffectView.init(frame: view.bounds)
            }
            blur.frame = view.bounds
            blur.alpha = alpha
            blur.effect = UIBlurEffect.init(style: style)
            view.insertSubview(blur, at: 0)
        }
        self.setNeedsLayout()
        return self
    }
    /// 设置渐变色 （UILabel设置之后，文字将无法显示）
    /// - Parameters:
    ///   - colors: 颜色数组
    ///   - locations: 颜色对应的位置，个数与颜色数组个数匹配，否则会有额外的结果
    ///   - start: 起点
    ///   - end: 终点
    @discardableResult
    func qgradientColors(_ colors: [UIColor], locations: [NSNumber], start: CGPoint, end: CGPoint) -> Self {
        self.qsizeChanged { view in
            view.layer.qgradientColors(colors, locations: locations, start: start, end: end)
        }
        return self
    }
    /// 添加一个气泡
    /// - Parameters:
    ///   - corners: 气泡四角是否需要圆角
    ///   - radii: 圆角的size
    ///   - size: 气泡三角形的size
    ///   - location: 气泡三角形的位置
    ///   - color: 填充颜色
    @discardableResult
    func qairbubble(_ corners: UIRectCorner, radii: CGFloat, air size: CGSize, location: QairbubbleLocation, color: UIColor?) -> Self {
        self.qsizeChanged { view in
            view.layer.qairbubble(corners, radii: radii, air: size, location: location, color: color)
        }
        return self
    }
    @discardableResult
    /// 添加虚线（默认虚线画在view居中）
    /// - Parameters:
    ///   - color: 虚线颜色
    ///   - lineWidth: 虚线宽度
    ///   - height: 高度
    ///   - space: 虚线间隔
    ///   - direction: 划线方向
    func qdashLine(color: UIColor?, lineWidth: CGFloat, height: CGFloat, space: CGFloat, direction: NSLayoutConstraint.Axis) -> Self {
        self.qsizeChanged { view in
            view.layer.qdashLine(color: color, lineWidth: lineWidth, height: height, space: space, direction: direction)
        }
        return self
    }
}
public extension QuicklyProtocal where Self: UIView {
    /// UIView将要被点击的时候触发(点击子视图时，也会触发), 一个view只能设置一次，多次设置将以最新的覆盖之前的
    @discardableResult
    func qwillTouchIn(_ touchIn: ((_ view: Self) -> Void)?) -> Self {
        var temp: QTouchView
        if let v = self.subviews.filter({$0.isKind(of: QTouchView.self)}).first as? QTouchView {
            temp = v
        } else {
            temp = QTouchView.init()
            self.qbody([
                temp.qmakeConstraints({ make in
                    make.edges.equalToSuperview().priority(.low)
                })
            ])
        }
        temp.willTouchIn = { [weak self] in
            if let self = self {
                touchIn?(self)
            }
        }
        return self
    }
    /// UIView的单击事件, 一个view只能设置一次，多次设置将以最新的覆盖之前的
    @discardableResult
    func qtap(_ tap: ((_ view: Self) -> Void)?) -> Self {
        self.qtapNumberof(touches: 1, taps: 1) { view, _  in
            tap?(view)
        }
        return self
    }
    /// 点击手势
    @discardableResult
    func qtapNumberof(touches: Int, taps: Int, _ tapaction: ((_ view: Self) -> Void)?) -> Self {
        let _ = QTapGestureRecognizer.init(target: self, numberofTouches: touches, numberofTaps: taps) { view in
            if let view = view as? Self {
                tapaction?(view)
            }
        }
        return self
    }
    /// 点击手势
    @discardableResult
    func qtapNumberof(touches: Int, taps: Int, _ tapactionwithTap: ((_ view: Self, _ tap: UITapGestureRecognizer) -> Void)?) -> Self {
        let tap = QTapGestureRecognizer.init(target: self, numberofTouches: touches, numberofTaps: taps, nil)
        tap.tapActionResultWithTap = { view, t in
            if let view = view as? Self {
                tapactionwithTap?(view, t)
            }
        }
        return self
    }
    /// 拖动手势
    @discardableResult
    func qpanNumberof(touches min: Int, max: Int, _ panAction: ((_ view: Self, _ pan: UIPanGestureRecognizer) -> Void)?) -> Self {
        let _ = QPanGestureRecognizer.init(target: self, minOfTouches: min, maxOfTouches: max, { view, p in
            if let view = view as? Self {
                panAction?(view, p)
            }
        })
        return self
    }
    
    /// 给UIView添加拖拽手势，可以在父视图内进行自由拖动
    /// center: 拖动开始后，视图中心点移动到手指处
    @discardableResult
    func qdrag(_ style: QPanGestureRecognizer.QDragPanStyle?, center: Bool = false, _ panAction: ((_ view: Self, _ pan: UIPanGestureRecognizer) -> Void)? = nil) -> Self {
        let pan = QPanGestureRecognizer.init(target: self, minOfTouches: 1, maxOfTouches: 1, { view, p in
            if let view = view as? Self {
                panAction?(view, p)
            }
        })
        pan.setDragInSupver(starCenter: center, dragStyle: style)
        return self
    }
    /// 长按手势
    /// moveMent: 长按时，允许滑动范围，默认是10
    /// taps = 0 // 即响应长按手势之前，需要单击几次，默认0
    @discardableResult
    func qlongpress(numberof touches: Int, taps: Int = 0, minpress duration: TimeInterval, movement: CGFloat, _ action: ((_ view: Self, _ longpress: UILongPressGestureRecognizer) -> Void)?) -> Self {
        let _ = QLongPressGestureRecognizer.init(target: self, numberofTouches: touches, numberofTaps: taps, minPressDuration: duration, movement: movement, { view, long in
            if let view = view as? Self {
                action?(view, long)
            }
        })
        return self
    }
    /// 快速轻扫手势
    @discardableResult
    func qswipe(numberof touches: Int, direction: UISwipeGestureRecognizer.Direction, _ swipe: ((_ view: Self, _ swipe: UISwipeGestureRecognizer) -> Void)?) -> Self {
        let _ = QSwipeGestureRecognizer.init(target: self, numberofTouches: touches, direction: direction, { view, s in
            if let view = view as? Self {
                swipe?(view, s)
            }
        })
        return self
    }
}
// MARK: - 给view添加手势
public extension UIView {
    /// 移除点击tap手势
    @discardableResult
    func qremoveTapGesture(touches: Int, taps: Int) -> Self {
        /// 将之前的重复的去掉
        let oldGesture : [UITapGestureRecognizer] = (self.gestureRecognizers?.filter({$0.isKind(of: UITapGestureRecognizer.self)}) as? [UITapGestureRecognizer]) ?? []
        oldGesture.forEach { old in
            if old.numberOfTouchesRequired == touches,
               old.numberOfTapsRequired == taps {
                self.removeGestureRecognizer(old)
            }
        }
        return self
    }
    /// 移除拖拽pan手势
    @discardableResult
    func qremovePanGesture(touches min: Int, max: Int) -> Self {
        /// 将之前的重复的去掉
        let oldGesture :[UIPanGestureRecognizer] = (self.gestureRecognizers?.filter({$0.isKind(of: UIPanGestureRecognizer.self)}) as? [UIPanGestureRecognizer]) ?? []
        oldGesture.forEach { old in
            if old.minimumNumberOfTouches == min,
               old.maximumNumberOfTouches == max {
                self.removeGestureRecognizer(old)
            }
        }
        return self
    }
    /// 移除长按手势
    @discardableResult
    func qremoveLongpress(numberof touches: Int, taps: Int = 0) -> Self {
        /// 将之前的重复的去掉
        let oldGesture :[UILongPressGestureRecognizer] = (self.gestureRecognizers?.filter({$0.isKind(of: UILongPressGestureRecognizer.self)}) as? [UILongPressGestureRecognizer]) ?? []
        oldGesture.forEach { old in
            if old.numberOfTouchesRequired == touches,
               old.numberOfTapsRequired == taps {
                self.removeGestureRecognizer(old)
            }
        }
        return self
    }

    /// 移除轻扫手势
    @discardableResult
    func qremoveSwipe(numberof touches: Int, direction: UISwipeGestureRecognizer.Direction) -> Self {
        /// 将之前的重复的去掉
        let oldGesture :[UISwipeGestureRecognizer] = (self.gestureRecognizers?.filter({$0.isKind(of: UISwipeGestureRecognizer.self)}) as? [UISwipeGestureRecognizer]) ?? []
        oldGesture.forEach { old in
            if old.numberOfTouchesRequired == touches, old.direction == direction {
                self.removeGestureRecognizer(old)
            }
        }
        return self
    }
}

public extension UIView {
    /// 将view 转换成图片
    func qtoImage() -> UIImage? {
        var flag = false
        if self.superview == nil && self.frame.isEmpty {
            qappKeyWindow.addSubview(self)
            flag = true
        }
        self.layoutIfNeeded()
        let image = self.layer.qtoImage()
        if flag {
            self.removeFromSuperview()
        }
        return image
    }
}

public extension UIView {
    enum QViewShowType {
        /// 优先级低，容易被拉伸或者压缩
        case low
        /// 优先级高，将不能被压缩或者拉伸
        case height
        /// 默认(将设置还原)
        case defaultType
    }
    /// 显示优先级（完全显示，或者易被拉伸）
    /// - Parameters:
    ///   - axis: 水平或者垂直方向
    ///   - type:   low：优先级低，容易被拉伸或者压缩  height: 优先级高，将不能被压缩或者拉伸
    @discardableResult
    func qshowType(_ axis: NSLayoutConstraint.Axis, type: QViewShowType) -> Self {
        switch type {
        case .low:
            self.setContentHuggingPriority(.fittingSizeLevel, for: axis)
            self.setContentCompressionResistancePriority(.fittingSizeLevel, for: axis)
        case .height:
            self.setContentHuggingPriority(.required, for: axis)
            self.setContentCompressionResistancePriority(.required, for: axis)
        case .defaultType:
            self.setContentHuggingPriority(.defaultLow, for: axis)
            self.setContentCompressionResistancePriority(.defaultHigh, for: axis)
        }
        return self
    }
}

class QTouchView: UIView {
    var willTouchIn: (() -> Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isHidden = true
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let point = self.convert(point, to: self)
        if self.bounds.contains(point) {
            self.willTouchIn?()
        }
        return nil
    }
}
