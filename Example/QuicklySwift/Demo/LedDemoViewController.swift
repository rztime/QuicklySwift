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

    let textLabel = UILabel().qfont(.systemFont(ofSize: 16)).qtextColor(.red)

    var texts = ["循环滚动",
                 "循环滚动循环滚动",
                 "循环滚动循环滚动循环滚动",
                 "循环滚动循环滚动循环滚动循环滚动",
                 "循环滚动循环滚动循环滚动循环滚动循环滚动",]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.qbackgroundColor(.white)
        
        self.view.qbody([
            textLabel.qframe(.init(x: 15, y: qnavigationbarHeight + 30, width: 15, height: 30))
        ])
        
        let btn = UIButton.init().qtitle("刷新").qtitleColor(.red)
            .qtap { [weak self] view in
                self?.updateText()
            }
        self.navigationItem.rightBarButtonItem = .init(customView: btn)
        
        self.updateText()
    }
    func updateText() {
        /// 还原位置
        textLabel.qtransform(x: 0, y: 0)
        let text = texts[Int.random(in: 0..<5)] + "                "
        textLabel.text = text
        /// 计算出原本位置的宽度
        let rect = textLabel.textRect(forBounds: .init(x: 0, y: 0, width: CGFloat.greatestFiniteMagnitude, height: 30), limitedToNumberOfLines: 1)
        let count = Int(ceilf(Float(qscreenwidth / rect.width)))
        var newText = text
        /// 宽度不够，则补全
        for _ in 0..<count {
            newText += text
        }
        textLabel.text = newText
        /// 计算完整的宽度，设置textLabel
        let newrect = textLabel.textRect(forBounds: .init(x: 0, y: 0, width: CGFloat.greatestFiniteMagnitude, height: 30), limitedToNumberOfLines: 1)
        var frame = textLabel.frame
        frame.size.width = newrect.width
        textLabel.frame = frame
        let time = rect.width / 60
        /// 匀速、循环
        textLabel.qtransform(x: -rect.width, y: 0, .animate(time, delay: 1, options: [.curveLinear, .repeat])) { view in
            
        }
    }
}
