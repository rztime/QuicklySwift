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
            UIButton.init(type: .custom)
                .qimage(UIImage.init(named: "zan_h"))
                /// 抖动
                .qshake(0.3, 15, repeatcount: .greatestFiniteMagnitude)
                .qframe(.init(x: 15, y: qnavigationbarHeight + 15, width: 60, height: 44)),
            
            UIButton.init(type: .custom)
                .qtitle("拖动吸边")
                .qbackgroundColor(.lightGray)
                /// 拖动 吸边
                .qdrag(.nearHorizontal(edge: .init(top: qnavigationbarHeight + 10, left: 15, bottom: qbottomSafeHeight, right: 15)))
                .qframe(.init(x: 15, y: qnavigationbarHeight + 80, width: 100, height: 50))
                .qcornerRadius(25, true),
            
            UIImageView.init(image: UIImage.init(named: "1111"))
                .qcornerRadius(1, true)
                .qframe(.init(x: 30, y: qnavigationbarHeight + 150, width: 60, height: 60))
                .qcontentMode(.scaleAspectFit)
                /// 旋转45度
                .qtransform(rotation: 45),
            
            
            UIImageView.init(image: UIImage.init(named: "1111"))
                .qcornerRadius(1, true)
                .qframe(.init(x: 30, y: qnavigationbarHeight + 230, width: 60, height: 60))
                .qcontentMode(.scaleAspectFit)
                // 缩放
                .qtransform(scale: 1.1, 1.1),
            
            UIButton.init(type: .custom)
                .qimage(UIImage.init(named: "zan"), .normal)
                .qimage(UIImage.init(named: "zan_h"), .selected)
                .qframe(.init(x: 15, y: qnavigationbarHeight + 300, width: 40, height: 40))
                .qactionFor(.touchUpInside, handler: { sender in
                    sender.isSelected = !sender.isSelected
                })
                .qisSelectedChanged({ sender in
                    if sender.isSelected {
                        /// 缩放动画
                        sender.qtransform(scale: 1.3, 1.3, .animate(0.3, delay: 0, options: .curveLinear)) { view in
                            // 还原
                            view.qtransform(scale: 1, 1)
                        }
                    }
                }),
            
            UILabel().qtext("点击按钮点赞动画（缩放）").qframe(.init(x: 80, y: qnavigationbarHeight + 310, width: 300, height: 20)),
            
            UILabel().qtext("循环平移").qframe(.init(x: 15, y: qnavigationbarHeight + 380, width: 100, height: 20))
                // 循环平移
                .qtransform(x: 300, y: 0, .animate(5, delay: 0, options: [.curveLinear, .repeat]), complete: { view in
                    
                }),
            
            UILabel().qtext("来回循环平移").qframe(.init(x: 15, y: qnavigationbarHeight + 420, width: 120, height: 20))
                // 来回循环平移
                .qtransform(x: 300, y: 0, .animate(5, delay: 0, options: [.curveLinear, .autoreverse, .repeat]), complete: { view in
                    
                })
        ])
        
    }
    
    
}
