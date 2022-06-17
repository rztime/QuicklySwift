//
//  AnimateDemoViewController.swift
//  QuicklySwift_Example
//
//  Created by rztime on 2022/6/14.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import QuicklySwift

class AnimateDemoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        
        self.view.qbody([
            [
                UILabel().qtext("滚动").qsizeChanged({ view in
                    
                }),
                UILabel().qtext("测试"),
            
            
            ].qjoined(aixs: .vertical, spacing: 15, align: .leading, distribution: .fill)
                .qmakeConstraints({ make in
                    make.left.right.equalToSuperview().inset(15)
                    make.center.equalToSuperview()
                }),
            
//            UILabel().qtext("抖动测试").qmakeConstraints({ make in
//                make.center.equalToSuperview()
//            })
//            .qtap({ view in
//                view.qtransform(x: -100, y: 0, .animate(time: 1, options: [.autoreverse, .repeat])) {
//
//                }
//            }),
//
            
            UILabel.init(frame: .init(x: 10, y: 100, width: 50, height: 50))
                .qbackgroundColor(.red)
            .qtext("哈")
//            .qdrag(.nearBorder(edge: .init(top: qnavigationbarHeight + 10, left: 10, bottom: qbottomSafeHeight + 10, right: 10)))
                .qdrag(.normal(edge: .init(top: qnavigationbarHeight + 10, left: 10, bottom: qbottomSafeHeight + 10, right: 10)))
            .qshowToWindow({ view, showed in
                print("show:\(showed)")
            }),
            
             
            UIButton.init(type: .custom)
                .qimage(UIImage.init(named: "zan"), .normal)
                .qimage(UIImage.init(named: "zan_h"), .selected)
                .qmakeConstraints({ make in
                    make.top.equalToSuperview().inset(qnavigationbarHeight + 30)
                    make.centerX.equalToSuperview()
                })
                .qactionFor(.touchUpInside, handler: { sender in
                    sender.isSelected = !sender.isSelected
                    if sender.isSelected {
                        sender.qtransform(scale: 1.3, 1.5, .animate(0.3, delay: 0, options: .curveEaseInOut)) { view in
                            view.qtransform(scale: 1, 1)
                        }
                    }
                    let vc = UIViewController()
                    vc.view.backgroundColor = .white 
                    qAppFrame.pushViewController(vc, animated: true)
                })
        
        ])
     
    }
     

}
