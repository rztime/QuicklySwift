//
//  QuicklyDemoViewController.swift
//  QuicklySwift_Example
//
//  Created by rztime on 2022/6/8.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import QuicklySwift

class QuicklyDemoViewController: UIViewController {
    
    let textField = UITextField.init(frame: .zero)
        .qplaceholder("输入文本")
        .qmaxCount(10) // 最多输入字数 区别在于一个表情长度=1
//        .qmaxLength(10) // 最多输入字数 区别在于一个表情长度=2（也有大于2）
        .qbackgroundColor(.lightGray.withAlphaComponent(0.3))
        .qleftView(UIView.init(frame: .init(x: 0, y: 0, width: 30, height: 30)), .always)
        .qclearButtonMode(.always)
        .qfont(.systemFont(ofSize: 16))
        .qtextColor(.red)
        .qtextChanged({ textField in
            print("text 改变")
        }).qshouldChangeText { textField, range, replaceText in
            return true
        }.qshouldBeginEditing { textField in
            return true
        }
    let textView = UITextView.init(frame: .zero)
        .qplaceholder("请输入文本")
        .qmaxCount(10) // 最多输入字数 区别在于一个表情长度=1
//        .qmaxLength(10) // 最多输入字数 区别在于一个表情长度=2（也有大于2）
        .qfont(.systemFont(ofSize: 17))
        .qtextColor(.qhex(0xff0000))
        .qbackgroundColor(.lightGray.withAlphaComponent(0.3))
        .qtextChanged({ textView in
            print("text 改变")
        })
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.qbackgroundColor(.white)
        let testView = UIView()
            .qsizeChanged { view in
                print("view size 改变")
            }.qtap { view in
                print("view 单击手势 响应")
            }
            ///.qborder(.black, 1)
            /// 设置左上、右下圆角
            ///.qcornerRadiuscustom([.topLeft, .bottomRight], radii: 50)
            .qcornerRadius(50, false)
            .qbackgroundColor(.lightGray)
            .qshadow(.red, .init(width: 5, height: 5), radius: 20)
            
        
        let imageView = UIImageView.init(image: UIImage.init(named: "zan_h")).qgaussBlur().qtap { view in
            if let v = view as? UIImageView {
                v.image = UIImage.init(named: "1111")
            }
        }
        
        let vstack = VStackView.qbody([
            UILabel.init().qtext("文本").qbackgroundColor(.lightGray).qtap({ view in
                print("单击label")
            }),
            imageView,
            
            testView.qmakeConstraints({ make in
                make.height.equalTo(100)
            }),
            UIButton.init(type: .custom)
                .qtitle("按钮")
                .qtitleColor(.black)
                .qbackgroundColor(.blue.withAlphaComponent(0.3))
                .qactionFor(.touchUpInside, handler: { sender in
                    print("点击了按钮")
                }),
            UITextField.init(frame: .zero).qplaceholder("输入文本")
                .qmaxCount(10)
                .qbackgroundColor(.lightGray.withAlphaComponent(0.3))
                .qleftView(UIView.init(frame: .init(x: 0, y: 0, width: 30, height: 30)), .always)
                .qclearButtonMode(.always)
                .qmakeConstraints({ make in
                    make.height.equalTo(60)
                })
                .qtextChanged({ textField in
                    print("text:\(textField.text ?? "")")
                }),
            UITextView.init(frame: .zero)
                .qplaceholder("输入文本")
                .qmaxLength(10)
                .qfont(.systemFont(ofSize: 17))
                .qtextColor(.qhex(0xff0000))
                .qbackgroundColor(.lightGray.withAlphaComponent(0.3))
                .qmakeConstraints({ make in
                    make.height.equalTo(100)
                })
                .qtextChanged({ textView in
                    print("----:\(textView.text ?? "")")
                })
        ]).qalignment(.fill).qspacing(30)
        self.view.qbody([
            vstack.qmakeConstraints({ make in
                make.top.equalToSuperview().inset(qnavigationbarHeight + 40)
                make.left.right.equalToSuperview().inset(20)
            })
        ])
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
