//
//  DispatchViewController.swift
//  QuicklySwift_Example
//
//  Created by rztime on 2023/10/31.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit
import QuicklySwift

class DispatchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        /// 1秒内连续调用，抛弃之前的，仅执行最后一个
        QDispatch.qRetriggerDelay(id: "1", queue: .main, duration: 1) {
            print("111 1")
        }
        QDispatch.qRetriggerDelay(id: "1", queue: .main, duration: 1) {
            print("111 2")
        }
        QDispatch.qRetriggerDelay(id: "1", queue: .main, duration: 1) {
            print("111 3") // 前两个不执行
        }
        
        /// 1秒内连续调用，仅执行第一个，抛弃之后的
        QDispatch.qNoRetriggerDelay(id: "2", queue: .main, duration: 1) {
            print("222 1") // 后两个不执行
        }
        QDispatch.qNoRetriggerDelay(id: "2", queue: .main, duration: 1) {
            print("222 2")
        }
        QDispatch.qNoRetriggerDelay(id: "2", queue: .main, duration: 1) {
            print("222 3")
        }
        
        /// 同步、异步执行多任务，全部执行完之后，执行complete
        QDispatch.qsyncTask { task in
            for _ in 0 ..< 10 {
                /// 创建一个任务
                task.qtaskItem { item, complete in
                    let x: TimeInterval = TimeInterval(arc4random() % 3)
                    DispatchQueue.init(label: "xxxx_\(item.index)").asyncAfter(deadline: .now() + x, execute: {
                        print(item.index)
                        // 任务完成后，执行下一步
                        complete?(.next)
                    })
                }
            }
        } complete: { items in
            print("---finish")
        }
    }
     

}
