//
//  QuicklyNotification.swift
//  QuicklySwift
//
//  Created by rztime on 2022/11/3.
//

import UIKit
import Foundation

public extension NotificationCenter {
    /// 添加一个监听，target释放时，释放监听
    func qaddObserver(name: Notification.Name?, object: Any?, target: NSObject?, block: ((_ notification: Notification) -> Void)?) {
        let helper = QNotificationHelper.init()
        helper.block = { notification in
            block?(notification)
        }
        target?.qdeinit({
            NotificationCenter.default.removeObserver(helper)
        })
        NotificationCenter.default.addObserver(helper, selector: #selector(QNotificationHelper.notificationAction(_:)), name: name, object: object)
    }
    /// 添加一个监听，target释放时，释放监听
    class func qaddObserver(name: Notification.Name?, object: Any?, target: NSObject?, block: ((_ notification: Notification) -> Void)?) {
        self.default.qaddObserver(name: name, object: object, target: target, block: block)
    }
    /// 添加一个键盘监听，target释放时，释放监听
    func qaddKeyboardObserver(target: NSObject?, object: Any?, block: ((_ keyboardInfo: QKeyboardInfo) -> Void)?) {
        self.qaddObserver(name: UIApplication.keyboardWillChangeFrameNotification, object: object, target: target) { noti in
            block?(QKeyboardInfo(notifacation: noti))
        }
    }
    /// 添加一个键盘监听，target释放时，释放监听
    class func qaddKeyboardObserver(target: NSObject?, object: Any?, block: ((_ keyboardInfo: QKeyboardInfo) -> Void)?) {
        self.default.qaddKeyboardObserver(target: target, object: object, block: block)
    }
}
/// 键盘变动时，一些信息
public struct QKeyboardInfo {
    /// 键盘frame变动前的位置
    public let frameBegin: CGRect
    /// 键盘frame变动后的位置
    public let frameEnd: CGRect
    /// 键盘变动前需要的时间
    public let animationDuration: Double
    public let isLocal: Bool
    public let notifacation: Notification
    public init(notifacation: Notification) {
        self.notifacation = notifacation
        
        let userInfo = notifacation.userInfo
        frameBegin = (userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue ?? .zero
        frameEnd = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue ?? .zero
        animationDuration = (userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        isLocal = (userInfo?[UIResponder.keyboardIsLocalUserInfoKey] as? NSNumber)?.boolValue ?? true
    }
    
    public var isHidden: Bool {
        return self.frameEnd.minY >= qscreenheight
    }
}

private class QNotificationHelper: NSObject {
    override init() { }
    var block: ((Notification) -> Void)?
    @objc func notificationAction(_ notification: Notification) {
        self.block?(notification)
    }
}
