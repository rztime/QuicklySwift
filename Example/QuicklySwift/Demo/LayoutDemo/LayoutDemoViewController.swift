//
//  LayoutDemoViewController.swift
//  QuicklySwift_Example
//
//  Created by rztime on 2022/6/20.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import QuicklySwift

class LayoutDemoViewController: UIViewController {
    
    var model = Model()
    
    let textLabel = UILabel().qnumberOfLines(0).qfont(.systemFont(ofSize: 16, weight: .medium))
    let imageViewStackView = VStackView.qbody([]).qspacing(10)
    let timeLabel = UILabel().qfont(.systemFont(ofSize: 12)).qtextColor(.lightGray)
    let ipLabel = UILabel().qfont(.systemFont(ofSize: 12)).qtextColor(.lightGray)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.qbody([
            VStackView.qbody([
                textLabel,
                imageViewStackView,
                
                HStackView.qbody([timeLabel, ipLabel]).qspacing(10)
            ])
            .qspacing(15)
            .qalignment(.leading)
            .qmakeConstraints({ make in
                make.left.right.equalToSuperview().inset(15)
                make.top.equalToSuperview().inset(qnavigationbarHeight + 15)
            })
        ])
        
        let btn = UIButton.init(type: .custom).qtap { [weak self] view in
            self?.reload()
        }.qtitle("刷新").qtitleColor(.red)
        self.navigationItem.rightBarButtonItem = .init(customView: btn)
        
        self.reload()
    }
    func reload() {
        model = Model()
        textLabel.text = model.content
        textLabel.isHidden = model.content.isEmpty
        
        imageViewStackView.qremoveAllSubViews()
        let images = model.images.qgroup(step: 3)
        let size: CGSize = images.first?.count == 1 ? .init(width: 250, height: 250 * 9 / 16) : .init(width: (qscreenwidth - 30 - 20) / 3, height: (qscreenwidth - 30 - 20) / 3)
        
        let imageViews = images.compactMap { urls -> UIStackView? in
            let view = urls.compactMap { url -> UIImageView? in
                if url.isEmpty {
                    return nil
                }
                let imageView = UIImageView.init()
                    .qcontentMode(.scaleAspectFill)
                    .qcornerRadius(3, true)
                    .qmakeConstraints { make in
                        make.size.equalTo(size)
                    }
                imageView.image = UIImage.init(named: "1111")
                return imageView
            }
            if view.isEmpty { return nil}
            return HStackView.qbody(view).qspacing(10)
        }
        
        imageViewStackView.qbody(
            imageViews
        ).qalignment(.leading).qspacing(10)
        
        imageViewStackView.isHidden = images.isEmpty
        
        timeLabel.text = model.time
        timeLabel.isHidden = model.time.isEmpty
        
        ipLabel.text = model.ip
        ipLabel.isHidden = model.ip.isEmpty
    }
}
