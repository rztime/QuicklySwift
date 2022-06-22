//
//  QuickConstant.swift
//  QuicklySwift
//
//  Created by rztime on 2022/6/10.
//

import UIKit
// MARK: - 一些常量

public var qscreenwidth: CGFloat {
    return UIScreen.main.bounds.width
}
public var qscreenheight: CGFloat {
    return UIScreen.main.bounds.height
}

public extension CGRect {
    /// 屏幕满屏
    static var qfull: CGRect {
        return UIScreen.main.bounds
    }
    /// center
    var qcenter: CGPoint {
        return .init(x: self.minX + self.width / 2.0, y: self.minY + self.height / 2.0)
    }
}
public extension CGSize {
    /// 屏幕满屏size
    static var qfull: CGSize {
        return UIScreen.main.bounds.size
    }
}

/// app 的 keywindow
public var qappKeyWindow: UIWindow {
    if let window = UIApplication.shared.delegate?.window, let window = window {
        return window
    }
    if #available(iOS 13.0, *) {
        let arraySet: Set = UIApplication.shared.connectedScenes
        let windowScene: UIWindowScene? = arraySet.first(where: { sce in
            if let _ = sce as? UIWindowScene {
                return true
            }
            return false
        }) as? UIWindowScene
        if let window = windowScene?.windows.first(where: {$0.isKeyWindow}) {
            return window
        }
    }
    if let window = UIApplication.shared.windows.first(where: {$0.isKeyWindow}) {
        return window
    }
    return UIApplication.shared.keyWindow ?? .init()
}

/// app 上下左右安全距离，没有刘海屏，则顶部为状态栏高度，其余为0
public var qappSafeAreaInsets: UIEdgeInsets {
    if #available(iOS 11.0, *) {
        return qappKeyWindow.safeAreaInsets
    } else {
        return .init(top: qstatusbarHeight, left: 0, bottom: 0, right: 0)
    }
}
/// 是否是刘海屏
public var qisiPhoneNotch: Bool {
    if #available(iOS 11.0, *) {
        return qappKeyWindow.safeAreaInsets.bottom > 0
    } else {
        return false
    }
}
/// 底部安全区域 刘海屏是34， 也有21
public var qbottomSafeHeight: CGFloat {
    return qappSafeAreaInsets.bottom
}
/// 状态栏高度
/// iOS13之后，状态栏高度不固定
public var qstatusbarHeight: CGFloat {
    if #available(iOS 13.0, *),
       let height = qappKeyWindow.windowScene?.statusBarManager?.statusBarFrame.size.height {
        return height
    }
    return UIApplication.shared.statusBarFrame.size.height
}
/// 导航栏高度 44 + 状态栏高度
public var qnavigationbarHeight: CGFloat {
    return qstatusbarHeight + 44
}
/// 设备是否横屏
public var qisdeviceLandscape: Bool {
    var type: UIInterfaceOrientation = UIApplication.shared.statusBarOrientation
    if #available(iOS 13.0, *), let t = qappKeyWindow.windowScene?.interfaceOrientation {
        type = t
    }
    switch type {
    case .landscapeLeft, .landscapeRight:
        return true
    case.portrait, .portraitUpsideDown, .unknown:
        return false
    @unknown default:
        return false
    }
}
