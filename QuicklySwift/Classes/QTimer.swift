//
//  QuicklyTimer.swift
//  QuicklySwift
//
//  Created by rztime on 2022/10/19.
//

import UIKit

public extension Timer {
    @discardableResult
    /// 创建一个timer，target释放时，会自动释放timer
    /// - target:  释放target时，主动释放定时器，这里如果target持有timer，也不会有强引用而无法释放target的问题
    /// 如何timer不被target持有时，repeats = false时，当完成一次任务后，就会被释放
    class func qtimer(interval: TimeInterval, target: NSObject, repeats: Bool, mode: RunLoop.Mode, block: ((Timer) -> Void)?) -> Timer {
        let timer = Timer.init(timeInterval: interval, repeats: repeats) { timer in
            block?(timer)
        }
        RunLoop.current.add(timer, forMode: mode)
        target.qdeinit { [weak timer] in
            timer?.invalidate()
        }
        return timer
    }
    // 暂停
    func qpause() {
        self.fireDate = .distantFuture
    }
    // 开始
    func qresume() {
        self.fireDate = .distantPast
    }
}
public extension CADisplayLink {
    @discardableResult
    /// 创建一个定时器，target释放时，会自动释放当前定时器
    ///   - target:  释放target时，主动释放定时器,  这里如果target持有timer，也不会有强引用而无法释放target的问题
    ///   - timesForSecond: 1秒执行次数
    class func qinit(target: NSObject, runloop: RunLoop, mode: RunLoop.Mode, timesForSecond: Int, block: ((CADisplayLink) -> Void)?) -> CADisplayLink {
        let helper = CADisplayLinkHelper.init()
        let displaylink = CADisplayLink.init(target: helper, selector: #selector(CADisplayLinkHelper.displaylinkAction))
        displaylink.add(to: runloop, forMode: mode)
        displaylink.preferredFramesPerSecond = timesForSecond
        target.qdeinit { [weak displaylink] in
            displaylink?.invalidate()
        }
        helper.block = { [weak displaylink] in
            if let dis = displaylink {
                block?(dis)
            }
        }
        return displaylink
    }
}

private class CADisplayLinkHelper: NSObject {
    var block: (() -> Void)?
    override init() {
        super.init()
    }
    var i: Int = 0
    @objc func displaylinkAction() {
        block?()
    }
}
