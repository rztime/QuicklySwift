//
//  QDispatch.swift
//  QuicklySwift
//
//  Created by rztime on 2023/10/30.
//

import UIKit

public typealias QExecuteBlock = (() -> Void)
public typealias QDispatchTaskBlock = ((_ item: QDispatchTaskItem, _ complete: QDispatchTaskItemComplete?) -> Void)
public typealias QDispatchTaskItemComplete = ((QDispatchTaskItemOption) -> Void)

public enum QDispatchTaskItemOption {
    case next   // 执行下一步
    case stop   // 执行结束 仅对synctask有效, 未执行的，将停止
}
///
public class QDispatchTaskItem {
    /// 任务执行完成时，可以配置的信息
    public var info: [String: Any] = [:]
    /// 任务是否执行完成
    public var complete: Bool = false
    /// 任务序列序号
    public var index: Int = 0
    
    var task: QDispatchTaskBlock?
    var completeBlock: QDispatchTaskItemComplete?
    
    public init() { }
}
/// 异步
public class QDispatch {
    var helper: QDispatchHelper?
}
public extension QDispatch {
    /// 可再触发延迟（延迟执行方法，如果在延迟过程中重复调用此方法，则加长延迟时间，仅调用最后一次延迟处理）
    /// - Parameters:
    ///   - id: 通过ID来判断是否为同一个
    ///   - duration: 延迟时间。
    ///   如 duration = 1， 则在延迟1秒的过程中，又继续触发，那么以最后一次触发为准，延迟1秒后执行，此前的方法会被释放掉。
    class func qRetriggerDelay(id: String, queue: DispatchQueue, duration: TimeInterval, execute: QExecuteBlock?) {
        let d = QDispatchHelper.init()
        d.setId(id, execute: execute)
        d.setmethod(queue: queue, duration: duration)
        QDispatchHelper.insertDispatch(d)
    }
    /// 不可重复触发延迟（在延迟过程中重复调用此方法时无效，仅第一次调用有效）
    class func qNoRetriggerDelay(id: String, queue: DispatchQueue, duration: TimeInterval, execute: QExecuteBlock?) {
        if let _ = QDispatchHelper.share.queueList.first(where: {$0.id == id}) {
            return
        }
        let d = QDispatchHelper.init()
        d.setId(id, execute: nil)
        d.setmethod(queue: queue, duration: duration)
        QDispatchHelper.insertDispatch(d)
        execute?()
    }
    /******
     /// 同步、异步执行多任务，全部执行完之后，执行complete
     QDispatch.qsyncTask { task in
        /// 循环创建十个任务
        for _ in 0 ..< 10 {
            // 每个循环里task.qtaskItem创建一个任务，完成之后执行complete?(.next)
             task.qtaskItem { item, complete in
                 let x: TimeInterval = TimeInterval(arc4random() % 3)
                 DispatchQueue.init(label: "xxxx_\(item.index)").asyncAfter(deadline: .now() + x, execute: {
                     print(item.index)
                     // 任务完成后，执行下一步
                     complete?(.next)
                 })
             }
         }
     } complete: { items in
         print("---finish")
     }
     ***/
    
    /// 执行同步任务，所有任务完成之后，会回调complete
    /// 每启一个任务，调用一次 task.qtaskItem {}
    class func qsyncTask(_ task: ((_ task: QDispatch) -> Void)?, complete: ((_ items: [QDispatchTaskItem]) ->  Void)?) {
        let d = QDispatch.init()
        let x = QDispatchHelper.creatBy(id: "sync")
        d.helper = x
        task?(d)
        x.complete = complete
        x.loadTask()
    }
    /// 执行异步任务，所有任务完成之后，会回调complete
    /// 每启一个任务，调用一次 task.qtaskItem {}
    class func qasyncTask(_ task: ((_ task: QDispatch) -> Void)?, complete: ((_ items: [QDispatchTaskItem]) ->  Void)?) {
        let d = QDispatch.init()
        let x = QDispatchHelper.creatBy(id: "async")
        d.helper = x
        task?(d)
        x.complete = complete
        x.loadTask()
    }
    /// 在 同步、异步执行任务时，在此回调里启动单个任务，任务完成后，需调用complete?(.next)
    func qtaskItem(_ task: QDispatchTaskBlock?) {
        self.helper?.taskItem(task)
    }
}
var syncindex = 0
class QDispatchHelper: NSObject {
    var id: String = ""
    var execute: QExecuteBlock?
    
    var queueList: [QDispatchHelper] = []
    
    var taskList: [QDispatchTaskItem] = []
    
    static let share: QDispatchHelper = .init()
    
    var finish: QExecuteBlock?
    
    var complete: ((_ items: [QDispatchTaskItem]) -> Void)?
    var index: Int = 0
    func setId(_ id: String, execute: QExecuteBlock?) {
        self.id = id
        self.execute = execute
    }
    func setmethod(queue: DispatchQueue, duration: TimeInterval) {
        queue.asyncAfter(deadline: .now() + duration, execute: { [weak self] in
            self?.execute?()
            QDispatchHelper.removeDispatch(self)
        })
    }
    class func removeDispatch(_ dispatch: QDispatchHelper?) {
        if let dispatch = dispatch {
            let share = QDispatchHelper.share
            share.queueList = share.queueList.filter({$0.id != dispatch.id})
        }
    }
    class func insertDispatch(_ dispatch: QDispatchHelper) {
        let share = QDispatchHelper.share
        var newqueue = share.queueList.filter({$0.id != dispatch.id})
        newqueue.append(dispatch)
        share.queueList = newqueue
    }
    class func creatBy(id: String) -> QDispatchHelper {
        let dispatch = QDispatchHelper.init()
        syncindex += 1
        dispatch.id = "\(id)_\(syncindex)"
        QDispatchHelper.insertDispatch(dispatch)
        return dispatch
    }
    func taskItem(_ task: QDispatchTaskBlock?) {
        if let task = task {
            let t = QDispatchTaskItem.init()
            t.index = self.index
            t.task = task
            self.taskList.append(t)
            self.index += 1
        }
    }
    func loadTask() {
        if self.id.hasPrefix("sync") {
            if let t = self.taskList.first(where: {$0.complete == false}) {
                t.completeBlock = { [weak self] option in
                    t.complete = true
                    switch option {
                    case .next:
                        self?.loadTask()
                    case .stop:
                        self?.taskComplete()
                    }
                }
                t.task?(t, t.completeBlock)
            } else  {
                self.taskComplete()
            }
        } else if self.id.hasPrefix("async") {
            self.taskList.forEach { [weak self] item in
                item.completeBlock = { [weak self] option in
                    item.complete = true
                    if let _ = self?.taskList.first(where: {$0.complete == false }) {
                        
                    } else {
                        self?.taskComplete()
                    }
                }
                item.task?(item, item.completeBlock)
            }
        }
    }
    func taskComplete() {
        self.complete?(self.taskList)
        QDispatchHelper.removeDispatch(self)
    }
}

