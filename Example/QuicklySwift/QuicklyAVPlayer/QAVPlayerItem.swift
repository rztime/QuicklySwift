//
//  QAVPlayerItem.swift
//  QuicklySwift
//
//  Created by rztime on 2022/10/27.
//

import UIKit
import AVFoundation

open class QAVPlayerItem : AVPlayerItem {
    var qloadStatus: ((AVPlayerItem.Status) -> Void)?
    var qerror: ((Error?) -> Void)?
    var qloadedTimeRanges: ((CMTimeRange?) -> Void)?
    var qisBuffing:((_ isBuffering: Bool) -> Void)?
    var qduration: ((CMTime?) -> Void)?

    private var isAdded = false
    open func addObservers() {
        if isAdded {
            return
        }
        isAdded = true
        self.addObserver(self, forKeyPath: "status", options: [.new, .old], context: nil)
        self.addObserver(self, forKeyPath: "error", options: [.new, .old], context: nil)
        self.addObserver(self, forKeyPath: "loadedTimeRanges", options: [.new, .old], context: nil)
        self.addObserver(self, forKeyPath: "playbackBufferEmpty", options: [.new, .old], context: nil)
        self.addObserver(self, forKeyPath: "playbackLikelyToKeepUp", options: [.new, .old], context: nil)
        self.addObserver(self, forKeyPath: "duration", options: [.new, .old], context: nil)
    }
    open func removeAllObserver() {
        if !isAdded {
            return
        }
        isAdded = false
        self.removeObserver(self, forKeyPath: "status")
        self.removeObserver(self, forKeyPath: "error")
        self.removeObserver(self, forKeyPath: "loadedTimeRanges")
        self.removeObserver(self, forKeyPath: "playbackBufferEmpty")
        self.removeObserver(self, forKeyPath: "playbackLikelyToKeepUp")
        self.removeObserver(self, forKeyPath: "duration")
    }
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let kp = keyPath else { return }
        switch kp {
        case "status":
            self.qloadStatus?(self.status)
            switch self.status {
            case .failed:
                self.qerror?(NSError.init(domain: "视频加载失败，请重试", code: 0))
            default:
                self.qerror?(nil)
            }
        case "error":
            self.qerror?(self.error)
        case "loadedTimeRanges":
            let ranges = self.loadedTimeRanges.first?.timeRangeValue
            self.qloadedTimeRanges?(ranges)
        case "playbackBufferEmpty":
            self.qisBuffing?(true)
        case "playbackLikelyToKeepUp":
            self.qisBuffing?(false)
        case "duration":
            self.qduration?(self.duration)
        default:
            break
        }
    }
    deinit {
        self.removeAllObserver()
    }
}
