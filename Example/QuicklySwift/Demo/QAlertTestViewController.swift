//
//  QAlertTestViewController.swift
//  QuicklySwift_Example
//
//  Created by rztime on 2024/12/5.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit
import QuicklySwift
class QAlertTestViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.qbody([
            UILabel().qtext("点击空白处，打开Alert").qmakeConstraints({ make in
                make.center.equalToSuperview()
            })
        ])
        self.view.qtap { view in
            /// 自定义AtionSheet 支持图文混排
            let t = NSAttributedString.rz.colorfulConfer { confer in
                confer.paragraphStyle?.alignment(.right)
                confer.image(UIImage.init(named: "1111"))?.size(.init(width: 0, height: 17), align: .center, font: .systemFont(ofSize: 17))
                confer.text(" 我是一个标题我是一个标")?.font(.systemFont(ofSize: 17)).textColor(.red)
            }
            let r = NSAttributedString.rz.colorfulConfer { confer in
                confer.text("我是一个选项我是一个选项我是一个选项我是一个选项")?.font(.systemFont(ofSize: 16)).textColor(.blue).paragraphStyle?.alignment(.center)//.numberOfLines(1, maxWidth: 120).lineBreakMode(.byTruncatingTail)
            }
            let c = NSAttributedString.rz.colorfulConfer { confer in
                confer.text("取消")?.font(.systemFont(ofSize: 17)).textColor(.red).paragraphStyle?.alignment(.center)
            }
            //                QActionSheetController
            //                QAlertViewController
            weak var vc : QAlertViewController?
            vc = QAlertViewController.show(options: .init(options: [
                .titleAttributeText(t),
                .description("我是一个小描述我"),
                .actionAttributeText(r),
                .action("2"),
                .action("3"),
                .dismissByYourself,
                //                    .action("4"),
                //                    .action("5"),
                //                    .action("6"),
                //                    .subDescription("我是第二个小提示我是第二个小提示"),
                //                    .cancel("取消"),
                    .cancelAttributeText(c),
                //                    .dismissWhenTouchOut(false), // 点空白区域不消失
                //                    .backgroundColor(.white), // 背景
                //                    .separatorColor(.white), // 分割线背景色
            ])) { index in
                print("index:\(index)")
                if index == 2 {
                    vc?.dismissBySelf()
                }
            }
        }
    }
}
