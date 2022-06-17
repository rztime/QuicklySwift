//
//  LedDemoViewController.swift
//  QuicklySwift_Example
//
//  Created by rztime on 2022/6/14.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import QuicklySwift

class LedDemoViewController: UIViewController {

    let contentView = UIView()
    let ledCirculateView = HStackView.qbody([])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.qbackgroundColor(.white)
        
        self.view.qbody([
            contentView.qmakeConstraints({ make in
                make.left.right.equalToSuperview()
                make.center.equalToSuperview()
                make.height.equalTo(60)
            })
        ])
    
        contentView.qbody([
            ledCirculateView.qmakeConstraints({ make in
                make.left.centerY.equalToSuperview()
            })
        ])
        contentView.qsizeChanged { [weak self] _ in
            self?.updateText()
        }
        
        ledCirculateView.qspacing(50)
        
        ledCirculateView.qsizeChanged { [weak self] view in
            print("---size:\(view.frame.size)")
            self?.circulate()
        }
    }
    func updateText() {
        let text = "加油呀晕晕晕晕晕晕晕晕晕"
        let label = UILabel().qtext(text)
        let label1 = UILabel().qtext(text)
        let label2 = UILabel().qtext(text)
        let label3 = UILabel().qtext(text)
        ledCirculateView.qbody([label, label1, label2, label3])
    }
    func circulate() {
        /// 滚动一个label 的宽度，就还原重复
        ledCirculateView.qtransform(x: -(208 + 50), y: 0, .animate(3, delay: 1, options: [.curveLinear, .repeat])) { view in
            
        }
    }
}
