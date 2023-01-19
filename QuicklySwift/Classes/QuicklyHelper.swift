//
//  QuicklyHelper.swift
//  QuicklySwift
//
//  Created by rztime on 2023/1/19.
//

import UIKit
import Foundation

public enum QCollectionViewSectionInsetReference: Int {
    case fromContentInset = 0
    case fromSafeArea = 1
    case fromLayoutMargins = 2
    
    @available(iOS 11.0, *)
    var toValue: UICollectionViewFlowLayout.SectionInsetReference {
        switch self {
        case .fromContentInset:
            return .fromContentInset
        case .fromSafeArea:
            return .fromSafeArea
        case .fromLayoutMargins:
            return .fromLayoutMargins
        }
    }
}

public enum QContentInsetADjustmentBehavior: Int {
    case automatic = 0
    case scrollableAxes = 1
    case never = 2
    case always = 3
    
    @available(iOS 11.0, *)
    var toValue: UIScrollView.ContentInsetAdjustmentBehavior {
        switch self {
        case .automatic:
            return .automatic
        case .scrollableAxes:
            return .scrollableAxes
        case .never:
            return .never
        case .always:
            return .always
        }
    }
}

class QuicklyObjectHelper: UIView {
    open var deinitAction: (() -> Void)?
    weak var target: NSObject?
    var handle: ((_ sender: NSObject?, _ key: String, _ value: [NSKeyValueChangeKey : Any]?) -> Void)?
    var key: String = ""
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isHidden = true
    }
    weak var targetView: UIView?
    /// view在keywindow上是否显示（当前view所在vc在栈顶）
    open var showToWindow: ((_ view: UIView, _ showed: Bool) -> Void)?

    init(targetView: UIView?) {
        super.init(frame: .zero)
        self.isHidden = true
        targetView?.addSubview(self)
        self.targetView = targetView
    }
    override func didMoveToWindow() {
        super.didMoveToWindow()
        guard let targetView = targetView else { return }
        self.showToWindow?(targetView, self.window != nil)
    }
    
    func addObs(target: NSObject?, key: String, options: NSKeyValueObservingOptions, context: UnsafeMutableRawPointer?, handle: ((_ sender: NSObject?, _ key: String, _ value: [NSKeyValueChangeKey : Any]?) -> Void)?) {
        self.key = key
        self.target = target
        self.handle = handle
        target?.addObserver(self, forKeyPath: key, options: options, context: context)
        target?.qdeinit({ [weak self] in
            guard let self = self else { return }
            self.target?.removeObserver(self, forKeyPath: key)
        })
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let object = object as? NSObject, let target = target, target == object else { return }
        if keyPath == self.key {
            self.handle?(self.target, key, change)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        self.deinitAction?()
    }
}

