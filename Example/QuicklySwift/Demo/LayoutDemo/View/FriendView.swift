//
//  FriendView.swift
//  QuicklySwift_Example
//
//  Created by rztime on 2022/6/17.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import QuicklySwift

class HeaderView: UIView {
    let imageView = UIImageView.init(frame: .init(x: 0, y: 0, width: 50, height: 50)).qcontentMode(.scaleAspectFit).qcornerRadius(25, true)
    let nameLable = UILabel().qfont(.systemFont(ofSize: 16))
    let timeLabel = UILabel().qfont(.systemFont(ofSize: 12)).qtextColor(.lightGray)
    
    let followBtn = UIButton.init(type: .custom).qtitle("+关注", .normal).qtitle("已关注", .selected).qtitleColor(.red).qfont(.systemFont(ofSize: 15))
    let ipLabel = UILabel().qfont(.systemFont(ofSize: 10)).qtextColor(.lightGray)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let v1 = VStackView.qbody([nameLable, timeLabel])
        let v2 = VStackView.qbody([followBtn, ipLabel]).qalignment(.trailing)
        let h1 = HStackView.qbody([
            imageView.qmakeConstraints({ make in
                make.width.equalTo(50)
                make.height.equalTo(50).priorityHigh() // 设置优先级，消除debug提示
            }),
            v1,
            v2.qmakeConstraints({ make in
                make.right.equalToSuperview()
            }),
        ]).qdistribution(.fill)
            .qspacing(10)
        
        self.qbody([
            h1.qmakeConstraints({ make in
                make.edges.equalToSuperview()
            })
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class ImageContainerView: UIView {
    let collectionView = UICollectionView.init(frame: .init(x: 0, y: 0, width: qscreenwidth - 30, height: qscreenwidth / 3), collectionViewLayout: .init())
    
    var images:[String]? {
        didSet {
            collectionView.reloadData()
            self.layoutIfNeeded() // 这一步是计算出contentsize
            self.snp.remakeConstraints { make in
                make.height.equalTo(collectionView.contentSize.height).priorityHigh()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.qbody([
            collectionView.qmakeConstraints({ make in
                make.edges.equalToSuperview()
            })
        ])
        self.snp.makeConstraints { make in
            make.height.equalTo(0).priorityHigh()
        }
        let layout = UICollectionViewFlowLayout.init()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        collectionView.setCollectionViewLayout(layout, animated: false)
        
        collectionView
            .qisScrollEnabled(false)
            .qshowsVerticalScrollIndicator(false)
            .qshowsHorizontalScrollIndicator(false)
            .qregistercell(ImageCell.self, "cell")
            .qnumberofRows { [weak self] section in
                return self?.images?.count ?? 0
            }.qsizeForItem({ [weak self] (layout, indexPath) in
                if let images = self?.images, images.count <= 1 {
                    return .init(width: 160, height: 90)
                }
                let width = (qscreenwidth - 30 - 20) / 3
                return .init(width: width, height: width)
            }).qcell { collectionView, indexPath in
                let cell: ImageCell = (collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCell)
                cell.imageView.image = UIImage.init(named: "1111")
                return cell
            }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class ImageCell: UICollectionViewCell {
        lazy var imageView: UIImageView = .init().qcontentMode(.scaleAspectFill)
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.contentView.qbody([
                imageView.qmakeConstraints({ make in
                    make.edges.equalToSuperview()
                })
            ])
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
class FriendBottomView: UIView {
    let shareBtn = UIButton.init(type: .custom).qtitle("分享").qtitleColor(.black).qfont(.systemFont(ofSize: 12))
    let commentBtn = UIButton.init(type: .custom).qtitle("评论").qtitleColor(.black).qfont(.systemFont(ofSize: 12))
    let zanBtn = UIButton.init(type: .custom).qtitle("点赞").qtitleColor(.black).qfont(.systemFont(ofSize: 12))
    let followBtn = UIButton.init(type: .custom).qtitle("关注").qtitleColor(.black).qfont(.systemFont(ofSize: 12))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let h = HStackView.qbody([
            shareBtn,
            commentBtn,
            zanBtn,
            followBtn,
        ]).qspacing(30)
            .qdistribution(.fillEqually)
        
        self.qbody([
            h.qmakeConstraints({ make in
                make.edges.equalToSuperview().priorityHigh()
            }),
            UIView().qmakeConstraints({ make in
                make.top.left.right.equalToSuperview()
                make.height.equalTo(1)
            }).qbackgroundColor(.lightGray.withAlphaComponent(0.3))
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
