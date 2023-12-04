//
//  QTapGestureRecognizer.swift
//  QuicklySwift
//
//  Created by rztime on 2022/6/27.
//

import UIKit
private var qgesturehandle: UInt8 = 1
public extension UIGestureRecognizer {
    @discardableResult
    func qhandle(_ gesture: ((_ gesture: UIGestureRecognizer) -> Void)?) -> Self {
        self.removeTarget(self, action: #selector(qgestureaction(_:)))
        self.addTarget(self, action: #selector(qgestureaction(_:)))
        self.qgesturehandleblock = gesture
        return self
    }
    private var qgesturehandleblock: ((_ gesture: UIGestureRecognizer) -> Void)? {
        set {
            objc_setAssociatedObject(self, &qgesturehandle, newValue, .OBJC_ASSOCIATION_COPY)
        }
        get {
            return objc_getAssociatedObject(self, &qgesturehandle) as? ((UIGestureRecognizer) -> Void)
        }
    }
    @objc private func qgestureaction(_ gesture: UIGestureRecognizer) {
        self.qgesturehandleblock?(gesture)
    }
}

/// 点击手势
open class QTapGestureRecognizer: UITapGestureRecognizer {
    open var tapActionResult: ((_ view: UIView) -> Void)?
    open var tapActionResultWithTap:  ((_ view: UIView, _ tap: UITapGestureRecognizer) -> Void)?
    public init(target: UIView?, numberofTouches: Int, numberofTaps: Int, _ tap:((_ view: UIView) -> Void)?) {
        super.init(target: nil, action: nil)
        self.addTarget(self, action: #selector(tapAction(_:)))
        self.tapActionResult = tap
        self.numberOfTouchesRequired = numberofTouches
        self.numberOfTapsRequired = numberofTaps
        
        guard let target = target else {
            return
        }
        target.isUserInteractionEnabled = true
        /// 将之前的重复的去掉
        let oldGesture :[UITapGestureRecognizer] = (target.gestureRecognizers?.filter({$0.isKind(of: UITapGestureRecognizer.self)}) as? [UITapGestureRecognizer]) ?? []
        oldGesture.forEach { old in
            if old.numberOfTouchesRequired == numberofTouches,
               old.numberOfTapsRequired == numberofTaps {
                target.removeGestureRecognizer(old)
            }
        }
        target.addGestureRecognizer(self)
        
        /// 如果有多个手势，则处理一下手势冲突
        var newGesture :[UITapGestureRecognizer] = (target.gestureRecognizers?.filter({$0.isKind(of: UITapGestureRecognizer.self)}) as? [UITapGestureRecognizer]) ?? []
        newGesture = newGesture.sorted(by: {$0.numberOfTapsRequired <= $1.numberOfTapsRequired && $0.numberOfTouchesRequired <= $0.numberOfTouchesRequired})
        newGesture.enumerated().forEach { tapges in
            if let next = newGesture[qsafe: tapges.offset + 1] {
                tapges.element.require(toFail: next)
            }
        }
    }
    
    @objc func tapAction(_ tap: UITapGestureRecognizer) {
        if let view = self.view {
            self.tapActionResult?(view)
            self.tapActionResultWithTap?(view, tap)
        }
    }
}
/// 拖拽手势
open class QPanGestureRecognizer: UIPanGestureRecognizer {
    /// 拖拽时，style
    public enum QDragPanStyle {
        /// 普通模式，手势停止则view停止, 如果view太靠近边界，需要修正的位置edge
        case normal(edge: UIEdgeInsets)
        /// 吸边，停止之后，自动吸附到水平（左右）靠近的一边
        case nearHorizontal(edge: UIEdgeInsets)
        /// 吸边，停止之后，自动吸附到垂直（上下）靠近的一边
        case nearVertical(edge: UIEdgeInsets)
        /// 吸边，停止之后，自动吸附到靠的最近的一边
        case nearBorder(edge: UIEdgeInsets)
    }
    open var pangestureaction: ((_ view: UIView, _ pan: UIPanGestureRecognizer) -> Void)?
    /// 在父视图中拖拽移动
    open var dragInSuperView: Bool = false
    /// 在父视图中移动时，开始时视图中心移动到手指处
    open var dragstarcenter: Bool = false
    /// 在父视图中拖拽移动，拖拽的style
    open var dragPanStyle: QDragPanStyle?
    
    public init(target: UIView?, minOfTouches: Int, maxOfTouches: Int, _ pan:((_ view: UIView, _ pan: UIPanGestureRecognizer) -> Void)?) {
        super.init(target: nil, action: nil)
        self.addTarget(self, action: #selector(pangesture(_:)))
        self.pangestureaction = pan
        self.minimumNumberOfTouches = minOfTouches
        self.maximumNumberOfTouches = maxOfTouches
        
        guard let target = target else {
            return
        }
        target.isUserInteractionEnabled = true
        /// 将之前的重复的去掉
        let oldGesture :[UIPanGestureRecognizer] = (target.gestureRecognizers?.filter({$0.isKind(of: UIPanGestureRecognizer.self)}) as? [UIPanGestureRecognizer]) ?? []
        oldGesture.forEach { old in
            if old.minimumNumberOfTouches == minOfTouches,
               old.maximumNumberOfTouches == maxOfTouches {
                target.removeGestureRecognizer(old)
            }
        }
        target.addGestureRecognizer(self)
        
        /// 如果有多个手势，则处理一下手势冲突
        var newGesture : [UIPanGestureRecognizer] = (target.gestureRecognizers?.filter({$0.isKind(of: UIPanGestureRecognizer.self)}) as? [UIPanGestureRecognizer]) ?? []
        newGesture = newGesture.sorted(by: {$0.minimumNumberOfTouches <= $1.minimumNumberOfTouches && $0.maximumNumberOfTouches <= $0.maximumNumberOfTouches})
        newGesture.enumerated().forEach { tapges in
            if let next = newGesture[qsafe: tapges.offset + 1] {
                tapges.element.require(toFail: next)
            }
        }
    }
    /// 设置手势所在视图，在父视图可以自由拖拽
    public func setDragInSupver(starCenter: Bool, dragStyle: QDragPanStyle?) {
        self.dragInSuperView = true
        self.dragstarcenter = starCenter
        self.dragPanStyle = dragStyle
    }
    @objc func pangesture(_ pan: UIPanGestureRecognizer) {
        guard let view = self.view else {
            return
        }
        self.pangestureaction?(view, pan)
        guard dragInSuperView, let transView = view.superview else { return }
        switch pan.state {
        case .began:
            if dragstarcenter {
                let point = pan.location(in: transView)
                view.center = point
            }
        case .changed:
            let point = pan.translation(in: view)
            view.center = .init(x: view.center.x + point.x, y: view.center.y + point.y)
        case .ended, .failed, .cancelled:
            self.near()
        default: break
        }
        pan.setTranslation(.zero, in: view)
    }
    // MARK: - 更新位置，结束之后，判断是否需要吸边
    public func near() {
        guard let dragPanStyle = dragPanStyle, let target = self.view, let transView = target.superview else {
            return
        }
        var endFrame = target.frame
        
        let targetframe = target.frame
        let transViewframe = transView.frame
        
        let left: CGFloat = CGFloat(abs(Int32(targetframe.minX)))
        let right: CGFloat = CGFloat(abs(Int32(targetframe.maxX - transViewframe.width)))
        
        let top: CGFloat = CGFloat(abs(Int32(targetframe.minY)))
        let bottom: CGFloat = CGFloat(abs(Int32(targetframe.maxY - transViewframe.height)))
        
        func horizontal(edge: UIEdgeInsets) {
            var x: CGFloat = 0
            var y: CGFloat = targetframe.minY
            if left <= right {
                x = edge.left
            } else {
                x = transViewframe.width - edge.right - targetframe.width
            }
            if y < edge.top {
                y = edge.top
            }
            if y > transViewframe.height - edge.bottom - targetframe.height {
                y = transViewframe.height - edge.bottom - targetframe.height
            }
            endFrame.origin.x = x
            endFrame.origin.y = y
        }
        func vertical(edge: UIEdgeInsets) {
            var x: CGFloat = targetframe.minX
            var y: CGFloat = 0
            if top <= bottom {
                y = edge.top
            } else {
                y = transViewframe.height - edge.bottom - targetframe.height
            }
            if x < edge.left {
                x = edge.left
            }
            if x > transViewframe.width - edge.right - targetframe.width {
                x = transViewframe.width - edge.right - targetframe.width
            }
            endFrame.origin.x = x
            endFrame.origin.y = y
        }
        
        switch dragPanStyle {
        case .normal(let edge):
            if endFrame.minY < edge.top {
                endFrame.origin.y = edge.top
            }
            if endFrame.minY > transViewframe.height - edge.bottom - targetframe.height {
                endFrame.origin.y = transViewframe.height - edge.bottom - targetframe.height
            }
            if endFrame.minX < edge.left {
                endFrame.origin.x = edge.left
            }
            if endFrame.minX > transViewframe.width - edge.right - targetframe.width {
                endFrame.origin.x = transViewframe.width - edge.right - targetframe.width
            }
        case .nearHorizontal(let edge):
            horizontal(edge: edge)
        case .nearVertical(let edge):
            vertical(edge: edge)
        case .nearBorder(let edge):
            let min = [left, top, right, bottom].min()
            if top == min || bottom == min {
                vertical(edge: edge)
            } else {
                horizontal(edge: edge)
            }
        }
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            target.frame = endFrame
        } completion: { _ in
            
        }
    }
}
/// 长按手势
open class QLongPressGestureRecognizer: UILongPressGestureRecognizer {
    open var longPressActionResult: ((_ view: UIView, _ longpress: UILongPressGestureRecognizer) -> Void)?
    
    public init(target: UIView?, numberofTouches: Int, numberofTaps: Int, minPressDuration: TimeInterval, movement: CGFloat, _ longpressAction:((_ view: UIView, _ longpress: UILongPressGestureRecognizer) -> Void)?) {
        super.init(target: nil, action: nil)
        self.addTarget(self, action: #selector(longpressAction(_:)))
        self.longPressActionResult = longpressAction
        self.numberOfTouchesRequired = numberofTouches
        self.numberOfTapsRequired = numberofTaps
        self.minimumPressDuration = minPressDuration
        self.allowableMovement = movement
        
        guard let target = target else {
            return
        }
        target.isUserInteractionEnabled = true
        /// 将之前的重复的去掉
        let oldGesture :[UILongPressGestureRecognizer] = (target.gestureRecognizers?.filter({$0.isKind(of: UILongPressGestureRecognizer.self)}) as? [UILongPressGestureRecognizer]) ?? []
        oldGesture.forEach { old in
            if old.numberOfTouchesRequired == numberofTouches,
               old.numberOfTapsRequired == numberofTaps {
                target.removeGestureRecognizer(old)
            }
        }
        target.addGestureRecognizer(self)
        
        /// 如果有多个手势，则处理一下手势冲突
        var newGesture :[UILongPressGestureRecognizer] = (target.gestureRecognizers?.filter({$0.isKind(of: UILongPressGestureRecognizer.self)}) as? [UILongPressGestureRecognizer]) ?? []
        newGesture = newGesture.sorted(by: {$0.numberOfTapsRequired <= $1.numberOfTapsRequired && $0.numberOfTouchesRequired <= $0.numberOfTouchesRequired})
        newGesture.enumerated().forEach { tapges in
            if let next = newGesture[qsafe: tapges.offset + 1] {
                tapges.element.require(toFail: next)
            }
        }
    }
    
    @objc func longpressAction(_ long: UILongPressGestureRecognizer) {
        if let view = self.view {
            self.longPressActionResult?(view, long)
        }
    }
}
/// 快速轻扫手势
open class QSwipeGestureRecognizer : UISwipeGestureRecognizer {
    open var swipeActionResult: ((_ view: UIView, _ swipe: UISwipeGestureRecognizer) -> Void)?
    
    public init(target: UIView?, numberofTouches: Int, direction: UISwipeGestureRecognizer.Direction, _ swipe: ((_ view: UIView, _ swipe: UISwipeGestureRecognizer) -> Void)?) {
        super.init(target: nil, action: nil)
        self.addTarget(self, action: #selector(swipeAction(_:)))
        self.swipeActionResult = swipe
        self.numberOfTouchesRequired = numberofTouches
        self.direction = direction
        
        guard let target = target else {
            return
        }
        target.isUserInteractionEnabled = true
        /// 将之前的重复的去掉
        let oldGesture :[UISwipeGestureRecognizer] = (target.gestureRecognizers?.filter({$0.isKind(of: UISwipeGestureRecognizer.self)}) as? [UISwipeGestureRecognizer]) ?? []
        oldGesture.forEach { old in
            if old.numberOfTouchesRequired == numberofTouches, old.direction == direction {
                target.removeGestureRecognizer(old)
            }
        }
        target.addGestureRecognizer(self)
        
        /// 如果有多个手势，则处理一下手势冲突
        var newGesture :[UISwipeGestureRecognizer] = (target.gestureRecognizers?.filter({$0.isKind(of: UISwipeGestureRecognizer.self)}) as? [UISwipeGestureRecognizer]) ?? []
        newGesture = newGesture.sorted(by: {$0.numberOfTouchesRequired <= $1.numberOfTouchesRequired })
        newGesture.enumerated().forEach { tapges in
            if let next = newGesture[qsafe: tapges.offset + 1] {
                tapges.element.require(toFail: next)
            }
        }
    }
    
    @objc func swipeAction(_ swipe: UISwipeGestureRecognizer) {
        if let view = self.view {
            self.swipeActionResult?(view, swipe)
        }
    }
}
