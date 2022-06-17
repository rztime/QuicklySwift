//
//  FriendView.swift
//  QuicklySwift_Example
//
//  Created by rztime on 2022/6/17.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import QuicklySwift
struct Model {
    var name = "rztime"
    var time = Date().qnoraml
    
    let ip = ["成都", ""][Int.random(in: 0..<2)]
    let content = [
        "",
        """
        "据路透社16日报道，麦当劳同意支付约12.9亿美元（约合人民币87亿元）的罚款以及拖欠税款，与法国就税务纠纷达成和解协议，但不认罪。
        
        2014年，因怀疑麦当劳违法将在法国的收入转移到国外公司以避税，法国税务官员开始对其进行调查。据法国媒体报道，法国税务官员当时正在审查一笔寄给麦当劳在卢森堡一家子公司的特许权使用费。麦当劳当时否认有任何不当行为。
        """,
        """
        "来源：央视财经
        
        【来源：环球时报】
        
        声明：转载此文是出于传递更多信息之目的。若有来源标注错误或侵犯了您的合法权益，请作者持权属证明与本网联系，我们将及时更正、删除，谢谢。 邮箱地址：newmedia@xxcb.cn"
        """,
        
        "腾讯下架 QQ 影音所有版本冲上了微博热搜。",
        
        "不少网友反馈，腾讯 QQ 影音官方网站显示，QQ 影音各大平台的版本都已经下架，该软件的 PC、Mac、安卓、iOS 版本均已不可下载，为“敬请期待”状态。并且，页面没有任何关于软件的功能介绍信息。"
        
    ][Int.random(in: 0..<5)]
    let images = [
        [""],
        ["1"],
        ["1", "2"],
        ["1", "2", "3"],
        ["1", "2", "3", "4"],
        ["1", "2", "3", "4", "5"],
        ["1", "2", "3", "4", "5", "6"],
        ["1", "2", "3", "4", "5", "6", "7"],
        ["1", "2", "3", "4", "5", "6", "7", "8"],
        ["1", "2", "3", "4", "5", "6", "7", "8", "9"],
        ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"],
        ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11"],
    ][Int.random(in: 0..<11)]
    
    let isfollow = [true, false][Int.random(in: 0..<2)]
    
    let flag = ["", "热门", "推荐", "已关注的话题", "1 2  3"][Int.random(in: 0..<5)]
}

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
    let collectionView = UICollectionView.init(frame: .init(x: 0, y: 0, width: .qscreenWidth - 30, height: CGFloat.qscreenWidth / 3), collectionViewLayout: .init())
    
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
                let width = (CGFloat.qscreenWidth - 30 - 20) / 3
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
