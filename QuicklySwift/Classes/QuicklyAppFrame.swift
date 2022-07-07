//
//  QuicklyAppFrame.swift
//  QuicklySwift
//
//  Created by rztime on 2022/6/15.
//

import UIKit

private var ispushinganimate: Bool = false
/// 整体框架
public struct qAppFrame {
    /// 当前显示的主navigationController
    public static var navigationController: UINavigationController? {
        return UIViewController.qtopViewController()?.navigationController
    }
    /// 获取当前显示的vc栈里，所有的viewcontrollers
    public static var viewControllers: [UIViewController] {
        return self.navigationController?.viewControllers ?? []
    }
    /// push跳转vc,忽略重复的跳转vc， 在vc未跳转完成之前，如果又push一个vc，且和之前是同一个类，将忽略第二个
    public static func pushViewController(_ vc: UIViewController?, animated: Bool = true) {
        guard let vc = vc else { return }
        if ispushinganimate {
            /// 有时候卡顿，或者回调多次，致使一次性跳转多次同一个vc，这里将做处理
            let vcs = self.viewControllers
            if let res = vcs.last?.isKind(of: vc.classForCoder), res {
                return
            }
        }
        ispushinganimate = true
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: animated)
        /// 当加载显示出来之后，解除标记
        vc.qdidAppear(1) {
            ispushinganimate = false
        }
    }
    /// present跳转vc
    public static func present(_ vc: UIViewController, animated: Bool, completion: (() -> Void)?) {
        vc.hidesBottomBarWhenPushed = true
        UIViewController.qtopViewController()?.qcanPresentViewController()?.present(vc, animated: animated, completion: completion)
    }
    
    public static func popViewController(animated: Bool) {
        self.navigationController?.popViewController(animated: animated)
    }
    public static func popToViewController(_ viewController: UIViewController, animated: Bool) {
        self.navigationController?.popToViewController(viewController, animated: animated)
    }

    /// 从当前栈里移除viewcontroller
    /// animate：是否需要动画，如果移除的是顶端的，会有一个pop动画
    /// 如果是A push B 过程中 移除 A，B此时还没有显示，移除了A，则B也将不在栈里，那么push B时使用方法qAppFrame.pushViewController(B, true)可以解决问题
    public static func remove(viewController: UIViewController, animate: Bool) {
        if ispushinganimate {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.remove(viewController: viewController, animate: animate)
            }
            return
        }
        var vcs = self.viewControllers
        if let index = vcs.firstIndex(where: {$0.isEqual(viewController)}) {
            vcs.remove(at: index)
            self.navigationController?.setViewControllers(vcs, animated: animate)
        }
    }
    /// 从当前栈里移除vc, 如果有多个vc，则移除最顶上的一个
    /// animate：是否需要动画，如果移除的是顶端的，会有一个pop动画
    /// 如果是A push B 过程中 移除 A，B此时还没有显示，移除了A，则B也将不在栈里，那么push B时使用方法qAppFrame.pushViewController(B, true)可以解决问题
    public static func remove(viewControllerClass: AnyClass, animate: Bool) {
        if ispushinganimate {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.remove(viewControllerClass: viewControllerClass, animate: animate)
            }
            return
        }
        var vcs = self.viewControllers
        if let index = vcs.lastIndex(where: {$0.isKind(of: viewControllerClass)}) {
            vcs.remove(at: index)
            self.navigationController?.setViewControllers(vcs, animated: animate)
        }
    }
}
