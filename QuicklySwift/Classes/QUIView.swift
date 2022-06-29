//
//  QUIView.swift
//  QuicklySwift
//
//  Created by rztime on 2022/6/15.
//

import UIKit

open class QUIView: UIView {
    open weak var target: UIView?
    /// 初始值size
    open var originSize = CGSize.init(width: 0, height: 0)
    /// size改变
    open var sizeChanged: ((_ view: UIView) -> Void)?
    /// view在keywindow上是否显示（当前view所在vc在栈顶）
    open var showToWindow: ((_ view: UIView, _ showed: Bool) -> Void)?
    
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
    deinit {
        self.target?.removeObserver(self, forKeyPath: "bounds", context: nil)
        self.deinitAction?()
    }
}
