//
//  DatePickerTestViewController.swift
//  QuicklySwift_Example
//
//  Created by rztime on 2024/9/5.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit
import QuicklySwift
class DatePickerTestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        let label = UILabel().qtext("选择时间")
            .qtap { view in
                QDatePicker.show(style: .style1, options: .init(options: [.style1])) { _ in
                    
                }
            }

        self.view.qbody([
            [label].qjoined(aixs: .vertical, spacing: 10, align: .fill, distribution: .fill)
                .qmakeConstraints({ make in
                    make.center.equalToSuperview()
                    make.left.right.equalToSuperview().inset(20)
                })
        ])
    }
}
