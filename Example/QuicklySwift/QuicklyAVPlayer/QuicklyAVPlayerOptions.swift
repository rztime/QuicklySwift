//
//  QuicklyAVPlayerOptions.swift
//  QuicklySwift
//
//  Created by rztime on 2022/10/27.
//

import UIKit
import AVFoundation
//
//open class QuicklyAVPlayerOptions {
////    private lazy var helper: QuicklyAVPlayerHelper = .init(player: self)
//    /// 自动播放，当readToPlay之后
//    public var playWhenReaded: Bool = true
//    /// 循环播放
//    public var repeatPlay: Bool = false
//    /// 当播放结束之后是否停留在第一帧
//    public var showFirstFrameWhenPlayEnd: Bool = false
//
//    /// 播放的item的状态
//    public var playerItemStatus: AVPlayerItem.Status = .unknown {didSet {
//        self.helper.qplayer(player: self, playerItemStatus: playerItemStatus)
//        self.playerItemStatusBlock?(playerItemStatus)
//    }}
//    /// 播放的item的状态改变的回调
//    public var playerItemStatusBlock: ((AVPlayerItem.Status) -> Void)? {didSet { self.playerItemStatusBlock?(playerItemStatus) }}
//    /// 总时长
//    public var totalTime: CMTime? {didSet {
//        self.helper.qplayer(player: self, totalTime: totalTime)
//        self.totalTimeBlock?(totalTime)
//    }}
//    /// 总时长改变的回调
//    public var totalTimeBlock: ((CMTime?) -> Void)? {didSet { self.totalTimeBlock?(totalTime) }}
//    /// 当前时间
//    public var currentTime: CMTime? {didSet {
//        self.helper.qplayer(player: self, currentTime: currentTime)
//        self.currentTimeBlock?(currentTime)
//    }}
//    /// 当前时间改变的回调
//    public var currentTimeBlock: ((CMTime?) -> Void)? {didSet { self.currentTimeBlock?(currentTime) }}
//    ///错误，为nil表示无错误
//    public var error: Error? {didSet {
//        self.helper.qplayer(player: self, error: error)
//        self.errorBlock?(error)
//    }}
//    /// 有错误时的回调，为nil表示无错误
//    public var errorBlock: ((Error?) -> Void)? {didSet { self.errorBlock?(error) }}
//    /// 是否播放完毕
//    public var isPlayEnd: Bool = false {didSet {
//        self.helper.qplayer(player: self, isPlayEnd: isPlayEnd)
//        self.playEndBlock?(isPlayEnd)
//    }}
//    /// 播放完毕的回调
//    public var playEndBlock: ((_ isPlayEnd: Bool) -> Void)? {didSet { self.playEndBlock?(isPlayEnd) }}
//    /// 已缓冲的时间
//    public var loadedTimeRange: CMTimeRange? {didSet {
//        self.helper.qplayer(player: self, loadedTimeRange: loadedTimeRange)
//        self.loadedTimeRangeBlock?(loadedTimeRange)
//    }}
//    /// 已缓冲的时间改变的回调
//    public var loadedTimeRangeBlock: ((CMTimeRange?) -> Void)? {didSet { self.loadedTimeRangeBlock?(loadedTimeRange) }}
//    /// 是否是缓冲状态
//    public var isBuffering: Bool = true {didSet {
//        self.helper.qplayer(player: self, isBuffering: isBuffering)
//        self.isBufferingBlock?(isBuffering)
//    }}
//    /// 是否是缓冲中
//    public var isBufferingBlock: ((Bool) -> Void)? {didSet { self.isBufferingBlock?(isBuffering) }}
//    /// 网络超时时长设置
//    public var timeoutInterval: TimeInterval = 5
//    /// 是否连接超时
//    public var isTimeout: Bool = false {didSet {
//        self.helper.qplayer(player: self, isTimeout: isTimeout)
//        self.isTimeoutBlock?(isTimeout)
//    }}
//    /// 网络超时之后，提示
//    /// 备注：无网络，弱网，一直加载卡在某一帧，这个和错误有本质区别
//    public var isTimeoutBlock: ((_ isTimeout: Bool) -> Void)? {didSet { self.isTimeoutBlock?(isTimeout) }}
//    /// 播放状态
//    public var isPlaying: Bool = false {didSet {
//        self.helper.qplayer(player: self, isPlaying: isPlaying)
//        self.isPlayingBlock?(isPlaying)
//    }}
//    /// 播放状态改变回调
//    public var isPlayingBlock: ((Bool) -> Void)? {didSet { self.isPlayingBlock?(isPlaying) }}
//
//    /// 添加delegate，没有特殊要求时，内部会自动释放，即可不用调removedelegate
//    func addDelegate(_ delegate: (QuicklyAVPlayerDelegate & NSObject)?) {
//        self.helper.addDelegate(delegate)
//    }
//    /// 移除delegate
//    func removeDelegate(_ delegate: (QuicklyAVPlayerDelegate & NSObject)?) {
//        self.helper.removeDelegate(delegate)
//    }
//
//    public init() {
//
//    }
//}

public protocol QuicklyAVPlayerDelegate {
    /// 视频初始化之后的状态
    func qplayer(player: QuicklyAVPlayer?, playerItemLoadStatus: AVPlayerItem.Status)
    /// 总时间
    func qplayer(player: QuicklyAVPlayer?, duration: CMTime?)
    /// 当前播放时间
    func qplayer(player: QuicklyAVPlayer?, currentTime: CMTime?)
    /// 是否有错误
    func qplayer(player: QuicklyAVPlayer?, error: Error?)
    /// 是否播放结束
    func qplayer(player: QuicklyAVPlayer?, isPlayedEnd: Bool)
    /// 已缓冲的时间
    func qplayer(player: QuicklyAVPlayer?, loadedTimeRange: CMTimeRange?)
    /// 是否是缓冲状态改变
    func qplayer(player: QuicklyAVPlayer?, isBuffering: Bool)
    /// 网络超时之后，提示
    /// 备注：无网络，弱网，一直加载卡在某一帧，这个和错误有本质区别
    func qplayer(player: QuicklyAVPlayer?, isTimeout: Bool)
    /// 播放状态改变回调
    func qplayer(player: QuicklyAVPlayer?, isPlaying: Bool)
    /// seeking改变回调,  这个由控制层自行设置（比如滑动进度条时处理）
    func qplayer(player: QuicklyAVPlayer?, isSeeking: Bool)
}

public class QuicklyAVPlayerOptions {
    public enum Option {
        /// 初始化加载之后先不播放
        case pauseAtFirst
        /// 循环播放次数，<=0表示不循环
        case repeatPlay(count: Int)
        /// 播放完毕之后显示第一帧
        case showFirstFrameWhenPlayEnd
    }
    public class DelegateHelper: NSObject {
        weak var delegate: (QuicklyAVPlayerDelegate & NSObject)?
        init(delegate: (QuicklyAVPlayerDelegate & NSObject)? = nil) {
            self.delegate = delegate
        }
    }
    /// 当前播放状态（根据用户的意愿设置）
    public private(set) var play = true
    /// 初始化加载之后直接播放
    public private(set) var playAtFirst = true
    /// 循环播放次数，0表示不循环
    public private(set) var repeatCount = 0
    public private(set) var showFirstFrameWhenPlayEnd = false
    /// 初始化加载状态
    public private(set) var loadStatus: AVPlayerItem.Status = .unknown
    /// 视频时长
    public private(set) var duration: CMTime?
    /// 当前播放时间
    public private(set) var currentTime: CMTime?
    /// 当前是否有错误
    public private(set) var error: Error?
    /// 是否播放结束到尾部
    public private(set) var isPlayedEnd: Bool = false
    /// 视频已缓冲的内容的时间
    public private(set) var loadedTimeRange: CMTimeRange?
    /// 是否缓冲中
    public private(set) var isBuffering: Bool = true
    /// 是否超时
    public private(set) var isTimeOut: Bool = false
    /// 是否播放 （播放、暂停）
    public private(set) var isPlaying: Bool = false
    /// 是否是seek状态中
    public private(set) var isSeeking: Bool = false
    
    public var delegates: [DelegateHelper] = []
    
    /// 超时判断时间
    public var timeoutInterval: TimeInterval = 5
    
    private var loadStatusBlock: ((_ status: AVPlayerItem.Status) -> Void)?
    private var durationBlock: ((CMTime?) -> Void)?
    private var currentTimeBlock: ((CMTime?) -> Void)?
    private var errorBlock: ((Error?) -> Void)?
    private var isPlayedEndBlock: ((Bool) -> Void)?
    private var loadedTimeRangeBlock: ((CMTimeRange?) -> Void)?
    private var isBufferingBlock: ((Bool) -> Void)?
    private var isTimeOutBlock: ((Bool) -> Void)?
    private var isPlayingBlock: ((Bool) -> Void)?
    private var isSeekingBlock: ((Bool) -> Void)?
    
    public init(options: [QuicklyAVPlayerOptions.Option]) {
        options.forEach { option in
            switch option {
            case .pauseAtFirst:
                self.playAtFirst = false
                self.play = false
            case .repeatPlay(let count):
                self.repeatCount = count
            case .showFirstFrameWhenPlayEnd:
                self.showFirstFrameWhenPlayEnd = true
            }
        }
    }
    /// 添加delegate回调
    public func addDelegate(_ delegate: (QuicklyAVPlayerDelegate & NSObject)?) {
        if let _ = delegates.first(where: {($0.delegate?.isEqual(delegate)) ?? false}) {
            return
        }
        let helper = DelegateHelper.init(delegate: delegate)
        delegate?.qdeinit({ [weak self, weak helper] in
            self?.delegates.removeAll(where: {$0.isEqual(helper)})
        })
        self.delegates.append(helper)
    }
    /// 删除delegate回调
    public func removeDelegate(_ delegate: (QuicklyAVPlayerDelegate & NSObject)?) {
        delegates.removeAll(where: {($0.delegate?.isEqual(delegate) ?? false)})
    }
    /// 根据用户的意愿设置暂停或者播放状态
    public func setPlayingStatus(play: Bool) {
        self.play = play
    }
}
public extension QuicklyAVPlayerOptions {
    /// 初始化加载状态改变的回调
    func loadStatusChanged(changed: ((_ status: AVPlayerItem.Status) -> Void)?) {
        self.loadStatusBlock = changed
    }
    /// 视频时长改变回调
    func durationChanged(changed: ((_ duration: CMTime?) -> Void)?) {
        self.durationBlock = changed
    }
    /// 当前播放时间改变回调
    func currentTimeChanged(changed: ((_ currentTime: CMTime?) -> Void)?) {
        self.currentTimeBlock = changed
    }
    /// 当前是否有错误改变回调
    func errorChanged(changed: ((_ error: Error?) -> Void)?) {
        self.errorBlock = changed
    }
    /// 是否播放结束到尾部改变回调
    func isPlayedEndChanged(changed: ((_ isPlayedEnd: Bool) -> Void)?) {
        self.isPlayedEndBlock = changed
    }
    /// 视频已缓冲的内容的时间改变的回调
    func loadedTimeRangeChanged(changed: ((_ timeRange: CMTimeRange?) -> Void)?) {
        self.loadedTimeRangeBlock = changed
    }
    /// 是否缓冲中改变的回调
    func isBufferingChanged(changed: ((_ isBuffering: Bool) -> Void)?) {
        self.isBufferingBlock = changed
    }
    /// 是否超时的回调
    func isTimeOutChanged(changed: ((_ isTimeOut: Bool) -> Void)?) {
        self.isTimeOutBlock = changed
    }
    /// 是否播放 （播放、暂停）状态改变的回调
    func isPlayingChanged(changed: ((_ isPlaying: Bool) -> Void)?) {
        self.isPlayingBlock = changed
    }
    /// 是否seeking状态改变的回调
    func isSeekingChanged(changed: ((_ isSeeking: Bool) -> Void)?) {
        self.isSeekingBlock = changed
    }
}
extension QuicklyAVPlayerOptions: QuicklyAVPlayerDelegate {
    public func qplayer(player: QuicklyAVPlayer?, playerItemLoadStatus: AVPlayerItem.Status) {
        self.loadStatus = playerItemLoadStatus
        self.loadStatusBlock?(playerItemLoadStatus)
        self.delegates.forEach({$0.delegate?.qplayer(player: player, playerItemLoadStatus: playerItemLoadStatus)})
    }
    
    public func qplayer(player: QuicklyAVPlayer?, duration: CMTime?) {
        self.duration = duration
        self.durationBlock?(duration)
        self.delegates.forEach({$0.delegate?.qplayer(player: player, duration: duration)})
    }
    
    public func qplayer(player: QuicklyAVPlayer?, currentTime: CMTime?) {
        self.currentTime = currentTime
        self.currentTimeBlock?(currentTime)
        self.delegates.forEach({$0.delegate?.qplayer(player: player, currentTime: currentTime)})
    }
    
    public func qplayer(player: QuicklyAVPlayer?, error: Error?) {
        self.error = error
        self.errorBlock?(error)
        self.delegates.forEach({$0.delegate?.qplayer(player: player, error: error)})
    }
    
    public func qplayer(player: QuicklyAVPlayer?, isPlayedEnd: Bool) {
        self.isPlayedEnd = isPlayedEnd
        self.isPlayedEndBlock?(isPlayedEnd)
        self.delegates.forEach({$0.delegate?.qplayer(player: player, isPlayedEnd: isPlayedEnd)})
    }
    
    public func qplayer(player: QuicklyAVPlayer?, loadedTimeRange: CMTimeRange?) {
        self.loadedTimeRange = loadedTimeRange
        self.loadedTimeRangeBlock?(loadedTimeRange)
        self.delegates.forEach({$0.delegate?.qplayer(player: player, loadedTimeRange: loadedTimeRange)})
    }
    
    public func qplayer(player: QuicklyAVPlayer?, isBuffering: Bool) {
        self.isBuffering = isBuffering
        self.isBufferingBlock?(isBuffering)
        self.delegates.forEach({$0.delegate?.qplayer(player: player, isBuffering: isBuffering)})
    }
    
    public func qplayer(player: QuicklyAVPlayer?, isTimeout: Bool) {
        self.isTimeOut = isTimeout
        self.isTimeOutBlock?(isTimeout)
        self.delegates.forEach({$0.delegate?.qplayer(player: player, isTimeout: isTimeout)})
    }
    
    public func qplayer(player: QuicklyAVPlayer?, isPlaying: Bool) {
        self.isPlaying = isPlaying
        self.isPlayingBlock?(isPlaying)
        self.delegates.forEach({$0.delegate?.qplayer(player: player, isPlaying: isPlaying)})
    }
    
    public func qplayer(player: QuicklyAVPlayer?, isSeeking: Bool) {
        self.isSeeking = isSeeking
        self.isSeekingBlock?(isSeeking)
        self.delegates.forEach({$0.delegate?.qplayer(player: player, isSeeking: isSeeking)})
    }
}
