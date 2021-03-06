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
        self.title = "加油"
        let btn = UIButton.init(type: .custom)
            .qtitle("去首页")
            .qtitle("去首页 +", .selected)
            .qtitleColor(.white)
            .qbackgroundColor(.red)
            .qcornerRadius(5, true)
            .qtap { view in
                let vc = IndexViewController()
                qAppFrame.pushViewController(vc, animated: true)
            }.qisSelectedChanged({ sender in
                sender.backgroundColor = sender.isSelected ? .lightGray : .red
            }).qisHighlightedChanged({ sender in
                print("---isHighlighted:\(sender.isHighlighted)")
            })
            // 设置拖拽，则不能使用约束，否则改变状态之后，会还原
            .qdrag(.nearBorder(edge: .init(top: qnavigationbarHeight, left: 10, bottom: qbottomSafeHeight, right: 10)))

        self.view.qbody([
            btn.qframe(.init(x: 100, y: 400, width: 100, height: 60)),
     
            UIView().qbackgroundColor(.green).qframe(.init(x: 100, y: 600, width: 100, height: 100))
            .qtap({ view in
                print("111111")
            })
            .qtapNumberof(touches: 1, taps: 2, { view in
                print("2222")
            })
            .qtapNumberof(touches: 1, taps: 3, { view in
                print("3333")
            })
            .qpanNumberof(touches: 1, max: 1, { view, pan in
                print("pan:\(pan.state.rawValue)")
            })
            .qdrag(.nearHorizontal(edge: .init(top: qnavigationbarHeight, left: 15, bottom: qbottomSafeHeight, right: 15)), center: false, { view, pan in
                print("---pan:\(pan.state)")
            })
            .qlongpress(numberof: 1, taps: 0, minpress: 2, movement: 10, { view, longpress in
                print("longpress:\(longpress.state)")
            })
        
        ]).qswipe(numberof: 1, direction: .left) { view, swipe in
            print("swipe:\(swipe.direction.rawValue)")
        }
        .qswipe(numberof: 1, direction: [.right]) { view, swipe in
            print("swipe:\(swipe.direction.rawValue)")
        }
        .qswipe(numberof: 1, direction: .up) { view, swipe in
            print("swipe:\(swipe.direction.rawValue)")
        }
        .qswipe(numberof: 1, direction: .down) { view, swipe in
            print("swipe:\(swipe.direction.rawValue)")
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
