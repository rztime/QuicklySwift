//
//  QuicklyViewAnimation.swift
//  QuicklySwift
//
//  Created by rztime on 2022/6/14.
//

import UIKit

public enum QTransformAnimate {
    /// 没有动画
    case none
    /// 有动画，及动画时长
    case animate(_ time: TimeInterval, delay: TimeInterval, options: UIView.AnimationOptions)
}
// MARK: - 动画相关的
public extension UIView {
    /// view抖动动画
    /// - Parameters:
    ///   - time: 抖动一个周期时长
    ///   - value: 抖动弧度  0 - 360 是一周
    ///   - count: 重复次数
    @discardableResult
    func qshake(_ time: TimeInterval = 1, _ value: Double = 10, repeatcount: Float = MAXFLOAT) -> Self {
        self.layer.qshake(time, value, repeatcount: repeatcount)
        return self
    }
    
    /// 原地旋转动画，可循环 0 to 360，为旋转一圈
    /// - Parameters:
    ///   - from: 初始角度 0  360
    ///   - to: 结束角度
    ///   - duration: 一个周期时长
    ///   - repeatcount: 重复次数
    @discardableResult
    func qrotation(from: CGFloat, to: CGFloat, duration: TimeInterval, repeatcount: Float = Float.greatestFiniteMagnitude) -> Self {
        self.layer.qrotation(from: from, to: to, duration: duration, repeatcount: repeatcount)
        return self
    }
}
// MARK: - 位移、旋转、缩放相关的
public extension QuicklyProtocal where Self: UIView {
    /// 旋转一定角度
    /// - Parameters:
    ///   - value: 旋转角度 0度 360度
    ///   - animation: 是否动画 以及动画时长
    ///   - complete: 完成回调
    @discardableResult
    func qtransform(rotation: CGFloat, _ animate: QTransformAnimate = .none, complete: ((_ view: Self) -> Void)? = nil) -> Self {
        switch animate {
        case .none:
            self.transform = CGAffineTransform.init(rotationAngle: rotation * .pi / 180.0)
            complete?(self)
        case .animate(let time, let delay, let options):
            UIView.animate(withDuration: time, delay: delay, options: options) { [weak self] in
                self?.transform = CGAffineTransform.init(rotationAngle: rotation * .pi / 180.0)
            } completion: { [weak self] _ in
                guard let self = self else { return }
                complete?(self)
            }
        }
        return self
    }
    /// 移动
    /// - Parameters:
    ///   - value: 旋转角度 0度 360度
    ///   - animation: 是否动画 以及动画时长
    ///   - complete: 完成回调
    @discardableResult
    func qtransform(x: CGFloat, y: CGFloat, _ animate: QTransformAnimate = .none, complete: ((_ view: Self) -> Void)? = nil) -> Self {
        switch animate {
        case .none:
            self.transform = CGAffineTransform.init(translationX: x, y: y)
            complete?(self)
        case .animate(let time, let delay, let options):
            UIView.animate(withDuration: time, delay: delay, options: options) { [weak self] in
                self?.transform = CGAffineTransform.init(translationX: x, y: y)
            } completion: { [weak self] _ in
                guard let self = self else { return }
                complete?(self)
            }
        }
        return self
    }
    /// 缩放/放大 倍数
    /// - Parameters:
    ///   - x: x轴放大倍速
    ///   - y: y轴放大倍速
    ///   - animate: 是否动画
    ///   - complete: 回调
    @discardableResult
    func qtransform(scale x: CGFloat, _ y: CGFloat, _ animate: QTransformAnimate = .none, complete: ((_ view: Self) -> Void)? = nil) -> Self {
        switch animate {
        case .none:
            self.transform = CGAffineTransform.init(scaleX: x, y: y)
            complete?(self)
        case .animate(let time, let delay, let options):
            UIView.animate(withDuration: time, delay: delay, options: options) { [weak self] in
                self?.transform = CGAffineTransform.init(scaleX: x, y: y)
            } completion: { [weak self] _ in
                guard let self = self else { return }
                complete?(self)
            }
        }
        return self
    }
    /// 自定义transform
    @discardableResult
    func qtransform(animate: QTransformAnimate = .none, transform: (() -> CGAffineTransform), complete: ((_ view: Self) -> Void)? = nil) -> Self {
        let trans = transform()
        switch animate {
        case .none:
            self.transform = trans
            complete?(self)
        case .animate(let time, let delay, let options):
            UIView.animate(withDuration: time, delay: delay, options: options) { [weak self] in
                self?.transform = trans
            } completion: { [weak self] _ in
                guard let self = self else { return }
                complete?(self)
            }
        }
        return self
    }
}
