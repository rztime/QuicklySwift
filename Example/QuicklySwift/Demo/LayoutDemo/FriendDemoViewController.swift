//
//  FriendDemoViewController.swift
//  QuicklySwift_Example
//
//  Created by rztime on 2022/6/17.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import QuicklySwift

class FriendDemoViewController: UIViewController {
    
    let tableView = UITableView.init(frame: .qfull, style: .plain)
    
    var models:[Model] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.view.qbody([
            tableView.qmakeConstraints({ make in
                make.edges.equalToSuperview()
            })
        ])
        
        for _ in 0 ..< 100 {
            models.append(.init())
        }
        
        tableView
            .qseparatorStyle(.none)
            .qnumberofRows { [weak self] section in
                return self?.models.count ?? 0
            }.qcell { [weak self] tableView, indexPath in
                let cell = (tableView.dequeueReusableCell(withIdentifier: "cell") as? FriendCell) ?? FriendCell.init(style: .default, reuseIdentifier: "cell")
                let model = self?.models[qsafe: indexPath.row]
                cell.setItem(model: model)
                return cell
            }.qdidSelectRow { tableView, indexPath in
                tableView.deselectRow(at: indexPath, animated: false)
                
            }
        
        let btn = UIButton.init(type: .custom).qtitle("刷新").qtitleColor(.red)
        self.navigationItem.rightBarButtonItem = .init(customView: btn)
        btn.qtap { [weak self] view in
            self?.tableView.reloadData()
        }
    }
}

class FriendCell: UITableViewCell {
    let headerView : HeaderView = .init(frame: .init(x: 0, y: 0, width: qscreenwidth, height: 70))
    let contentLabel = UILabel().qfont(.systemFont(ofSize: 15)).qnumberOfLines(5).qshowType(.vertical, type: .height)
    let imageContainer = ImageContainerView.init(frame: .init(x: 0, y: 0, width: qscreenwidth, height: 100))
    
    let flagLabel = UILabel().qnumberOfLines(0).qfont(.systemFont(ofSize: 13)).qtextColor(.red)
    
    let bottomView = FriendBottomView.init(frame: .init(x: 0, y: 0, width: qscreenwidth, height: 50))
    override func prepareForReuse() {
        super.prepareForReuse()
        contentLabel.text = nil
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let v = VStackView.qbody([
            headerView,
            contentLabel,
            imageContainer,
            flagLabel,
            bottomView.qmakeConstraints({ make in
                make.height.equalTo(40).priorityHigh()
            }),
        ]).qspacing(10)
            .qdistribution(.fill)
        self.contentView.qbody([
            v.qmakeConstraints({ make in
                make.top.bottom.equalToSuperview().inset(10)
                make.left.equalTo(15)
                make.width.equalTo(qscreenwidth - 30)
            }),
            // 分割线
            UIView().qmakeConstraints({ make in
                make.left.right.bottom.equalToSuperview()
                make.height.equalTo(10)
            }).qbackgroundColor(.lightGray.withAlphaComponent(0.2))
        ])

    }
    
    func setItem(model: Model?) {
        self.headerView.imageView.image = UIImage.init(named: "1111")
        self.headerView.nameLable.text = model?.name
        self.headerView.timeLabel.text = model?.time
        self.headerView.ipLabel.text = model?.ip
        self.headerView.ipLabel.isHidden = model?.ip.isEmpty ?? true
        self.headerView.followBtn.isSelected = model?.isfollow ?? false
        
        /// 如果没有内容，隐藏
        self.contentLabel.text = model?.content
        self.contentLabel.isHidden = model?.content.isEmpty ?? true
        
        var imgs = model?.images
        if let images = model?.images, images.count == 1, images.first == "" {
            imgs = []
        }
        self.imageContainer.images =  imgs
        /// 如果没有图片，隐藏
        self.imageContainer.isHidden = imgs?.count == 0
        
        /// 没有标签 隐藏
        self.flagLabel.text = model?.flag
        self.flagLabel.isHidden = model?.flag.isEmpty ?? true
        
        // 已关注 隐藏
        self.bottomView.followBtn.isHidden = model?.isfollow ?? false
        
        self.contentView.qtap { view in
            print("111111111")
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
