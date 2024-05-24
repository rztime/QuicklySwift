//
//  QuicklyAVPlayer.swift
//  QuicklySwift
//
//  Created by rztime on 2024/4/15.
//

import UIKit
import AVFoundation
/******
 AVPlayer的封装
 可以播放视频、音频，需要显示视频内容时，将playerView加在view上即可
 **/
open class QPlayer {
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private var place: UIImageView?
    /// 占位图，当视频可以播时，会立即隐藏
    open lazy var placeholderImageView: UIImageView = .init().qthen {
        $0.qcornerRadius(0, true).qcontentMode(.scaleAspectFit)
        self.playerView.qbody([
            $0.qmakeConstraints({ make in
                make.edges.equalToSuperview()
            })
        ])
        self.place = $0
    }
    /// 如果不调用，则不会显示视频
    open lazy var playerView: UIView = .init().qthen {
        $0.backgroundColor = .black
        let layer = AVPlayerLayer(player: self.player)
        layer.videoGravity = .resizeAspect
        $0.layer.addSublayer(layer)
        $0.qsizeChanged { [weak layer] view in
            layer?.frame = view.bounds
        }
        .qcornerRadius(0, true)
        self.playerLayer = layer
    }
    /// 如果不显示视频，此方法设置无效
    open var videoGravity: AVLayerVideoGravity = .resizeAspect {
        didSet {
            self.playerLayer?.videoGravity = videoGravity
            switch videoGravity {
            case .resize:
                self.place?.contentMode = .scaleToFill
            case .resizeAspect:
                self.place?.contentMode = .scaleAspectFit
            case .resizeAspectFill:
                self.place?.contentMode = .scaleAspectFill
            default:
                self.place?.contentMode = .scaleAspectFit
            }
        }
    }
    /// 播放中还是暂停中，可用于播放暂停按钮的状态显示
    public let playing: QPublish<Bool> = .init(value: false)
    /// 资源的状态
    public let status: QPublish<AVPlayerItem.Status> = .init(value: .unknown)
    /// 播放的当前时间
    public let currentTime: QPublish<CMTime?> = .init(value: .zero)
    /// 资源总时长
    public let duration: QPublish<CMTime?> = .init(value: .zero)
    /// 资源尺寸
    public let mediaSize: QPublish<CGSize?> = .init(value: nil)
    /// 是否加载中（缓冲中）
    public let isLoading: QPublish<Bool> = .init(value: false)
    /// 是否seek中
    public let isSeeking: QPublish<Bool> = .init(value: false)
    /// 是否有错误提示
    public let error: QPublish<Error?> = .init(value: nil)
    /// 完成一次播放 则调用一次l
    public let playEnd: QPublish<Bool> = .init(value: false)
    /// 加载进度
    public let loadRange: QPublish<CMTimeRange> = .init(value: .zero)
    /// 循环播放
    open var loopPlayback: Bool = false
    /// 设置播放资源后，直接播放
    open var autoPlay: Bool = false
    /// 播放完成之后，保留在第一帧（如果是倒放，则停在最后一帧）
    open var stayFirstWhenPlayEnd: Bool = false
    /// 倍数播放，为0时，将停止播放，   < 0: 倒放
    open var rate: Float = 1 {
        didSet {
            self.player?.rate = rate
            if rate == 0 {
                self.timer?.qpause()
            } else {
                self.timer?.qresume()
            }
        }
    }
    /// 静音
    open var isMuted: Bool = false {
        didSet {
            self.player?.isMuted = isMuted
        }
    }
    /// 音量
    open var volume: Float {
        get {
            return qaudioOutputVolume
        }
        set {
            qaudioOutputVolumeSet(newValue)
            self.player?.volume = newValue
        }
    }
    private var timer: Timer?
    private var destoryObj: NSObject = .init()
    private var timerTasking = false
    
    public init() { }
    /// 重置
    open func observerbindReset() {
        /// 重置相关属性
        destoryObj = .init()
        self.player?.isMuted = self.isMuted
        self.player?.volume = self.volume
        self.playing.accept(false)
        self.status.accept(.unknown)
        self.currentTime.accept(nil)
        self.duration.accept(nil)
        self.mediaSize.accept(nil)
        self.isLoading.accept(false)
        self.isSeeking.accept(false)
        self.error.accept(nil)
        self.playEnd.accept(false)
        self.loadRange.accept(.zero)
        /// 添加监听
        guard let item = self.player?.currentItem else { return }
        self.timer = .qtimer(interval: 0.33, target: destoryObj, repeats: true, mode: .common, block: { [weak self] _ in
            guard let self = self, let player = self.player else { return }
            if self.timerTasking {
                return
            }
            self.timerTasking = true
            /// 播放状态
            let playing = player.rate != 0
            if self.playing.value != playing {
                self.playing.accept(playing)
            }
            /// 当前时间
            let currentTime = self.getCurrentTime()
            if self.currentTime.value != currentTime {
                self.currentTime.accept(currentTime)
            }
            /// 缓冲中
            if let buffing = player.currentItem?.isPlaybackBufferEmpty, buffing {
                self.isLoading.accept(buffing)
            } else if (player.currentItem?.isPlaybackLikelyToKeepUp ?? false) || (player.currentItem?.isPlaybackBufferFull ?? false) {
                self.isLoading.accept(false)
            }
            /// 缓冲进度
            if let range = player.currentItem?.loadedTimeRanges.first as? CMTimeRange, range != self.loadRange.value {
                self.loadRange.accept(range)
            }
            /// 播放结束
            let pend = self.playDidEnd()
            if self.playEnd.value != pend {
                self.playEnd.accept(pend)
            }
            /// 是否循环播放
            if pend && self.loopPlayback {
                self.play()
            } else if pend && self.stayFirstWhenPlayEnd {
                self.seek(time: .zero, complete: nil)
            }
            self.timerTasking = false
        })
        item.qaddObserver(key: "status", options: [.new, .old, .initial], context: nil, handle: { [weak self] sender, key, value in
            guard let self = self else { return }
            if sender.status == .readyToPlay {
                self.place?.isHidden = true
                if self.autoPlay {
                    self.play()
                }
            }
            self.status.accept(sender.status)
            /// 视频尺寸
            let size = self.getMediaSize()
            if size != self.mediaSize.value {
                self.mediaSize.accept(size)
            }
            /// 总时长
            let total = sender.duration
            if self.duration.value != total {
                self.duration.accept(total)
            }
            /// 错误
            let error = sender.error
            if self.error.value?.localizedDescription != error?.localizedDescription {
                self.error.accept(error)
            }
        })
    }
    @discardableResult
    /// 设置播放资源
    open func setMedia(url: URL?) -> AVPlayerItem? {
        if let url = url {
            return self.setMedia(item: .init(url: url))
        } else {
            return self.setMedia(item: nil)
        }
    }
    @discardableResult
    /// 设置播放资源
    open func setMedia(item: AVPlayerItem?) -> AVPlayerItem? {
        self.place?.isHidden = false
        if let p = self.player {
            p.replaceCurrentItem(with: item)
        } else {
            self.player = .init(playerItem: item)
        }
        self.observerbindReset()
        return item
    }
    /// 开始播放（重播）
    open func play(replay: Bool = false) {
        if replay {
            self.player?.currentItem?.cancelPendingSeeks()
            self.seek(time: .zero, complete: nil)
        } else if self.playDidEnd() {
            self.seek(time: .zero, complete: nil)
        }
        /// 中断状态不播放
        if self.interruptSet.count > 0 {
            return
        }
        self.player?.rate = self.rate
    }
    /// 暂停
    open func pause() {
        self.player?.rate = 0
    }
    /// 中断方式
    public enum InterrupType {
        /// 进入前后台
        case active
        /// 页面跳转
        case appear
        /// 其他自定义
        case custom1, custom2, custom3, custom4, custom5, custom6
    }
    /// 记录中断时，播放的rate
    private var _rate: Float?
    private var interruptSet: Set<InterrupType> = .init()
    /// 添加中断状态，（同一个状态仅一次）
    open func interrupt(type: InterrupType) {
        self.interruptSet.insert(type)
        if _rate == nil {
            _rate = self.player?.rate
        }
        self.player?.rate = 0
    }
    /// 移除中断状态，（同一个状态仅一次）
    open func interrupt(remove type: InterrupType) {
        self.interruptSet.remove(type)
        if self.interruptSet.count == 0 {
            if let r = _rate {
                self.player?.rate = r
                _rate = nil
            }
        }
    }
    /// 设置进度0-1.0
    open func seek(progress: Float, complete: ((Bool) -> Void)?) {
        guard let d = self.getTotalTime() else {
            complete?(false)
            return
        }
        let c = d.seconds * Double(progress)
        let time = CMTime(seconds: c, preferredTimescale: d.timescale)
        self.seek(time: time, complete: complete)
    }
    /// seek  complete: 是否成功
    open func seek(time: CMTime?, complete: ((Bool) -> Void)?) {
        guard self.player?.currentItem?.status == .readyToPlay, var time = time, let d = self.getTotalTime() else {
            complete?(false)
            return
        }
        if self.rate < 0 {
            time = d - time
        }
        let tempComplete = complete
        self.isSeeking.accept(true)
        self.player?.currentItem?.seek(to: time, toleranceBefore: .zero, toleranceAfter: .zero, completionHandler: { [weak self] res in
            self?.isSeeking.accept(false)
            tempComplete?(res)
        })
    }
    /// 获取当前播放时长
    open func getCurrentTime() -> CMTime? {
        guard var time = self.player?.currentItem?.currentTime() else { return nil }
        if self.rate < 0 {
            if let total = self.getTotalTime() {
                time = total - time
            }
        }
        return time
    }
    /// 获取总时长, 只有status收到readToPlay之后，才能拿到
    open func getTotalTime() -> CMTime? {
        return self.player?.currentItem?.duration
    }
    /// 是否播放完成, （< 0.02 结束时有可能最后一帧未播）
    open func playDidEnd() -> Bool {
        if let c = self.getCurrentTime(), let d = self.getTotalTime(), d.seconds - c.seconds < 0.02 {
            return true
        }
        return false
    }
    /// 获取资源尺寸（视频分辨率）
    open func getMediaSize() -> CGSize? {
        return self.player?.currentItem?.presentationSize
    }
    /// 缓冲的进度，（可以取第一个qlength计算加载的总长度）
    open func getLoadTimeRanges() -> [CMTimeRange] {
        return (self.player?.currentItem?.loadedTimeRanges as? [CMTimeRange]) ?? []
    }
    /// 获取error信息
    open func getError() -> Error? {
        return self.player?.currentItem?.error
    }
}
public extension CMTimeRange {
    /// 缓冲总长度
    var qlength: Double {
        let star = self.start.seconds
        let dura = self.duration.seconds
        return star + dura
    }
}
