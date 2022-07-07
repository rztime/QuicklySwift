//
//  TransitionThreeViewController.swift
//  QuicklySwift_Example
//
//  Created by rztime on 2022/7/4.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit

class TransitionThreeViewController: UIViewController {
    let imageView = UIImageView.init(image: UIImage.init(named: "1111"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.view.qbody([
            imageView.qmakeConstraints({ make in
                make.center.equalToSuperview()
                make.width.equalTo(30)
            })
        ])
        self.view.layoutIfNeeded()
    }
}
