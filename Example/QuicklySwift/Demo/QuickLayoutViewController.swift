//
//  QuickLayoutViewController.swift
//  QuicklySwift_Example
//
//  Created by rztime on 2022/6/13.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import QuicklySwift

class QuickLayoutViewController: UIViewController {
 
    let label1 = UILabel().qtext("文本框1文本框1文本框1文本框1")
    let label2 = UILabel().qtext("文本框2文本框2文本框2文本框2")
    let label3 = UILabel().qtext("文本框3文本框3文本框3文本框3")
    
    let btn1 = UIButton.init(type: .custom).qtitle("按钮1按钮1按钮1按钮1").qtitleColor(.black).qbackgroundColor(.lightGray)
    let btn2 = UIButton.init(type: .custom).qtitle("按钮2按钮2按钮2按钮2").qtitleColor(.black).qbackgroundColor(.lightGray)
    let btn3 = UIButton.init(type: .custom).qtitle("按钮3按钮3按钮3按钮3").qtitleColor(.black).qbackgroundColor(.lightGray)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        self.view.qbody([
            label1.qmakeConstraints({ make in
                make.left.right.equalToSuperview().inset(20)
                make.top.equalToSuperview().inset(qnavigationbarHeight)
            }),
            label2.qmakeConstraints({ make in
                make.left.right.equalTo(self.label1)
                make.top.equalTo(self.label1.snp.bottom).offset(30)
            }),
            label3.qmakeConstraints({ make in
                make.left.right.equalTo(self.label1)
                make.top.equalTo(self.label2.snp.bottom).offset(30)
            }),
            
            /// 垂直排列的UIStackView 
            VStackView.qbody([
                btn1,
                btn2,
                btn3
            ]).qmakeConstraints({ make in
                make.left.right.equalToSuperview()
                make.top.equalTo(self.label3.snp.bottom).offset(50)
            }).qspacing(15),
           
            /// 也可以直接使用数组 :[UIView], qjoined()方法，将直接组合生成一个UIStackView
//            [btn1, btn2, btn3].qjoined(aixs: .vertical, spacing: 15, align: .fill, distribution: .equalSpacing)
//                .qmakeConstraints({ make in
//                    make.left.right.equalToSuperview()
//                    make.top.equalTo(self.label3.snp.bottom).offset(50)
//                })
        ])
    }
}
