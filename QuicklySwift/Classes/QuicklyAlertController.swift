//
//  QuicklyAlertController.swift
//  QuicklySwift
//
//  Created by rztime on 2022/6/6.
//

import UIKit

public extension UIAlertController {
    /// 快速弹窗方法
    /// - Parameters:
    ///   - title: 标题
    ///   - message: 提示信息
    ///   - actions: 按钮标题
    ///   - cancelTitle: 取消按钮的标题
    ///   - style: 弹窗样式
    ///   - complete: 按钮点击之后的回调，从actions数组取的index
    ///   - cancel: 取消按钮的回调
    @discardableResult
    class func qwith(title: String?, _ message: String?, actions: [String]?, cancelTitle: String? = nil, style: UIAlertController.Style = .alert, complete: ((_ index: Int) -> Void)? = nil, cancel:(() -> Void)? = nil) -> UIAlertController {
        let vc = UIAlertController.init(title: title, message: message, preferredStyle: style)
        if let title = cancelTitle {
            let c = UIAlertAction.init(title: title, style: .cancel) { _ in
                cancel?()
            }
            vc.addAction(c)
        }
        actions?.enumerated().forEach({ action in
            let c = UIAlertAction.init(title: action.element, style: .default) { _ in
                complete?(action.offset)
            }
            vc.addAction(c)
        })
        qAppFrame.present(vc, animated: true, completion: nil)
        return vc
    }
}
