//
//  QUIView.swift
//  QuicklySwift
//
//  Created by rztime on 2022/6/15.
//

import UIKit

open class QUIView: UIView {
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
    open weak var target: UIView?
    /// 初始值size
    open var originSize = CGSize.init(width: 0, height: 0)
    /// size改变
    open var sizeChanged: ((_ view: UIView) -> Void)?
    /// view在keywindow上是否显示（当前view所在vc在栈顶）
    open var showToWindow: ((_ view: UIView, _ showed: Bool) -> Void)?
    /// 手势点击
    var gesture: UITapGestureRecognizer?
    /// 手势点击事件回调
    open var tapAction: ((_ view: UIView) -> Void)? {
        didSet {
            if let gestrue = self.gesture {
                self.removeGestureRecognizer(gestrue)
            }
            if let _ = tapAction {
                let gesture = UITapGestureRecognizer.init(target: self, action: #selector(didTapAction))
                gesture.numberOfTapsRequired = 1
                gesture.numberOfTouchesRequired = 1
                self.target?.addGestureRecognizer(gesture)
                self.gesture = gesture
                self.target?.isUserInteractionEnabled = true
                let staci = UIStackView()
                staci.qaxis(.vertical)
            } else {
                self.gesture = nil
            }
        }
    }
    /// 拖拽手势
    var pangesture: UIPanGestureRecognizer?
    /// 拖拽手势风格
    open var dragPanStyle: QDragPanStyle? {
        didSet {
            if let pangesture = pangesture {
                self.target?.removeGestureRecognizer(pangesture)
            }
            guard let _ = dragPanStyle else {
                return
            }
            if pangesture == nil {
                pangesture = UIPanGestureRecognizer.init(target: self, action: #selector(dragView(_ :)))
            }
            if let pangesture = pangesture {
                self.target?.addGestureRecognizer(pangesture)
                self.target?.isUserInteractionEnabled = true
            }
        }
    }
    /// 手指拖动开始时，是否需要视图中心点居手指中
    var dragStarCenter: Bool = false
    
    open var deinitAction: (() -> Void)?
    public init(target: UIView) {
        self.target = target
        super.init(frame: .zero)
        target.addSubview(self)
        self.qcontentMode(.redraw)
        self.snp.remakeConstraints { make in
            make.edges.equalToSuperview().priorityLow()
        }
        self.isHidden = true
        if let _ = target as? UIScrollView {
            self.target?.addObserver(self, forKeyPath: "bounds", options: [.new, .old], context: nil)
        }
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        changedSizeIfNeed()
    }
    open override func didMoveToWindow() {
        super.didMoveToWindow()
        guard let target = target else { return }
        self.showToWindow?(target, self.window != nil)
    }
    /// 改变了size之后是否需要回调
    func changedSizeIfNeed() {
        guard let superv = self.target else { return }
        let newSize = superv.frame.size
        if newSize.equalTo(originSize) { return }
        originSize = newSize
        self.sizeChanged?(superv)
    }
    /// 监听size改变，scrollView需要使用
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let object = object as? UIView, object == self.target else { return }
        self.changedSizeIfNeed()
    }
    /// 单击手势
    @objc open func didTapAction() {
        if let target = target {
            tapAction?(target)
        }
    }
    /// 拖拽手势响应
    @objc open func dragView(_ gesture: UIPanGestureRecognizer) {
        guard let target = target, let transView = target.superview else {
            return
        }
        switch gesture.state {
        case .began:
            /// 使手指在view中间
            if dragStarCenter {
                let point = gesture.location(in: transView)
                target.center = point
            }
        case .changed:
            let point = gesture.translation(in: target)
            target.center = CGPoint(x: target.center.x + point.x, y: target.center.y + point.y)
        case .ended:
            // 移动结束后,重置center坐标点
            self.near()
        default: break
        }
        gesture.setTranslation(.zero, in: target)
    }
    // MARK: - 更新位置，结束之后，判断是否需要吸边
    private func near() {
        guard let dragPanStyle = dragPanStyle, let target = target, let transView = target.superview else {
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
    deinit {
        self.target?.removeObserver(self, forKeyPath: "bounds", context: nil)
        self.deinitAction?()
    }
}
