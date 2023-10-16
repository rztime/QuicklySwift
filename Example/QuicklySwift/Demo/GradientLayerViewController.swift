//
//  GradientLayerViewController.swift
//  QuicklySwift_Example
//
//  Created by rztime on 2023/9/15.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit
import QuicklySwift
import SnapKit

class GradientLayerViewController: UIViewController {
    //文本标签
    var label: UILabel = .init().qnumberOfLines(0).qtext("hello").qtextColor(.white)
//    var label: UITextView = .init().qtext("asdfjasl 发数控刀具发了卡萨丁立卡司法鉴定卢卡斯电力科技阿斯利康到付件卢卡斯大家付了款啊塞德里克久啊开始了地方阿斯蒂芬").qtextColor(.white)
    let imageView = UIImageView.init(image: .init(named: "zan"))
    
    let btn = UIButton.init(type: .custom)
        .qimage(.init(named: "avatar"))
        .qtitle("哈哈哈哈哈")
        .qtitleColor(.black)
//        .qbackgroundImage(.init(named: "zan"))
    
    //渐变层
    var gradientLayer:CAGradientLayer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.qbackgroundColor(.white)
        
        self.view.qbody([
            label.qmakeConstraints({ make in
                make.center.equalToSuperview()
                make.left.right.equalToSuperview().inset(20)
                make.height.equalTo(200)
            }),
            imageView.qmakeConstraints({ make in
                make.bottom.centerX.equalToSuperview()
            }),
            btn.qmakeConstraints({ make in
                make.bottom.equalToSuperview().inset(100)
                make.centerX.equalToSuperview()
            })
        ])
        btn.qimageRedrawColor(.blue, for: .normal)
            .qtitleColor(gradinent: [UIColor.red, UIColor.blue, UIColor.green], locations: [0, 0.35, 0.7], start: .init(x: 0, y: 0.5), end: .init(x: 1, y: 0.5), size: .init(width: 50, height: 20))
//        btn.qbackgroundImageRedrawColor(.green, for: .normal)
        label.qtextColor(gradinent: [UIColor.red, UIColor.blue, UIColor.green], locations: [0, 0.35, 0.7], start: .init(x: 0, y: 0.5), end: .init(x: 1, y: 0.5), size: .init(width: 350, height: 20))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

