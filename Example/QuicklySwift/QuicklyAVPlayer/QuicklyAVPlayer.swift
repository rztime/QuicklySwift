//
//  QuicklyAVPlayer.swift
//  QuicklySwift
//
//  Created by rztime on 2022/10/19.
//

import UIKit
import AVFoundation
import Photos

/// 对AVPlayer的封装
/// 可以直接使用block的回调来获取所有的播放信息变量
/// 也可以addDelegate来添加播放信息变量改变的回调
open class QuicklyAVPlayer: UIView {
    open var placeholderView: UIImageView = .init().qcontentMode(.scaleAspectFit)
    open var options: QuicklyAVPlayerOptions
    open var qurl: String?
    open var qasset: PHAsset?
    open var qisActiviting = false { didSet { self.playerActive() }}
    
    private var playerView: UIView?
    private var player: QAVPlayer?
    private var timeout: Timer?
    public init(frame: CGRect, options: QuicklyAVPlayerOptions) {
        self.options = options
        super.init(frame: frame)
        self.qbody([
            placeholderView.qmakeConstraints({ make in
                make.edges.equalToSuperview()
            })
        ])
    }
    private var repeatCount = 1
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func playerActive() {
        if !qisActiviting {
            self.removePlayer()
        } else {
            self.addPlayer()
            self.player?.qplayWith(url: self.qurl, or: self.qasset)
        }
    }
    /// 添加播放器
    func addPlayer() {
        if self.player?.error != nil { /// 播放器有误，就需要重新加载 重新播放
            self.removePlayer()
        }
        guard self.player == nil, self.playerView == nil else { return }
        self.player = .init()
        self.playerView = .init()
        self.player?.qcurrentTime = self.options.currentTime
        guard let player = self.player, let playerView = self.playerView, let layer = player.qlayer else {
            return
        }
        self.insertSubview(playerView, at: 0)
        playerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        playerView.layer.addSublayer(layer)
        playerView.qsizeChanged { [weak layer] view in
            layer?.frame = view.bounds
        }
        player.qitemChanged = { [weak self] item in
            self?.placeholderView.isHidden = false
            item?.qloadStatus = { [weak self] status in
                self?.qplayer(player: self, playerItemLoadStatus: status)
            }
            item?.qduration = { [weak self] time in
                self?.qplayer(player: self, duration: time)
            }
            item?.qerror = { [weak self] error in
                self?.qplayer(player: self, error: error)
            }
            item?.qloadedTimeRanges = { [weak self] ranges in
                self?.qplayer(player: self, loadedTimeRange: ranges)
            }
            item?.qisBuffing = { [weak self] isbuffing in
                self?.qplayer(player: self, isBuffering: isbuffing)
            }
        }
        player.qisPlayingBlock = { [weak self] isPlaying in
            self?.qplayer(player: self, isPlaying: isPlaying)
        }
        player.qcurrentTimeBlock = { [weak self] currentTime in
            self?.qplayer(player: self, currentTime: currentTime)
        }
        player.qisLoadingBlock = { [weak self] isLoading in
            self?.qplayer(player: self, isBuffering: isLoading)
        }
    }
    /// 移除播放器
    func removePlayer() {
        self.playerView?.removeFromSuperview()
        self.playerView = nil
        self.player = nil
    }
}
public extension QuicklyAVPlayer {
    /// 播放视频资源
    func qplayWith(url: String? = nil, or asset: PHAsset? = nil) {
        defer {
            self.qurl = url
            self.qasset = asset
            self.playerActive()
        }
        if url == self.qurl && asset == self.qasset, self.player?.error == nil {
            return
        }
        /// 还原信息
        self.timeout?.invalidate()
        self.repeatCount = 1
        self.qplayer(player: self, playerItemLoadStatus: .unknown)
        self.qplayer(player: self, duration: nil)
        self.qplayer(player: self, error: nil)
        self.qplayer(player: self, isPlayedEnd: false)
        self.qplayer(player: self, loadedTimeRange: nil)
        self.qplayer(player: self, isBuffering: false)
        self.qplayer(player: self, isTimeout: false)
        self.qplayer(player: self, isPlaying: false)
    }
    /// 播放
    func qplay() {
        /// 设置意愿
        self.options.setPlayingStatus(play: true)
        /// 如果有错误，则重播
        if self.player?.error != nil {
            self.addPlayer()
        } else if self.options.isPlayedEnd { /// 已经播放完毕，则重播
            self.repeatCount = 1
            self.qseek(to: .init(value: 0, timescale: 1000), complete: nil)
        }
        self.player?.play()
    }
    /// 暂停
    func qpause() {
        self.options.setPlayingStatus(play: false)
        self.player?.pause()
    }
    /// 重播
    func qreplay() {
        self.repeatCount = 1
        let zero = CMTime.init(value: 0, timescale: 1000)
        self.qplayer(player: self, currentTime: zero)
        if self.player?.error != nil {
            self.addPlayer()
        } else {
            self.qseek(to: zero, complete: nil)
        }
        self.player?.play()
    }
    /// seek
    func qseek(to time: CMTime, complete: ((Bool) -> Void)?) {
        self.player?.qseek(to: time, complete: complete)
    }
}

extension QuicklyAVPlayer: QuicklyAVPlayerDelegate {
    /// 初始化状态改变
    public func qplayer(player: QuicklyAVPlayer?, playerItemLoadStatus: AVPlayerItem.Status) {
        self.options.qplayer(player: self, playerItemLoadStatus: playerItemLoadStatus)
        self.options.qplayer(player: self, isPlayedEnd: false)
        switch playerItemLoadStatus {
        case .unknown, .failed:
            break
        case .readyToPlay:
            self.placeholderView.isHidden = true
            if let c = self.options.currentTime, c.seconds > 0 {
                self.qseek(to: c, complete: nil)
                if self.options.play {
                    self.player?.play()
                }
                break
            }
            if self.options.playAtFirst && self.options.play {
                self.player?.play()
            }
        @unknown default:
            break
        }
    }
    
    public func qplayer(player: QuicklyAVPlayer?, duration: CMTime?) {
        self.options.qplayer(player: self, duration: duration)
    }
    
    public func qplayer(player: QuicklyAVPlayer?, currentTime: CMTime?) {
        self.options.qplayer(player: self, currentTime: currentTime)
        if let cu = currentTime, let du = self.options.duration, cu.seconds >= du.seconds, cu.seconds > 0 {
            self.qplayer(player: self, isPlayedEnd: true)
        } else {
            self.qplayer(player: self, isPlayedEnd: false)
        }
    }
    
    public func qplayer(player: QuicklyAVPlayer?, error: Error?) {
        self.options.qplayer(player: self, error: error)
        if error != nil {
            self.qplayer(player: self, isBuffering: false)
            self.qplayer(player: self, isPlaying: false)
        }
    }
    
    public func qplayer(player: QuicklyAVPlayer?, isPlayedEnd: Bool) {
        if isPlayedEnd {
            self.timeout?.invalidate()
            if self.options.repeatCount > 0, self.repeatCount < self.options.repeatCount {
                // 继续循环播放
                self.qreplay()
                self.repeatCount = self.repeatCount + 1
            } else {
                // 结束播放
                self.options.qplayer(player: self, isPlayedEnd: isPlayedEnd)
                if self.options.showFirstFrameWhenPlayEnd { // 是否需要停留在第一帧
                    self.qseek(to: .init(value: 0, timescale: 1000), complete: nil)
                }
            }
        } else {
            if self.options.isPlayedEnd != isPlayedEnd {
                self.options.qplayer(player: self, isPlayedEnd: isPlayedEnd)
            }
        }
    }
    
    public func qplayer(player: QuicklyAVPlayer?, loadedTimeRange: CMTimeRange?) {
        self.options.qplayer(player: self, loadedTimeRange: loadedTimeRange)
        if self.options.isTimeOut {
            self.qplayer(player: self, isTimeout: false)
        }
        self.timeout?.invalidate()
        if let load = loadedTimeRange, let duration = self.options.duration {
            if (load.start.seconds + load.end.seconds < duration.seconds), self.options.timeoutInterval > 0 {
                self.timeout = Timer.qtimer(interval: self.options.timeoutInterval, target: self, repeats: false, mode: .common) { [weak self] time in
                    if self?.options.isTimeOut == false {
                        self?.qplayer(player: self, isTimeout: true)
                    }
                    time.invalidate()
                }
            }
        }
    }
    
    public func qplayer(player: QuicklyAVPlayer?, isBuffering: Bool) {
        self.options.qplayer(player: self, isBuffering: isBuffering)
    }
    
    public func qplayer(player: QuicklyAVPlayer?, isTimeout: Bool) {
        self.options.qplayer(player: self, isTimeout: isTimeout)
    }
    
    public func qplayer(player: QuicklyAVPlayer?, isPlaying: Bool) {
        self.options.qplayer(player: self, isPlaying: isPlaying)
    }
    //
    public func qplayer(player: QuicklyAVPlayer?, isSeeking: Bool) {
        self.options.qplayer(player: self, isSeeking: isSeeking)
    }
}
