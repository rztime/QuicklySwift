//
//  IndexViewController.swift
//  QuicklySwift_Example
//
//  Created by rztime on 2022/6/7.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import QuicklySwift

class IndexViewController: UIViewController {
    let tableView = UITableView.init(frame: .zero, style: .plain)
    
    let source:[(String, AnyClass)] = [
        ("快速布局", QuickLayoutViewController.self),
        ("基础控件的方法", BaseViewDemoViewController.self),
        ("列表", TableViewDemoViewController.self),
        ("collectionView", CollectionViewDemoViewController.self),
        ("快速开发", QuicklyDemoViewController.self),
        ("动画测试", AnimateDemoViewController.self),
        ("LED", LedDemoViewController.self),
        ("朋友圈", FriendDemoViewController.self),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "首页"
        self.view.backgroundColor = .white
 
        self.view.qbody([
            tableView.qmakeConstraints({ make in
                make.edges.equalToSuperview()
            })
        ])
        tableView.qnumberofRows { [weak self] section in
            return self?.source.count ?? 0
        }.qheightForRow { indexPath in
            return 80
        }.qcell { [weak self] (tableView, indexPath) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? .init(style: .subtitle, reuseIdentifier: "cell")
            cell.accessoryType = .disclosureIndicator
            let item = self?.source[indexPath.row]
            cell.textLabel?.text = item?.0
            cell.detailTextLabel?.text = "\(String(describing: item?.1.self))"
            return cell
        }.qdidSelectRow { [weak self] tableView, indexPath in
            tableView.deselectRow(at: indexPath, animated: false)
            let item = self?.source[indexPath.row]
            if let cla = item?.1 as? UIViewController.Type {
                let vc = cla.init()
                vc.title = item?.0
                qAppFrame.pushViewController(vc, animated: true)
            }
        }
        let scrollView = UIScrollView()
            .qdidScroll { scrollView in
                
            }.qdidEndScroll { scrollView in
                
            }.qdidZoom { scrollView in
                
            }
    }
}
