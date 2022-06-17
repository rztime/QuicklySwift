//
//  CollectionViewDemoViewController.swift
//  QuicklySwift_Example
//
//  Created by rztime on 2022/6/10.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import QuicklySwift

class CollectionViewDemoViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.qbackgroundColor(.white)
        
        let layout = UICollectionViewFlowLayout.init()
        layout.qitemSize(.init(width: CGFloat.qscreenWidth / 2 - 10, height: .qscreenHeight / 3 - 10))
            .qscrollDirection(.vertical)
            .qminimumLineSpacing(10)
            .qminimumInteritemSpacing(5)
        
        let collectionView = UICollectionView.init(frame: .qfull, collectionViewLayout: layout)
            .qbackgroundColor(.white)
            .qregistercell(TestCollectionViewCell.self, "cell")
            .qnumberofSections {
                return 3
            }.qnumberofRows { section in
                return 10
            }.qcell { collectionView, indexPath in
                let cell: TestCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TestCollectionViewCell
                cell.qbackgroundColor(.random)
                cell.fromeLable.text = "@来自chengdu"
                cell.contentLabel.text = "ad烧烤里解放啦开始减肥垃圾分类看挨少了看地方"
                cell.timeLabel.text = "03:22"
                return cell
            }.qdidSelectItem { collectionView, indexPath in
                UIAlertController.qwith(title: "点击了", "\(indexPath)", actions: ["ok"], cancelTitle: "no", style: .alert) { index in
                    print("index:\(index) ok")
                } cancel: {
                    print("nononono")
                }
            }
        self.view.qbody([
            collectionView.qmakeConstraints({ make in
                make.edges.equalToSuperview()
            })
        ])
        let actions = ["按钮1", "按钮2", "按钮3"]
        UIAlertController.qwith(title: "标题", "提示内容", actions: actions, cancelTitle: "取消", style: .alert) { index in
            print("点击了\(actions[index])， index是取自数组下标")
        } cancel: {
            print("点击了取消")
        }
    }
}

class TestCollectionViewCell : UICollectionViewCell {
    let btn1 = UIButton.init(type: .custom).qcornerRadius(20, true).qbackgroundColor(.red).qtitle("点赞")
    let btn2 = UIButton.init(type: .custom).qcornerRadius(20, true).qbackgroundColor(.blue).qtitle("关注")
    let btn3 = UIButton.init(type: .custom).qcornerRadius(20, true).qbackgroundColor(.yellow).qtitle("评论")
    let btn4 = UIButton.init(type: .custom).qcornerRadius(20, true).qbackgroundColor(.random).qtitle("分享")
    
    let fromeLable = UILabel().qtextColor(.white).qfont(.systemFont(ofSize: 15)).qnumberOfLines(0)
    let contentLabel = UILabel().qtextColor(.white).qfont(.systemFont(ofSize: 14)).qnumberOfLines(0)
    
    let timeLabel = UILabel().qfont(.systemFont(ofSize: 12)).qtextColor(.qhex(0xcccccc, a: 0.8))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let right = VStackView.qbody([btn1, btn2, btn3, btn4])
        [btn1, btn2, btn3, btn4].forEach { btn in
            btn.snp.makeConstraints { make in
                make.size.equalTo(40)
            }
        }
        let content = VStackView.qbody([fromeLable, UIView(), contentLabel, timeLabel])
        
        self.contentView.qbody([
            right.qmakeConstraints({ make in
                make.right.equalToSuperview().inset(10)
                make.bottom.equalToSuperview().inset(15)
            }),
            content.qmakeConstraints({ make in
                make.left.equalToSuperview().inset(15)
                make.bottom.equalTo(right)
                make.right.lessThanOrEqualTo(right.snp.left).offset(-15)
            })
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
