//
//  AVPlayerViewController.swift
//  QuicklySwift_Example
//
//  Created by rztime on 2022/10/19.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import QuicklySwift
import SnapKit

class AVPlayerViewController: UIViewController {
//    lazy var player = QuicklyAVPlayer.init(frame: .zero, target: self)
    var player = QuicklyAVPlayer.init(frame: .qfull, options: .init(options: [.pauseAtFirst, .repeatPlay(count: 2)]))
    
    let leftLabel = UILabel()
    let rightLable = UILabel()
    
    let errorLabel = UILabel()
    let loadLabel = UILabel()
    
    let playBtn = UIButton.init(type: .custom).qtitle("播放").qtitle("暂停", .selected).qbackgroundColor(.red)

    override func viewDidLoad() {
        super.viewDidLoad()
        let btn = UIButton.init(type: .custom)
        btn.qtitle("下一个")
            .qtap { view in
                qAppFrame.pushViewController(AVPlayerViewController.init())
            }
        self.navigationItem.rightBarButtonItem = .init(customView: btn)
        self.view.backgroundColor = .white
        self.view.qbody([
            player.qmakeConstraints({ make in
                make.edges.equalToSuperview()
            }),
            VStackView.qbody([
                leftLabel,
                rightLable,
                errorLabel,
                loadLabel,
                playBtn
            ]).qbackgroundColor(.init(white: 1, alpha: 0.4))
            .qdistribution(.fill)
                .qspacing(20)
                .qmakeConstraints({ make in
                    make.center.equalToSuperview()
                    make.width.equalTo(320)
                })
        ])
        
//        if let p = player.qlayer {
//            self.view.layer.insertSublayer(p, at: 0)
//            p.frame = self.view.bounds
//        }
        player.placeholderView.image = UIImage.init(named: "1111")
        player.qplayWith(url: "https://img01.thecover.cn/E5682F0B5454428EA0105E1C735E5E1D.mp4")
        
        playBtn.qtap { [weak self] _ in
            if let p = self?.player.options.isPlaying, p == true {
                self?.player.qpause()
            } else {
                self?.player.qplay()
            }
        }

//        player.option.currentTimeChanged { [weak self] currentTime in
//            print("----time:\(currentTime?.seconds ?? 0) isplaying:\(self?.player.option.isPlaying ?? false)")
//        }
//        player.option.isBufferingChanged { isBuffering in
//            print("------isbuffering:\(isBuffering)")
//        }
//        player.option.isTimeOutChanged { isTimeOut in
//            if isTimeOut {
//                print("-------------timeOut:\(isTimeOut) 超时")
//            }
//        }
////        player.repeatPlay = true
//        player.showFirstFrameWhenPlayEnd = true
//        player.play(url: "https://img01.thecover.cn/E5682F0B5454428EA0105E1C735E5E1D.mp4")
//        // Do any additional setup after loading the view.
//        player.playerItemStatusBlock = { status in
//            print("----status:\(status.rawValue)")
//        }
//        player.totalTimeBlock = { [weak self] time in
////            print("------ totoal: \(time?.seconds ?? 0)")
//            self?.rightLable.text = "时长：\(time?.seconds ?? 0)"
//        }
//        player.currentTimeBlock = { [weak self] time in
//            self?.leftLabel.text = "\(Int(time?.seconds ?? 0))"
//        }
//        player.playEndBlock = { isPlayEnd in
//            print("------- 播放结束: \(isPlayEnd)")
//        }
//        player.isBufferingBlock = { [weak self] isbuffer in
//            self?.loadLabel.text = isbuffer ? "缓冲中" : "缓冲结束"
//        }
//        player.loadedTimeRangeBlock = { [weak self] timeRange in
//            if let self = self, let t = timeRange {
//                self.loadLabel.text = "\(self.player.isBuffering ? "缓冲中" : "缓冲结束") \(t.start.seconds + t.duration.seconds)"
//                print("---- 缓冲量：\(t.start.seconds + t.duration.seconds)")
//            }
//        }
//        player.isTimeoutBlock = { timeout in
//            if timeout {
//                print("网络连接校慢, 请检查网络")
//            } else {
//                print("恢复正常")
//            }
//        }
//        player.errorBlock = { [weak self] error in
//            self?.errorLabel.text = "\(error?.localizedDescription ?? "")"
//        }
//        player.isPlayingBlock = { [weak self] isPlaying in
//            self?.playBtn.isSelected = isPlaying
//        }
        self.qwillDisAppear { [weak self] in
            self?.player.qisActiviting = false
        }
        self.qwillAppear { [weak self] in
            self?.player.qisActiviting = true
        }
    }
}
