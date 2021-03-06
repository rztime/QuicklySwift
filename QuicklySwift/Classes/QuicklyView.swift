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

// MARK: - 其他方法
public extension UIView {
    /// view size 改变的回调
    @discardableResult
    func qsizeChanged(_ size: ((_ view: UIView) -> Void)?) -> Self {
        let v = QUIView.init(target: self)
        v.sizeChanged = size
        return self
    }
    /// 是否显示在window上（view所在vc在栈顶，如果push到其他页面，则为false）
    @discardableResult
    func qshowToWindow(_ show: ((_ view: UIView, _ showed: Bool) -> Void)?) -> Self {
        let v = QUIView.init(target: self)
        v.showToWindow = show
        return self
    }
    /// 被释放时的回调
    @discardableResult
    func qdeinit(_ de:(()-> Void)?) -> Self {
        let v = QUIView.init(target: self)
        v.deinitAction = de
        return self
    }
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
    func qgaussBlur() -> Self {
        self.qsizeChanged { view in
            if let v = view.subviews.first(where: {$0.isKind(of: UIVisualEffectView.self)}) {
                v.frame = view.bounds
            } else {
                let blur = UIVisualEffectView.init(frame: view.bounds)
                if #available(iOS 10.0, *) {
                    blur.effect = UIBlurEffect.init(style: .regular)
                } else {
                    blur.effect = UIBlurEffect.init(style: .light)
                }
                view.addSubview(blur)
            }
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
}
// MARK: - 给view添加手势
public extension UIView {
    /// UIView的单击事件, 一个view只能设置一次，多次设置将以最新的覆盖之前的
    @discardableResult
    func qtap(_ tap: ((_ view: UIView) -> Void)?) -> Self {
        self.qtapNumberof(touches: 1, taps: 1, tap)
        return self
    }
    /// 点击手势
    @discardableResult
    func qtapNumberof(touches: Int, taps: Int, _ tapaction: ((_ view: UIView) -> Void)?) -> Self {
        let _ = QTapGestureRecognizer.init(target: self, numberofTouches: touches, numberofTaps: taps, tapaction)
        return self
    }
    /// 点击手势
    @discardableResult
    func qtapNumberof(touches: Int, taps: Int, _ tapactionwithTap: ((_ view: UIView, _ tap: UITapGestureRecognizer) -> Void)?) -> Self {
        let tap = QTapGestureRecognizer.init(target: self, numberofTouches: touches, numberofTaps: taps, nil)
        tap.tapActionResultWithTap = tapactionwithTap
        return self
    }
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
    /// 拖动手势
    @discardableResult
    func qpanNumberof(touches min: Int, max: Int, _ panAction: ((_ view: UIView, _ pan: UIPanGestureRecognizer) -> Void)?) -> Self {
        let _ = QPanGestureRecognizer.init(target: self, minOfTouches: min, maxOfTouches: max, panAction)
        return self
    }
    /// 给UIView添加拖拽手势，可以在父视图内进行自由拖动
    /// center: 拖动开始后，视图中心点移动到手指处
    @discardableResult
    func qdrag(_ style: QPanGestureRecognizer.QDragPanStyle?, center: Bool = false,  _ panAction: ((_ view: UIView, _ pan: UIPanGestureRecognizer) -> Void)? = nil) -> Self {
        let pan = QPanGestureRecognizer.init(target: self, minOfTouches: 1, maxOfTouches: 1, panAction)
        pan.setDragInSupver(starCenter: center, dragStyle: style)
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
    /// 长按手势
    /// moveMent: 长按时，允许滑动范围，默认是10
    /// taps = 0 // 即响应长按手势之前，需要单击几次，默认0
    @discardableResult
    func qlongpress(numberof touches: Int, taps: Int = 0, minpress duration: TimeInterval, movement: CGFloat, _ action: ((_ view: UIView, _ longpress: UILongPressGestureRecognizer) -> Void)?) -> Self {
        let _ = QLongPressGestureRecognizer.init(target: self, numberofTouches: touches, numberofTaps: taps, minPressDuration: duration, movement: movement, action)
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
    /// 快速轻扫手势
    @discardableResult
    func qswipe(numberof touches: Int, direction: UISwipeGestureRecognizer.Direction, _ swipe: ((_ view: UIView, _ swipe: UISwipeGestureRecognizer) -> Void)?) -> Self {
        let _ = QSwipeGestureRecognizer.init(target: self, numberofTouches: touches, direction: direction, swipe)
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
        return self.layer.qtoImage()
    }
}

public extension UIView {
    enum QViewShowType {
        /// 优先级低，容易被拉伸或者压缩
        case low
        /// 优先级高，将不能被压缩或者拉伸
        case height
    }
    
    /// 显示优先级（完全显示，或者易被拉伸）
    /// - Parameters:
    ///   - axis: 水平或者垂直方向
    ///   - type:   low：优先级低，容易被拉伸或者压缩  height: 优先级高，将不能被压缩或者拉伸
    @discardableResult
    func qshowType(_ axis: NSLayoutConstraint.Axis, type: QViewShowType) -> Self {
        switch type {
        case .low:
            self.setContentHuggingPriority(.defaultLow, for: axis)
        case .height:
            self.setContentCompressionResistancePriority(.required, for: axis)
        }
        return self
    }
}
