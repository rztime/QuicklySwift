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
        ("飘灰demo", GrayfloatIndexViewController.self),
        ("布局", LayoutIndexViewController.self),
        ("基础控件的方法", BaseViewDemoViewController.self),
        ("列表", TableViewDemoViewController.self),
        ("collectionView", CollectionViewDemoViewController.self),
        ("快速开发", QuicklyDemoViewController.self),
        ("动画测试", AnimateDemoViewController.self),
        ("LED", LedDemoViewController.self),
        ("push pop 转场", TransitionOneViewController.self),
        ("avplayer", AVPlayerViewController.self),
        ("渐变", GradientLayerViewController.self),
        ("dispath", DispatchViewController.self),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "首页"
        self.view.backgroundColor = .white

        self.view.qbody([
            tableView.qmakeConstraints({ make in
                make.edges.equalToSuperview()
            }),
            UIButton.init().qbackgroundColor(.red)
                .qmakeConstraints({ make in
                    make.bottom.right.equalToSuperview()
                    make.size.equalTo(100)
                })
                .qtap({ [weak self] view in
                    self?.tableView.reloadRows(at: [.init(row: 1, section: 0)], with: .automatic)
                })
        ])
        tableView.qnumberofRows { [weak self] section in
            return self?.source.count ?? 0
        }.qheightForRow { indexPath in
            return 80
        }.qcell { [weak self] (tableView, indexPath) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? TestCell.init(style: .subtitle, reuseIdentifier: "cell")
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
                vc.qdidpop {
                    print("被pop")
                }.qwillAppear(2) {
                    print("willapper 只调用2次")
                }.qwillDisAppear {
                    print("willDisAppear")
                }.qdeinit {
                    print("被释放")
                }
            }
        }
    }
}
class TestCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
