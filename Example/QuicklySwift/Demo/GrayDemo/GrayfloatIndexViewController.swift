//
//  GrayfloatIndexViewController.swift
//  QuicklySwift_Example
//
//  Created by rztime on 2022/12/20.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import QuicklySwift

class GrayfloatIndexViewController: UIViewController {
    let tableView = UITableView.init(frame: .zero, style: .plain)
    
    let source:[(String, AnyClass)] = [
        ("飘灰 常规", GrayfloatVC1.self),
        ("飘灰 tableview 前10行", GrayfloatVC2.self),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.view.qbody([
            tableView.qmakeConstraints({ make in
                make.edges.equalToSuperview()
            })
        ])
        
        tableView
            .qregister(UITableViewCell.self, identifier: "cell")
            .qnumberofRows({ [weak self] section in
                return self?.source.count ?? 0
            })
            .qheightForRow { indexPath in
                return 80
            }.qcell { [weak self] tableView, indexPath in
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? .init(style: .subtitle, reuseIdentifier: "cell")
                cell.accessoryType = .disclosureIndicator
                let item = self?.source[indexPath.row]
                cell.textLabel?.text = item?.0
                cell.textLabel?.textColor = .blue
                cell.detailTextLabel?.text = "\(String(describing: item?.1.self)))"
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
