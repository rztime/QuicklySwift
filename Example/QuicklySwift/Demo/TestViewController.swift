//
//  TestViewController.swift
//  QuicklySwift_Example
//
//  Created by rztime on 2024/4/15.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        let text = "抗拉伸"
        let label1 = UILabel().qtext(text)
        let label2 = UILabel().qtext(text).qshowType(.horizontal, type: .low)
        let label3 = UILabel().qtext(text)//.qshowType(.horizontal, type: .low)
        let label4 = UILabel().qtext(text)//.qshowType(.horizontal, type: .height)
        
        self.view.qbody([
            label1.qmakeConstraints({ make in
                make.left.equalToSuperview().inset(10)
                make.centerY.equalToSuperview()
            }),
            label2.qmakeConstraints({ make in
                make.left.equalTo(label1.snp.right).offset(10)
                make.centerY.equalToSuperview()
            }),
            label3.qmakeConstraints({ make in
                make.left.equalTo(label2.snp.right).offset(10)
                make.centerY.equalToSuperview()
            }),
            label4.qmakeConstraints({ make in
                make.left.equalTo(label3.snp.right).offset(10)
                make.centerY.equalToSuperview()
                make.right.equalToSuperview().inset(10)
            }),
        ])
    }
    
}
