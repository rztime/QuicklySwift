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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        let slider = UISlider.init()
        self.view.qbody([
            slider.qmakeConstraints({ make in
                make.centerX.equalToSuperview()
                make.top.equalToSuperview().inset(100)
                make.width.equalTo(300)
                make.height.equalTo(44)
            })
        ])
        slider.minimumValueImage = UIImage(named: "zan_h")
        slider.maximumValueImage = UIImage(named: "zan")
        slider.minimumTrackTintColor = .red
        slider.maximumTrackTintColor = .blue
 
        let s = QSlider.init(frame: .zero)
        s.options.thumbSize = .init(width: 40, height: 40)
        s.options.thumbCornerRadius = 3
        s.options.sliderHeight = 5
        s.thumbView.qimage(UIImage(named: "zan_h"))
        
        s.qaction(for: .valueChanged) { sender in
            print("value changed: \(sender.value)")
        }.qaction(for: .valueChangedByThumb) { sender in
            print("value changed thumb: \(sender.value)")
        }.qaction(for: .thumbEnd) { sender in
            print("value changed thumb end: \(sender.value)")
        }

        let s1 = QSlider.init(frame: .zero, direction: .vertical)
     
        
        let switchbtn = QSwitch.init(frame: .zero, direction: .horizontal)
//        switchbtn.isOn = true
        switchbtn.options.sliderHeight = 20
        switchbtn.options.thumbSize = .init(width: 30, height: 30)
        switchbtn.qactionForValueChanged { sender in
            print("------switch \(sender.isOn)")
        }.qactionForValueWillChange { sender in
            return true
        }
        
        let switchbtn1 = QSwitch.init(frame: .zero, direction: .vertical)
  
        self.view.qbody([
            s.qmakeConstraints({ make in
                make.top.equalTo(slider.snp.bottom).offset(50)
                make.centerX.equalTo(slider)
                make.height.equalTo(44)
                make.width.equalTo(300)
            }),
            s1.qmakeConstraints({ make in
                make.top.equalTo(s.snp.bottom).offset(50)
                make.centerX.equalToSuperview()
                make.width.equalTo(44)
                make.height.equalTo(300)
            }),
            switchbtn.qmakeConstraints({ make in
                make.top.equalTo(s1.snp.bottom).offset(20)
                make.width.equalTo(60)
                make.height.equalTo(20)
                make.centerX.equalToSuperview()
            }),
            switchbtn1.qmakeConstraints({ make in
                make.top.equalTo(switchbtn.snp.bottom).offset(20)
                make.width.equalTo(20)
                make.height.equalTo(40)
                make.centerX.equalToSuperview()
            }),
        ])
        slider.qactionFor(.valueChanged) { [weak s, weak s1] sender in
            s?.value = CGFloat(sender.value)
            s1?.value = CGFloat(sender.value)
        }
    }
}
