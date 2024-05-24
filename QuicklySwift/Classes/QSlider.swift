//
//  QSlider.swift
//  QuicklySwift
//
//  Created by rztime on 2024/5/21.
//

import UIKit
/// 用于配置滑块的大小和圆角
open class QViewOptions {
    /// 手指区size
    open var thumbSize: CGSize = .init(width: 15, height: 15) { didSet { self.layout?() }}
    /// 手指区圆角，< 0 为半圆角
    open var thumbCornerRadius: CGFloat = -1 { didSet { self.layout?() }}
    /// 滑条的高度，竖向为宽度
    open var sliderHeight: CGFloat = 3 { didSet { self.layout?() }}
    /// 滑条圆角，< 0 为半圆角
    open var sliderCornerRadius: CGFloat = -1 { didSet { self.layout?() }}
    /// 刷新
    var layout: (() -> Void)?
    /// 刷新
    public func reload() {
        self.layout?()
    }
    /// 手指区圆角
    open func tbc(direction: NSLayoutConstraint.Axis) -> CGFloat {
        if thumbCornerRadius < 0 {
            if direction == .horizontal { return thumbSize.height / 2.0}
            return thumbSize.width / 2.0
        }
        return thumbCornerRadius
    }
    /// 滑条圆角
    open func sbc(direction: NSLayoutConstraint.Axis) -> CGFloat {
        if sliderCornerRadius < 0 {
            return sliderHeight / 2.0
        }
        return sliderCornerRadius
    }
}
/// 滑块
open class QSlider: UIView {
    public enum Event {
        /// 只要值发生改变，就有事件
        case valueChanged
        /// 只有手势退拽，才有事件
        case valueChangedByThumb
        /// 手势开始
        case thumbStar
        /// 手势结束，才有事件
        case thumbEnd
    }
    private var _value: CGFloat = 0
    /// 配置大小、圆角
    open var options: QViewOptions = .init()
    /// 0.0 - 1.0
    open var value: CGFloat {
        get { return _value }
        set { self.setValue(newValue, animate: false) }
    }
    /// 手势进行中
    open var isTracking: Bool = false
    /// 手指触控view
    open var thumbView: UIImageView = .init().qbackgroundColor(.white).qborder(.qhex(0x000000, a: 0.2), 1)
    /// thumbView左侧的view, 可以设置背景色、gif等等
    open var minView: UIImageView = .init().qbackgroundColor(.blue)
    /// thumbView右侧的view, 可以设置背景色、gif等等
    open var maxView: UIImageView = .init().qbackgroundColor(.lightGray)
    /// 线条view，用于包含minView，maxView，设置圆角等等
    open var lineBackgroundView: UIView = .init()
    /// 横向滑动
    open var direction: NSLayoutConstraint.Axis = .horizontal { didSet { self.setNeedsLayout() } }
    /// 记录事件
    open var events: [QSliderEvent] = []
    /// 添加事件
    @discardableResult
    open func qaction(for event: QSlider.Event, block: ((_ sender: Self) -> Void)?) -> Self  {
        let helper = QSliderEvent(event: event) { [weak self] in
            guard let self = self else { return }
            block?(self)
        }
        self.events.append(helper)
        return self
    }
    /// 设置
    open func setValue(_ value: CGFloat, animate: Bool) {
        self.setValue(value, animate: animate, ifNeed: false)
    }
    public init(frame: CGRect, direction: NSLayoutConstraint.Axis = .horizontal) {
        super.init(frame: frame)
        self.direction = direction
        self.options.layout = { [weak self] in
            self?.setNeedsLayout()
        }
        self.qcornerRadius(0, false)

        self.qbody([
            lineBackgroundView.qbody([maxView, minView]),
            thumbView,
        ])
        self.qpanNumberof(touches: 1, max: 1) { [weak self] view, pan in
            guard let self = self else { return }
            switch pan.state {
            case .began:
                self.isTracking = true
                /// 事件通知
                self.events.filter({$0.event == .thumbStar}).forEach({$0.block?()})
            case .changed:
                let point = pan.translation(in: view)
                var value = self._value
                switch self.direction {
                case .horizontal:
                    value = (self.thumbView.frame.minX + point.x) / (self.frame.size.width - self.options.thumbSize.width)
                case .vertical:
                    value = (self.thumbView.frame.minY + point.y) / (self.frame.size.height - self.options.thumbSize.height)
                @unknown default:
                    break
                }
                value = min(1, max(0, value))
                self.setValue(value, animate: false, ifNeed: true)
            case .ended, .cancelled, .failed, .possible:
                self.isTracking = false
                /// 事件通知
                self.events.filter({$0.event == .thumbEnd}).forEach({$0.block?()})
            @unknown default:
                break
            }
            pan.setTranslation(.zero, in: view)
        }
    }
    open func reload() {
        self.lineBackgroundView.frame = .init(x: 0, y: 0, width: self.direction == .horizontal ? self.frame.size.width : self.options.sliderHeight, height: self.direction == .horizontal ? self.options.sliderHeight : self.frame.size.height)
        self.lineBackgroundView.qcenter(self.bounds.qcenter)
        self.lineBackgroundView.qcornerRadius(self.options.sbc(direction: self.direction), true)
        self.maxView.frame = self.lineBackgroundView.bounds
        self.minView.frame = self.lineBackgroundView.bounds
        self.thumbView.qsize(self.options.thumbSize)
        self.thumbView.qcenter(self.bounds.qcenter)
        self.thumbView.qcornerRadius(self.options.tbc(direction: self.direction), true)
        self.setValue(self._value, animate: false)
    }
    open override func layoutSubviews() {
        super.layoutSubviews()
        reload()
    }
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let a = self.convert(point, to: thumbView)
        let width = min(self.frame.width, self.frame.height) + 20
        let bounds = CGRect(x: -10, y: -10, width: width, height: width)
        if bounds.contains(a) {
            return thumbView
        }
        return nil
    }
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
public extension QSlider {
    /// 设置value， ifNeed: 是否强制设置，false时且在滑动isTracking时就不设置
    func setValue(_ value: CGFloat, animate: Bool, ifNeed: Bool) {
        if !ifNeed && isTracking {
            return
        }
        var value = min(1, value)
        value = max(0, value)
        let valueChanged = value != _value
        _value = value
        /// 事件通知
        if valueChanged {
            self.events.filter({ $0.event == .valueChanged || (isTracking && $0.event == .valueChangedByThumb) }).forEach({$0.block?()})
        }
        var minsize = self.minView.frame.size
        var point: CGPoint = .zero
        let thumbViewSize = self.thumbView.frame.size
        switch direction {
        case .horizontal:
            point.x = (self.frame.size.width - thumbViewSize.width) * value
            point.y = self.thumbView.frame.origin.y
            if value == 0 { minsize.width = 0 }
            else if value == 1 { minsize.width = self.frame.size.width }
            else { minsize.width = point.x + thumbViewSize.width * 0.5 }
        case .vertical:
            point.x = self.thumbView.frame.origin.x
            point.y = (self.frame.size.height - thumbViewSize.height) * value
            if value == 0 { minsize.height = 0 }
            else if value == 1 { minsize.height = self.frame.size.height }
            else { minsize.height = point.y + thumbViewSize.height * 0.5 }
        @unknown default: return;
        }
        if !animate {
            self.thumbView.qx(point.x).qy(point.y)
            self.minView.qsize(minsize)
            return
        }
        UIView.animate(withDuration: 0.3, delay: 0) { [weak self] in
            guard let self = self else { return }
            self.thumbView.qx(point.x).qy(point.y)
            self.minView.qsize(minsize)
        }
    }
}
public class QSliderEvent {
    public var event: QSlider.Event
    public var block: (() -> Void)?
    public var block1: (() -> Bool)?
    init(event: QSlider.Event, block: ( () -> Void)? = nil) {
        self.event = event
        self.block = block
    }
}
