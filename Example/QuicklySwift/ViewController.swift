//
//  ViewController.swift
//  QuicklySwift
//
//  Created by rztime on 06/01/2022.
//  Copyright (c) 2022 rztime. All rights reserved.
//

import UIKit
import QuicklySwift
import RZColorfulSwift

/// 未提交，备注：
/// 新增PHAsset相关方法
/// 新增视频url获取首帧图
/// 新增文件浏览器


class QTestModel: NSObject, QGroupEqualPartitionProtocol {
    var index: Int = 0
    
    var text: String = ""
    init(text: String) {
        self.text = text
    }
    
    func compareValue() -> Int {
        return text.count
    }
    override var description: String {
        return "index: \(index) \(text)"
    }
}

class ViewController: UIViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "加油"
        
        let array = [
            QTestModel(text: "一"),
            QTestModel(text: "二个"),
            QTestModel(text: "三个字"),
            QTestModel(text: "四个字数"),
            QTestModel(text: "五个字来着"),
            QTestModel(text: "六个字六个字"),
            QTestModel(text: "七个字七个字七"),
            QTestModel(text: "八个字八个字八个"),
            QTestModel(text: "九个字九个字九个字")
        ].qgroupEqualPartition(row: 3)
        print("动态规划-----\(array)")
                
        let btn = UIButton.init(type: .custom)
            .qtitle("去首页")
            .qtitle("去首页 +  ⇋澳门", .selected)
            .qtitleColor(.white)
            .qbackgroundColor(.red)
            .qcornerRadius(5, true)
            .qisSelected(true)
            .qtap { view in
                let vc = IndexViewController()
                qAppFrame.pushViewController(vc, animated: true)
            }.qisSelectedChanged({ sender in
                sender.backgroundColor = sender.isSelected ? .lightGray : .red
            }).qisHighlightedChanged({ sender in
                print("---isHighlighted:\(sender.isHighlighted)")
            })
            // 设置拖拽，则不能使用约束，否则改变状态之后，会还原
            .qdrag(.nearBorder(edge: .init(top: qnavigationbarHeight, left: 10, bottom: qbottomSafeHeight, right: 10)))
        self.view.qbody([
            btn.qframe(.init(x: 100, y: 400, width: 300, height: 60)),

            UIView().qbackgroundColor(.green).qframe(.init(x: 100, y: 100, width: 100, height: 100))
            .qtap({ _ in
//                QuicklyFileBrowser.show()
//                return ;
                
                /// 自定义AtionSheet 支持图文混排
                let t = NSAttributedString.rz.colorfulConfer { confer in
                    confer.paragraphStyle?.alignment(.right)
                    confer.image(UIImage.init(named: "1111"))?.size(.init(width: 0, height: 17), align: .center, font: .systemFont(ofSize: 17))
                    confer.text(" 我是一个标题我是一个标")?.font(.systemFont(ofSize: 17)).textColor(.red)
                }
                let r = NSAttributedString.rz.colorfulConfer { confer in
                    confer.text("我是一个选项我是一个选项我是一个选项我是一个选项")?.font(.systemFont(ofSize: 16)).textColor(.blue).paragraphStyle?.alignment(.center)//.numberOfLines(1, maxWidth: 120).lineBreakMode(.byTruncatingTail)
                }
                let c = NSAttributedString.rz.colorfulConfer { confer in
                    confer.text("取消")?.font(.systemFont(ofSize: 17)).textColor(.red).paragraphStyle?.alignment(.center)
                }
//                QActionSheetController
//                QAlertViewController
                QActionSheetController.show(options: .init(options: [
                    .titleAttributeText(t),
                    .description("我是一个小描述我"),
                    .actionAttributeText(r),
                    .action("2"),
                    .action("3"),
//                    .action("4"),
//                    .action("5"),
//                    .action("6"),
//                    .subDescription("我是第二个小提示我是第二个小提示"),
//                    .cancel("取消"),
                    .cancelAttributeText(c),
//                    .dismissWhenTouchOut(false), // 点空白区域不消失
//                    .backgroundColor(.white), // 背景
//                    .separatorColor(.white), // 分割线背景色
                    ])) { index in
                    print("index:\(index)")
//                    let vc = QuicklyFileBrowser()
//                    qAppFrame.pushViewController(vc, animated: true)
                        
                }
            })
            .qtapNumberof(touches: 1, taps: 2, { view in
                print("2222")
            })
            .qtapNumberof(touches: 1, taps: 3, { view in
                print("3333")
            })
            .qpanNumberof(touches: 1, max: 1, { view, pan in
                print("pan:\(pan.state.rawValue)")
            })
            .qdrag(.nearHorizontal(edge: .init(top: qnavigationbarHeight, left: 15, bottom: qbottomSafeHeight, right: 15)), center: false, { view, pan in
                print("---pan:\(pan.state)")
            })
            .qlongpress(numberof: 1, taps: 0, minpress: 2, movement: 10, { view, longpress in
                print("longpress:\(longpress.state)")
            })
        
        ]).qswipe(numberof: 1, direction: .left) { view, swipe in
            print("swipe:\(swipe.direction.rawValue)")
        }
        .qswipe(numberof: 1, direction: [.right]) { view, swipe in
            print("swipe:\(swipe.direction.rawValue)")
        }
        .qswipe(numberof: 1, direction: .up) { view, swipe in
            print("swipe:\(swipe.direction.rawValue)")
        }
        .qswipe(numberof: 1, direction: .down) { view, swipe in
            print("swipe:\(swipe.direction.rawValue)")
        }
        /// 导航栏设置飘灰
        self.qwillAppear { [weak self] in
            self?.navigationController?.navigationBar
                .qgrayfloat(frame: .init(x: 0, y: 0, width: qscreenwidth, height: 44))
        }
        /// 因为不是单独设置的导航栏，所以在没显示当前页面后，移除飘灰
        self.qwillDisAppear { [weak self] in
            let nav = self?.navigationController ?? qAppFrame.navigationController
            nav?.navigationBar.qgrayfloatRemove()
        }
        
        let xxxxxxx = UIButton().qtitle("飘灰").qtitleColor(.brown)
            .qdrag(.nearHorizontal(edge: .init(top: 100, left: 40, bottom: 40, right: 40)))
            .qtap { view in
                let isgr = QGrayFloatManager.shared.isgrayActive
                QGrayFloatManager.shared.isgrayActive = !isgr
            }
        qappKeyWindow.addSubview(xxxxxxx)
    }
    override var prefersStatusBarHidden: Bool {
        return false
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
