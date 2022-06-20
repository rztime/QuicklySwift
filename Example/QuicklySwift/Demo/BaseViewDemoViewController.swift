//
//  BaseViewDemoViewController.swift
//  QuicklySwift_Example
//
//  Created by rztime on 2022/6/13.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import QuicklySwift

class BaseViewDemoViewController: UIViewController {
    let scrollView = UIScrollView.init()
        .qcontentSizeChanged { scrollView in
            print("------contentsize:-\(scrollView.contentSize)")
        }
        .qcontentOffsetChanged { scrollView in
            print("------contentoffset:-\(scrollView.contentOffset)")
        }
        .qdidEndScroll { scrollView in
            print("------ 滚动停止")
        }
        .qcontentSize(.init(width: 0, height: 1200))
    
    let label = UILabel()
        .qfont(.systemFont(ofSize: 15))
        .qtextColor(.red)
        .qnumberOfLines(0)
        .qtext("文本框， 左上右下圆角")
        .qshadowText(.white, .init(width: 0, height: -1))  // 阴影
        .qbackgroundColor(.lightGray)
        .qcornerRadiusCustom([.topLeft, .bottomRight], radii: 10) /// 左上、右下圆角
        .qdeinit {
            print("label 被释放了")
        }
    
    let btn = UIButton.init(type: .custom)
        .qtitle("按钮 居左")
        .qtitleColor(.white)
        .qbackgroundColor(.lightGray)
        .qHAlign(.left) // 居左
        .qcornerRadius(4, true) // 圆角
        .qisSelectedChanged { sender in
            print("btn isSelected:\(sender.isSelected)")
            sender.backgroundColor = sender.isSelected ? .red : .lightGray
        }.qisEnabledChanged { sender in
            print("btn isEnabel:\(sender.isEnabled)")
            sender.backgroundColor = sender.isEnabled ? sender.backgroundColor?.withAlphaComponent(1) : sender.backgroundColor?.withAlphaComponent(0.3)
        }

    let textField = UITextField()
        .qbackgroundColor(.lightGray)
        .qfont(.systemFont(ofSize: 15))
        .qtextColor(.black)
        .qplaceholder("textField: 输入文本")
        .qleftView(UIView.init(frame: .init(x: 0, y: 0, width: 14, height: 14)), .always) // 左侧站位
        .qclearButtonMode(.always)
        .qmaxCount(30) // 最多输入30个字符
        .qcornerRadius(5, true)
        .qtextChanged { textField in
            print("-----textField:\(textField.text ?? "")")
        }
        .qshouldChangeText { textFiled, range, replaceText in
            print("-----replaceText:\(replaceText)")
            return true
        }
    
    let textView = UITextView()
//        .qbackgroundColor(.qhex(0xfef8f7))
        .qfont(.systemFont(ofSize: 15))
        .qtextColor(.black)
        .qplaceholder("textView: 输入文本")
        .qmaxCount(30)
        .qcornerRadiusCustom([.topLeft, .bottomRight], radii: 5)
        .qtextChanged { textView in
            print("-----textView:\(textView.text ?? "")")
        }
        .qshouldChangeText { textView, range, replaceText in
            print("-----replaceText:\(replaceText)")
            return true
        }
        .qgradientColors([.qhex(0xfef8f7), .qhex(0xf1f3f3)], locations: [0, 1], start: .zero, end: .init(x: 1, y: 1)) // 渐变色
    
    let imageView = UIImageView.init(image: UIImage.init(named: "1111"))
        .qcontentMode(.scaleAspectFill)
        .qcornerRadius(3, true)
        .qgaussBlur() // 高斯模糊
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.qbody([
            scrollView.qmakeConstraints({ make in
                make.edges.equalToSuperview()
            })
        ])
        scrollView.qbody([
            label.qmakeConstraints({ make in
                make.left.equalToSuperview().inset(15)
                make.top.equalToSuperview().inset(30)
                make.width.equalTo(200)
                make.height.equalTo(44)
            }),
            
            btn.qmakeConstraints({ make in
                make.top.equalTo(self.label.snp.bottom).offset(15)
                make.left.equalToSuperview().inset(15)
                make.width.equalTo(100)
                make.height.equalTo(44)
            }),
            
            textField.qmakeConstraints({ make in
                make.left.equalToSuperview().inset(15)
                make.top.equalTo(self.btn.snp.bottom).offset(15)
                make.height.equalTo(44)
                make.width.equalTo(qscreenwidth - 30)
            }),
            
            textView.qmakeConstraints({ make in
                make.left.equalToSuperview().inset(15)
                make.top.equalTo(self.textField.snp.bottom).offset(15)
                make.height.equalTo(200)
                make.width.equalTo(qscreenwidth - 30)
            }),
            
            imageView.qmakeConstraints({ make in
                make.left.equalToSuperview().inset(15)
                make.top.equalTo(self.textView.snp.bottom).offset(15)
                make.width.equalTo(300)
                make.height.equalTo(44)
            })
        ])
        
        label.qtap { [weak self] view in
            print("点击了label")
            self?.btn.isEnabled = !(self?.btn.isEnabled ?? false)
        }
        btn.qactionFor(.touchUpInside) { sender in
            print("点击了按钮 事件响应")
        }.qtap { view in
            print("点击了按钮 tap响应 如果设置了tap， actionFor touchUpInside 将被覆盖")
            if let btn = view as? UIButton {
                btn.isSelected = !btn.isSelected
            }
        }
    }
}
