//
//  TransitionTwoViewController.swift
//  QuicklySwift_Example
//
//  Created by rztime on 2022/7/4.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import QuicklySwift

class TransitionTwoViewController: UIViewController {
    let imageView = UIImageView.init(image: UIImage.init(named: "1111"))
    
    var currentIndex: Int {
        return 0
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "预览大图"
        
        self.view.qbody([
            imageView.qmakeConstraints({ make in
                make.center.equalToSuperview()
                make.width.equalToSuperview()
            }), 
        ]) 
        self.view.layoutIfNeeded()
        imageView.qtap { [weak self] view in
            let vc2 = TransitionThreeViewController()
            self?.navigationController?.pushViewController(vc2, animated: true)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    func targetView(_ index: Int) -> UIView? {
        return self.imageView
    }
}
