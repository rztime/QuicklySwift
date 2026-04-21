//
//  QSliderTestViewController.swift
//  QuicklySwift_Example
//
//  Created by rztime on 2024/5/21.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit
import QuicklySwift

class QSliderTestViewController: UIViewController {
    lazy var slider = UISlider.init().qthen { [weak self] in
        $0.minimumValueImage = UIImage(named: "zan_h")
        $0.maximumValueImage = UIImage(named: "zan")
        $0.minimumTrackTintColor = .red
        $0.maximumTrackTintColor = .blue
        $0.qactionFor(.valueChanged) { [weak self] sender in
            self?.s2.value = CGFloat(sender.value)
        }
    }
    lazy var s = QSlider.init(frame: .zero).qthen {
        $0.options.thumbSize = .init(width: 40, height: 40)
        $0.options.thumbCornerRadius = 3
        $0.options.sliderHeight = 5
        $0.thumbView.qimage(UIImage(named: "zan_h"))
        $0.qaction(for: .valueChanged) { sender in
            print("value changed: \(sender.value)")
        }.qaction(for: .valueChangedByThumb) { sender in
            print("value changed thumb: \(sender.value)")
        }.qaction(for: .thumbEnd) { sender in
            print("value changed thumb end: \(sender.value)")
        }
    }
    let s1 = QSlider.init(frame: .zero, direction: .vertical)
    let s2 = QSlider.init(frame: .zero, direction: .horizontal).qthen {
        $0.options.sliderHeight = 4
        $0.options.thumbSize = .zero
        $0.options.sliderCornerRadius = 2
        $0.maxView.backgroundColor = .qhex("#E9F1FD")
        $0.minView.backgroundColor = .qhex("#2B7BED")
    }
    lazy var switchbtn = QSwitch.init(frame: .zero, direction: .horizontal).qthen {
        $0.options.sliderHeight = 20
        $0.options.thumbEdges = .init(top: 0, left: 1, bottom: 0, right: 1)
        $0.options.thumbSize = .init(width: 18, height: 18)
        $0.minView.backgroundColor = .white
        $0.qactionForValueChanged { sender in
            print("------switch \(sender.isOn)")
        }.qactionForValueWillChange { sender in
            return true
        }
    }
    lazy var uiswitch = UISwitch().qthen {
        $0.onTintColor = .yellow
        $0.tintColor = .systemRed
        $0.thumbTintColor = .blue
        $0.subviews.forEach({$0.qtransform(scale: 100/63.0, 30/28.0);$0.qx(0).qy(0)})
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .brown
        self.view.qbody([
            [
                slider.qmakeConstraints({$0.width.equalTo(300); $0.height.equalTo(44)}),
                s.qmakeConstraints({$0.width.equalTo(300); $0.height.equalTo(44)}),
                s1.qmakeConstraints({$0.width.equalTo(44); $0.height.equalTo(300)}),
                switchbtn.qmakeConstraints({$0.width.equalTo(40); $0.height.equalTo(20)}),
                s2.qmakeConstraints({$0.width.equalTo(40); $0.height.equalTo(4)}),
                uiswitch.qmakeConstraints({$0.width.equalTo(100); $0.height.equalTo(30)}),
            ].qjoined(aixs: .vertical, spacing: 20, align: .center, distribution: .equalSpacing)
                .qmakeConstraints({ make in
                    make.top.equalToSuperview().inset(qnavigationbarHeight + 20)
                    make.left.right.equalToSuperview()
                })
        ])
    }
}
