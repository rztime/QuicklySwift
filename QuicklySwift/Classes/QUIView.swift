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
    open var originSize = CGSize.init(width: -1, height: -1)
    /// view在keywindow上是否显示（当前view所在vc在栈顶）
    open var showToWindow: ((_ view: UIView, _ showed: Bool) -> Void)?
    
    open var handler: ((_ view: UIView) -> Void)?
    open var key: String = ""
    
    public init(target: UIView, key: String, changed:((_ changed: UIView) -> Void)?) {
        super.init(frame: .zero)
        self.isHidden = true
        target.addSubview(self)
        self.target = target
        self.key = key
        self.handler = changed
        if !key.isEmpty {
            self.target?.addObserver(self, forKeyPath: key, options: [.new, .old], context: nil)
        }
        self.qcontentMode(.redraw)
        self.snp.remakeConstraints { make in
            make.edges.equalToSuperview().priorityLow()
        }
    } 
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    open override func didMoveToWindow() {
        super.didMoveToWindow()
        guard let target = target else { return }
        self.showToWindow?(target, self.window != nil)
    }
    /// 监听size改变，scrollView需要使用
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let object = object as? UIView, object == self.target else { return }
        if keyPath == "bounds" && self.key == "bounds" {
            if !object.bounds.size.equalTo(originSize) {
                originSize = object.bounds.size
                self.handler?(object)
            }
        } else if keyPath == self.key {
            self.handler?(object)
        }
    }
    deinit {
        if !self.key.isEmpty {
            self.target?.removeObserver(self, forKeyPath: self.key, context: nil)
        }
    }
}
