//
//  ViewController.swift
//  QuicklySwift
//
//  Created by rztime on 06/01/2022.
//  Copyright (c) 2022 rztime. All rights reserved.
//

import UIKit
import QuicklySwift

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let btn = UIButton.init(type: .custom).qtitle("去首页").qtitle("去首页 +", .selected).qtitleColor(.white).qbackgroundColor(.red).qcornerRadius(5, true)
        
        let label = UILabel().qtext("a").qbackgroundColor(.red)
        
        self.view.qbody([
            btn.qframe(.init(x: 100, y: 400, width: 100, height: 60)),
            label.qmakeConstraints({ make in
                make.left.top.equalToSuperview().inset(100)
                make.size.equalTo(100)
            })
        ])
        btn.qtap { view in
            let vc = IndexViewController()
            qAppFrame.pushViewController(vc, animated: true)
            if let view = view as? UIButton {
                view.isSelected = !view.isSelected
            }
        }.qisSelectedChanged({ sender in
            sender.backgroundColor = sender.isSelected ? .lightGray : .red
        })
        // 设置拖拽，则不能使用约束，否则改变状态之后，会还原
        .qdrag(.nearBorder(edge: .init(top: qnavigationbarHeight, left: 10, bottom: qbottomSafeHeight, right: 10)))
        
        label
            .qgradientColors([.red, .blue, .green], locations: [0, 0.5, 1], start: .init(x: 0.5, y: 0), end: .init(x: 0.5, y: 1))
            .qdrag(.nearBorder(edge: .init(top: qnavigationbarHeight, left: 10, bottom: qbottomSafeHeight, right: 10)))
            .qtap { view in
                UIAlertController.qwith(title: "点击了", "", actions: ["ok"], cancelTitle: "no", style: .alert) { index in
                    print("index:\(index) ok")
                } cancel: {
                    print("nononono")
                }
            }
    }
    override var prefersStatusBarHidden: Bool {
        return false
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
