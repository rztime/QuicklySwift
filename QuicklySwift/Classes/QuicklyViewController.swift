//
//  QuicklyViewController.swift
//  QuicklySwift
//
//  Created by rztime on 2022/6/6.
//

import UIKit

public extension UIViewController {
    /// 获取当前显示的最顶层的viewcontroller
    @discardableResult
    class func qtopViewController(_ base: UIViewController? = qappKeyWindow.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return qtopViewController(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            return qtopViewController(tab.selectedViewController)
        }
        if let presented = base?.presentedViewController {
            return qtopViewController(presented)
        }
        return base
    }
    /// present时，取用的viewcontroller
    @discardableResult
    func qcanPresentViewController() -> UIViewController? {
        if let tb = self.tabBarController {
            return tb
        }
        if let vc = self.navigationController?.viewControllers, vc.count == 1, let tb = self.tabBarController {
            return tb
        }
        return self
    }
}
// MARK: - UIViewController 生命周期
public extension UIViewController {
    /// 被pop出去的时候，会回调此方法
    @discardableResult
    func qdidpop(_ pop: (() -> Void)?) -> Self {
        let vc = QViewControllerHelper.init(target: self, times: 0)
        vc.didpop = pop
        return self
    }
    /// 将要显示  exeCount: 表示方法回调次数，超过count之后，不在回调  0不限次数
    @discardableResult
    func qwillAppear(_ exeCount: Int = 0, _ appear: (() -> Void)?) -> Self {
        let vc = QViewControllerHelper.init(target: self, times: exeCount)
        vc.willAppear = appear
        return self
    }
    /// 已经显示   exeCount: 表示方法回调次数，超过count之后，不在回调 0不限次数
    @discardableResult
    func qdidAppear(_ exeCount: Int = 0, _ appear: (() -> Void)?) -> Self {
        let vc = QViewControllerHelper.init(target: self, times: exeCount)
        vc.didAppear = appear
        return self
    }
    /// 将要消失  exeCount: 表示方法回调次数，超过count之后，不在回调 0不限次数
    @discardableResult
    func qwillDisAppear(_ exeCount: Int = 0, _ appear: (() -> Void)?) -> Self {
        let vc = QViewControllerHelper.init(target: self, times: exeCount)
        vc.willDisAppear = appear
        return self
    }
    /// 已经消失  exeCount: 表示方法回调次数，超过count之后，不在回调 0不限次数
    @discardableResult
    func qdidDisAppear(_ exeCount: Int = 0, _ appear: (() -> Void)?) -> Self {
        let vc = QViewControllerHelper.init(target: self, times: exeCount)
        vc.didDisAppear = appear
        return self
    }
}

open class QViewControllerHelper: UIViewController {
    open var didpop: (() -> Void)?
    open var willAppear: (() -> Void)?
    open var didAppear: (() -> Void)?
    open var willDisAppear: (() -> Void)?
    open var didDisAppear: (() -> Void)?
    
    open var times: Int = 0
    
    private var exetimes: Int = 0
    
    private var popTimes: Int = 0
    
    ///   - times: 可执行次数，不限次数为0，限制次数 > 0
    public init(target: UIViewController, times: Int = 0) {
        super.init(nibName: nil, bundle: nil)
        self.times = times
        // 主线程放置，是为了避免在push之前，target先执行了viewDidLoad
        DispatchQueue.main.async {
            target.addChild(self)
            target.view.addSubview(self.view)
        }
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.isHidden = true
    }
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if times > 0, exetimes >= times {
            return
        }
        if let willAppear = willAppear {
            willAppear()
            exetimes += 1
        }
    }
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if times > 0, exetimes >= times {
            return
        }
        if let didAppear = didAppear {
            didAppear()
            exetimes += 1
        }
    }
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if times > 0, exetimes >= times {
            return
        }
        if let willDisAppear = willDisAppear {
            willDisAppear()
            exetimes += 1
        }
    }
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        defer {
            if let parent = self.parent {
                if let _ = qAppFrame.viewControllers.first(where: {$0 == parent}) {
                    
                } else {
                    if popTimes == 0 {
                        self.didpop?()
                        popTimes += 1
                    }
                }
            }
        }
        if times > 0, exetimes >= times {
            return
        }
        if let didDisAppear = didDisAppear {
            didDisAppear()
            exetimes += 1
        }
    }
    deinit {
        if popTimes == 0 {
            self.didpop?()
            popTimes += 1
        }
    }
}
