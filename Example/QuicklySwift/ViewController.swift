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
            .qtap { view in
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
        
        self.view.qbody([
            btn.qframe(.init(x: 100, y: 400, width: 100, height: 60)),
        ])
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
