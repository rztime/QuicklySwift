//
//  GrayfloatVC1.swift
//  QuicklySwift_Example
//
//  Created by rztime on 2022/12/20.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import QuicklySwift

class GrayfloatVC1: UIViewController {

    let textLabel = UILabel()
        .qnumberOfLines(0)
        .qtext("文本文本文\n文本文本文\n文本文本文本文本文本文本文本文本文本文本文本").qtextColor(.white)
    let imageViwe = UIImageView.init(image: UIImage.init(named: "1111"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        /// 整个view飘灰
        self.view.qgrayfloat(edges: .zero)
        self.view.qgrayfloat(tag: 1, frame: .init(x: 0, y: 0, width: 100, height: 100))
        /// 导航栏设置飘灰
        /// 因为不是单独设置的导航栏，所以在没显示当前页面后，移除飘灰
        self.qwillAppear { [weak self] in
            self?.navigationController?.navigationBar
                .qgrayfloat(frame: .init(x: 0, y: 0, width: qscreenwidth, height: 44))
        } 
        self.qwillDisAppear { [weak self] in
            let nav = self?.navigationController ?? qAppFrame.navigationController
            nav?.navigationBar.qgrayfloatRemove()
        }
        
        self.view.qbody([
            textLabel.qmakeConstraints({ make in
                make.left.right.equalToSuperview().inset(20)
                make.center.equalToSuperview()
            }),
            imageViwe.qmakeConstraints({ make in
                make.bottom.equalTo(self.textLabel.snp.top).offset(-20)
                make.size.equalTo(200)
                make.centerX.equalToSuperview()
            })
        ])
        
        textLabel.qtap { view in
            let vc = ViewController()
            qAppFrame.pushViewController(vc)
        }
    }
}
