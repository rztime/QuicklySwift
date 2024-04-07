//
//  QPlayerTestViewController.swift
//  QuicklySwift_Example
//
//  Created by rztime on 2024/4/1.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit
import QuicklySwift
import AVFAudio

class QPlayerTestViewController: UIViewController {
    let player = QPlayer.init()
    let obj = NSObject()
    /// 播放
    lazy var playBtn = UIButton(type: .custom)
        .qtitleColor(.black)
        .qtap { [weak self] view in
            let isplaying = view.isSelected
            view.isSelected = !isplaying
            view.qtitle(!isplaying ? "暂停" : "播放")
            if isplaying {
                self?.player.pause()
            } else {
                self?.player.play()
            }
        }.qthen { [weak self] btn in
            self?.player.playing.subscribe({ [weak btn] playing in
                btn?.isSelected = playing
                btn?.qtitle(playing ? "暂停" : "播放")
            }, disposebag: self?.obj)
        }
    lazy var rateBtn = UIButton(type: .custom)
        .qtitleColor(.black)
        .qtap { [weak self] view in
            let titles = ["5", "4", "3", "2", "1", "0.5", "0", "-1", "-2"]
            QuicklyPopmenu.show(titles: titles, style: .vertical, referto: .init(x: 85, y: 356), complete: { [weak view] index in
                if index < 0 {
                    return
                }
                let r = titles[index].qasNSString.floatValue
                view?.qtitle("\(r)x")
                self?.player.rate = r
            })
        }.qthen { [weak self] btn in
            btn.qtitle("\(self?.player.rate ?? 1)x")
        }
    ///  静音
    lazy var muteBtn = UIButton(type: .custom)
        .qtitleColor(.black)
        .qtap { [weak self] view in
            let ismute = !view.isSelected
            view.isSelected = ismute
            view.qtitle(ismute ? "取消静音" : "静音")
            self?.player.isMuted = ismute
        }.qthen { [weak self] btn in
            btn.isSelected = self?.player.isMuted ?? false
            btn.qtitle(btn.isSelected ? "取消静音" : "静音")
        }
    /// 状态
    lazy var statusLabel = UILabel()
        .qthen { [weak self] label in
            self?.player.status.subscribe({ [weak label] status in
                switch status {
                case .failed:
                    label?.text = "statusLabel: failed"
                case .unknown:
                    label?.text = "statusLabel: unknow"
                case .readyToPlay:
                    label?.text = "statusLabel: readyToplay"
                @unknown default:
                    break
                }
            }, disposebag: self?.obj)
        }
    
    lazy var currentLabel = UILabel()
        .qthen { [weak self] label in
            self?.player.currentTime.subscribe({ [weak label] time in
                label?.text = "current: \(time?.seconds.qtohms ?? "00:00")"
            }, disposebag: self?.obj)
        }
    lazy var durationLabel = UILabel()
        .qthen { [weak self] label in
            self?.player.duration.subscribe({ [weak label] time in
                label?.text = "duration: \(time?.seconds.qtohms ?? "00:00")"
            }, disposebag: self?.obj)
        }
    lazy var pressSlider: UISlider = .init()
        .qthen { [weak self] slider in
            slider.maximumValue = 1
            slider.minimumValue = 0
            slider.value = 0
            slider.qactionFor(.valueChanged) { [weak self] sender in
                self?.player.seek(progress: sender.value, complete: nil)
            }
            self?.player.currentTime.subscribe({ [weak self, weak slider] value in
                if let c = self?.player.currentTime.value, let d = self?.player.duration.value, d.seconds > 0 {
                    slider?.value = Float(c.seconds / d.seconds)
                } else {
                    slider?.value = 0
                }
            }, disposebag: self?.obj)
        }
    lazy var sizeLabel = UILabel()
        .qthen { [weak self] label in
            self?.player.mediaSize.subscribe({ [weak label] size in
                label?.text = "size: \(size ?? .zero)"
            }, disposebag: self?.obj)
        }
    lazy var loadingLabel = UILabel()
        .qthen { [weak self] label in
            self?.player.isLoading.subscribe({ [weak label] load in
                label?.text = "isload: \(load)"
            }, disposebag: self?.obj)
        }
    lazy var seekLabel = UILabel()
        .qthen { [weak self] label in
            self?.player.isSeeking.subscribe({ [weak label] seek in
                label?.text = "isseeking: \(seek)"
            }, disposebag: self?.obj)
        }
    lazy var errorLabel = UILabel()
        .qthen { [weak self] label in
            self?.player.error.subscribe({ [weak label] error in
                label?.text = "error: \(error?.localizedDescription ?? "")"
            }, disposebag: self?.obj)
        }
    lazy var endLabel = UILabel()
        .qthen { [weak self] label in
            self?.player.playEnd.subscribe({ [weak label] end in
                label?.text = "end: \(end)"
            }, disposebag: self?.obj)
        }
    lazy var loadRangeLabel = UILabel()
        .qthen { [weak self] label in
            self?.player.loadRange.subscribe({ [weak label] loadrange in
                label?.text = "已加载: \(loadrange.qlength.qtohms)s"
            }, disposebag: self?.obj)
        }
    lazy var volumeLabel = UILabel()
    lazy var volumeSlider: UISlider = .init()
        .qthen { [weak self] in
            $0.maximumValue = 1
            $0.minimumValue = 0
            $0.value = self?.player.volume ?? 0
            $0.qactionFor(.valueChanged) { [weak self] sender in
                self?.player.volume = sender.value
                self?.volumeLabel.text = "音量：\(sender.value)"
            }
            self?.volumeLabel.text = "音量：\(self?.player.volume ?? 0)"
        }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        player.autoPlay = true
//        player.isMuted = true
        player.setMedia(url: "http://vjs.zencdn.net/v/oceans.mp4".qtoURL)
        player.placeholderImageView.backgroundColor = .blue

        self.view.qbody([
            player.playerView.qmakeConstraints({ make in
                make.left.right.equalToSuperview()
                make.top.equalToSuperview().inset(100)
                make.height.equalTo(qscreenwidth * 9.0 / 16.0)
            }),
            [[playBtn, rateBtn, sizeLabel, muteBtn].qjoined(aixs: .horizontal, spacing: 10, align: .fill, distribution: .equalSpacing),
            [statusLabel, loadRangeLabel].qjoined(aixs: .horizontal, spacing: 10, align: .fill, distribution: .equalSpacing),
            [currentLabel, durationLabel].qjoined(aixs: .horizontal, spacing: 10, align: .fill, distribution: .equalSpacing),
            pressSlider,
            [loadingLabel, seekLabel].qjoined(aixs: .horizontal, spacing: 10, align: .fill, distribution: .equalSpacing),
            errorLabel,
            endLabel,
            volumeLabel,
            volumeSlider]
                .qjoined(aixs: .vertical, spacing: 10, align: .fill, distribution: .equalSpacing)
                .qmakeConstraints({ make in
                    make.left.right.equalToSuperview().inset(15)
                    make.top.equalTo(self.player.playerView.snp.bottom).offset(15)
                }),
        ])
        /// 进入前后台、以及appear时，中断设置
        NotificationCenter.default.qaddObserver(name: UIApplication.willResignActiveNotification, object: nil, target: self.obj) { [weak self] notification in
            self?.player.interrupt(type: .active)
        }
        NotificationCenter.default.qaddObserver(name: UIApplication.didBecomeActiveNotification, object: nil, target: self.obj) { [weak self] notification in
            self?.player.interrupt(remove: .active)
        }
        self.qwillDisAppear { [weak self] in
            self?.player.interrupt(type: .appear)
        }
        self.qwillAppear { [weak self] in
            self?.player.interrupt(remove: .appear)
        }
    }
}
