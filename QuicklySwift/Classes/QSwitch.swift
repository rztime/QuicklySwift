//
//  QSwitch.swift
//  QuicklySwift
//
//  Created by rztime on 2024/5/22.
//

import UIKit
/// 开关
open class QSwitch: UIView {
    private var _isOn: Bool = false
    /// 配置大小、圆角
    open var options: QViewOptions = .init()
    /// 0.0 - 1.0
    open var isOn: Bool {
        get { return _isOn }
        set { self.setIsOn(newValue, animate: true) }
    }
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
    open func qactionForValueChanged(block: ((_ sender: Self) -> Void)?) -> Self  {
        let helper = QSliderEvent(event: .valueChanged) { [weak self] in
            guard let self = self else { return }
            block?(self)
        }
        self.events.append(helper)
        return self
    }
    @discardableResult
    open func qactionForValueWillChange(block: ((_ sender: Self) -> Bool)?) -> Self  {
        let helper = QSliderEvent.init(event: .thumbStar)
        if let block = block {
            helper.block1 = { [weak self] in
                guard let self = self else { return true}
                return block(self)
            }
        }
        self.events.append(helper)
        return self
    }
    /// 设置
    open func setIsOn(_ isOn: Bool, animate: Bool) {
        let valueChanged = isOn != _isOn
        _isOn = isOn
        /// 事件通知
        if valueChanged {
            self.events.filter({ $0.event == .valueChanged }).forEach({$0.block?()})
        }
        var minsize = self.minView.frame.size
        var point: CGPoint = .zero
        let thumbViewSize = self.thumbView.frame.size
        switch direction {
        case .horizontal:
            point.x = (self.frame.size.width - thumbViewSize.width) * (isOn ? 1 : 0)
            point.y = self.thumbView.frame.origin.y
            if isOn == false { minsize.width = 0 }
            else if isOn == true { minsize.width = self.frame.size.width }
        case .vertical:
            point.x = self.thumbView.frame.origin.x
            point.y = (self.frame.size.height - thumbViewSize.height) * (isOn ? 1 : 0)
            if isOn == false { minsize.height = 0 }
            else if isOn == true { minsize.height = self.frame.size.height }
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
    public init(frame: CGRect, direction: NSLayoutConstraint.Axis = .horizontal) {
        super.init(frame: frame)
        self.qcornerRadius(0, false)
        self.direction = direction
        self.options.layout = { [weak self] in
            self?.setNeedsLayout()
        }
        self.qbody([
            lineBackgroundView.qbody([maxView, minView]),
            thumbView,
        ])
        self.qtap { [weak self] view in
            guard let self = self else { return }
            if let will = self.events.first(where: {$0.event == .thumbStar}), will.block1?() == false {
                return
            }
            let v = self._isOn
            self.setIsOn(!v, animate: true)
        }
    }
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    open override func layoutSubviews() {
        super.layoutSubviews()
        reload()
    }
    open func reload() {
        self.lineBackgroundView.frame = .init(x: 0, y: 0, width: self.direction == .horizontal ? self.frame.size.width : self.options.sliderHeight, height: self.direction == .horizontal ? self.options.sliderHeight : self.frame.size.height)
        self.lineBackgroundView.qcenter(self.bounds.qcenter)
        self.lineBackgroundView.qcornerRadius(self.options.sbc(direction: self.direction), true)
        self.maxView.frame = self.lineBackgroundView.bounds
        self.minView.frame = .init(x: 0, y: 0, width: self.direction == .horizontal ? 0 : self.lineBackgroundView.bounds.width, height: self.direction == .horizontal ? self.lineBackgroundView.bounds.height : 0)
        self.thumbView.qsize(self.options.thumbSize)
        self.thumbView.qcenter(self.bounds.qcenter)
        self.thumbView.qcornerRadius(self.options.tbc(direction: self.direction), true)
        self.setIsOn(self._isOn, animate: false)
    }
}
