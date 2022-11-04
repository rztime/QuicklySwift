//
//  QAVPlayer.swift
//  QuicklySwift
//
//  Created by rztime on 2022/10/27.
//

import UIKit
import AVFoundation
import Photos

open class QAVPlayer: AVPlayer {
    open var qurl: String?
    open var qasset: PHAsset?
    open weak var qlayer: AVPlayerLayer?
    /// 改了item之后的回调
    open var qitemChanged: ((QAVPlayerItem?) -> Void)?  { didSet { self.qitemChanged?(self.currentItem as? QAVPlayerItem) }}
    /// 播放、暂停
    open var qisPlaying: Bool = false { didSet { self.qisPlayingBlock?(qisPlaying) }}
    open var qcurrentTime: CMTime? { didSet { self.qcurrentTimeBlock?(qcurrentTime) }}
    /// 播放暂停状态改变的回调
    open var qisPlayingBlock: ((_ isPlaying: Bool) -> Void)? { didSet { self.qisPlayingBlock?(qisPlaying) }}
    open var qcurrentTimeBlock: ((_ currentTime: CMTime?) -> Void)? { didSet { self.qcurrentTimeBlock?(qcurrentTime) }}
    /// 是否是加载中
    open var qisLoading = true { didSet { self.qisLoadingBlock?(qisLoading) }}
    open var qisLoadingBlock: ((_ loading: Bool) -> Void)? { didSet { self.qisLoadingBlock?(qisLoading) }}
    
    private var timeOBS: Any?
    
    public override init() {
        super.init()
        let reset = { [weak self] in
            let player = AVPlayerLayer.init(player: self)
            self?.qlayer = player
            self?.qlayer?.videoGravity = .resizeAspect
        }
        reset()
        self.addObserver(self, forKeyPath: "timeControlStatus", options: [.new, .old], context: nil)
        self.timeOBS = self.addPeriodicTimeObserver(forInterval: .init(value: 500, timescale: 1000), queue: .main) { [weak self] time in
            self?.qcurrentTime = time
        }
    }
    open func qplayWith(url: String? = nil, or asset: PHAsset? = nil) {
        self.qurl = url
        self.qasset = asset
        if let u = url, let U = URL.init(string: u) {
            self.qisLoading = true
            let a = AVURLAsset.init(url: U)
            a.loadValuesAsynchronously(forKeys: ["playable"]) { [weak self] in
                DispatchQueue.main.async {
                    self?.qisLoading = false
                    self?.qplayWith(item: .init(asset: a))
                }
            }
        } else if let a = asset, a.mediaType == .video {
            let option = PHVideoRequestOptions.init()
            option.isNetworkAccessAllowed = true
            self.qisLoading = true
            option.progressHandler = { (p, _, _, _) in
                print("----- icloud download:\(p)")
            }
            PHImageManager.default().requestAVAsset(forVideo: a, options: option) { [weak self] (av, _, _) in
                self?.qisLoading = false
                if let av = av {
                    self?.qplayWith(item: .init(asset: av))
                } else {
                    self?.qplayWith(item: nil)
                }
            }
        } else {
            self.qplayWith(item: nil)
        }
    }
    open func qplayWith(item: QAVPlayerItem?) {
        self.qitemChanged?(item)
        self.replaceCurrentItem(with: item)
        item?.addObservers()
    }
    open func qseek(to time: CMTime, complete: ((Bool) -> Void)?) {
        self.currentItem?.seek(to: time, completionHandler: complete)
    }
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let key = keyPath else { return }
        switch key {
        case "timeControlStatus":
            self.qisPlaying = !(self.timeControlStatus == .paused)
        default:
            break;
        }
    }
    deinit {
        print("!111")
    }
}
