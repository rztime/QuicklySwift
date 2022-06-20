//
//  TableViewDemoViewController.swift
//  QuicklySwift_Example
//
//  Created by rztime on 2022/6/8.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import QuicklySwift

class TableViewDemoViewController: UIViewController {
    
    var items: [Model] = []
    
    let tableView = UITableView.init(frame: .qfull, style: .plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        let btn = UIButton.init(type: .custom)
            .qtitle("编辑")
            .qtitleColor(.red)
            .qactionFor(.touchUpInside) { [weak self] sender in
                guard let self = self else { return }
                let edit = self.tableView.isEditing
                self.tableView.setEditing(!edit, animated: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.tableView.reloadData()
                }
            }
        self.navigationItem.rightBarButtonItem = .init(customView: btn)
        
        for _ in 0..<40 {
            items.append(.init())
        }
        
        self.view.qbody([
            tableView.qmakeConstraints({ make in
                make.edges.equalToSuperview()
            })
        ])
        
        tableView
            .qregister(TestTableViewCell.self, identifier: "cell")
            .qnumberofSections {
                return 1
            }.qnumberofRows { [weak self] section in
                return self?.items.count ?? 0
            }.qcell { [weak self] tableView, indexPath in
                let cell: TestTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TestTableViewCell) ?? .init(style: .default, reuseIdentifier: "cell")
                let item = self?.items[qsafe: indexPath.row]
                cell.nameLabel.text = item?.content
                cell.timeLabel.text = item?.time
                cell.cover.isHidden = item?.images.filter({!$0.isEmpty}).isEmpty ?? true
                return cell
            }.qdidSelectRow { tableView, indexPath in
                tableView.deselectRow(at: indexPath, animated: false)
                print("---- selected:\(indexPath)")
            }
            .qcanEdit { indexPath in
                return true
            }.qcanMove { indexPath in
                return true
            }.qeditActions { indexPath in
                let aciton = UITableViewRowAction.init(style: .default, title: "删除") { _, indexPath in
                    
                }
                return [aciton]
            }
            .qcontentSizeChanged { scrollView in
                print("contentsize changed 改变")
            }.qcontentOffsetChanged { scrollView in
                print("contentoffset changed 改变")
            }.qdidScroll { scrollView in
                print("scrollView 滚动")
            }.qdidEndScroll { scrollView in
                print("scrollView 停止滚动")
            }
    }
    deinit {
        print("----\(self.classForCoder) deinit")
    }
}

class TestTableViewCell: UITableViewCell {
    let nameLabel = UILabel().qfont(.systemFont(ofSize: 16)).qtextColor(.qhex(0x555555)).qnumberOfLines(0)
    let timeLabel = UILabel().qfont(.systemFont(ofSize: 12)).qtextColor(.qhex(0xcccccc))
    let cover = UIImageView().qcornerRadius(5, true).qbackgroundColor(.qhex(0xeeeeee, a: 0.7))
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        timeLabel.text = nil
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let s1 = VStackView.qbody([nameLabel, timeLabel]).qspacing(10)
        let c = HStackView.qbody([
            s1.qmakeConstraints({ make in
                make.height.equalToSuperview() // 设置高度约束，保证当name过短的时候，timelabel底部和cover底部对齐
            }),
            cover.qmakeConstraints({ make in
                make.width.equalTo(160)
                make.height.equalTo(90).priorityLow()
            })])
            .qalignment(.top)
        self.contentView.qbody([
            c.qmakeConstraints({ make in
                make.edges.equalToSuperview().inset(15)
            })
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


