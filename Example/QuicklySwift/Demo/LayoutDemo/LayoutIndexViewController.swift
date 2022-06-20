//
//  LayoutIndexViewController.swift
//  QuicklySwift_Example
//
//  Created by rztime on 2022/6/20.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import QuicklySwift

class LayoutIndexViewController: UIViewController {
    let tableview = UITableView.init(frame: .qfull, style: .plain)
    
    let source: [(String, AnyClass)] = [
        ("快速布局", QuickLayoutViewController.self),
        ("布局 demo 1", LayoutDemoViewController.self),
        ("朋友圈 demo 2", FriendDemoViewController.self),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.view.qbody([
            tableview.qmakeConstraints({ make in
                make.edges.equalToSuperview()
            })
        ])
        tableview.qnumberofRows { [weak self] section in
            return self?.source.count ?? 0
        }.qheightForRow { indexPath in
            return 80
        }.qcell { [weak self] tableView, indexPath in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? .init(style: .subtitle, reuseIdentifier: "cell")
            cell.accessoryType = .disclosureIndicator
            let item = self?.source[indexPath.row]
            cell.textLabel?.text = item?.0
            cell.detailTextLabel?.text = "\(String(describing: item?.1.self)))"
            print("-------- cell\(cell.frame)")
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
    } 
}
