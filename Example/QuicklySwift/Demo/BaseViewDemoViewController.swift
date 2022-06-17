//
//  BaseViewDemoViewController.swift
//  QuicklySwift_Example
//
//  Created by rztime on 2022/6/13.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import QuicklySwift

class BaseViewDemoViewController: UIViewController {
    let label = UILabel()
        .qfont(.systemFont(ofSize: 15))
        .qtextColor(.red)
        .qnumberOfLines(0)
        .qtext("文本框")
        .qtap { view in
            print("点击了label")
        }
    let btn = UIButton.init(type: .custom)
        .qtitle("按钮")
        .qtitleColor(.red)
        .qactionFor(.touchUpInside) { sender in
            print("点击了按钮 事件响应")
        }.qtap { view in
            print("点击了按钮 tap响应 如果设置了tap， actionFor touchUpInside 将被覆盖")
        }
     
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.view.qbody([
            VStackView.qbody([
                label,
                btn,
            ]).qmakeConstraints({ make in
                make.left.right.equalToSuperview()
                make.top.equalToSuperview().inset(qnavigationbarHeight)
            })
        ])
    }
}
