//
//  QPublish.swift
//  QuicklySwift
//
//  Created by rztime on 2023/7/24.
//

import UIKit

/// 用于订阅-分发 (RXSwift的BehaviorRelay的简易实现)
public class QPublish<T> {
    class PublishItem {
        var subscribe: ((_ value: T) -> Void)?
        weak var disposebag: NSObject?
        /// 跳过前 n 次触发，0 表示不跳过
        var skip: Int = 0
        /// 最多成功执行 n 次，0 表示不限制；达上限后自动移除该订阅
        var max: Int = 0
        /// 已触发次数（含被 skip 掉的）
        private var triggerCount: Int = 0
        /// 已成功执行回调次数
        private var executeCount: Int = 0

        init(subscribe: ((_ value: T) -> Void)?, disposebag: NSObject?, skip: Int, max: Int) {
            self.subscribe = subscribe
            self.disposebag = disposebag
            self.skip = Swift.max(0, skip)
            self.max = Swift.max(0, max)
        }

        /// 按 skip / max 规则投递一次；返回 true 表示已达 max，应移除订阅
        func deliver(_ value: T) -> Bool {
            triggerCount += 1
            if skip > 0, triggerCount <= skip {
                return false
            }
            if max > 0, executeCount >= max {
                return true
            }
            subscribe?(value)
            executeCount += 1
            return max > 0 && executeCount >= max
        }
    }

    var subscribeItems: [PublishItem] = []

    public var value: T
    public init(value: T) {
        self.value = value
    }

    /// 订阅
    /// - Parameters:
    ///   - subscribe: 回调；subscribe 时会立即以当前 value 触发一次（受 skip/max 约束）
    ///   - disposebag: 生命周期绑定，deinit 时自动移除；传 nil 则需手动 removeSubscribe
    ///   - skip: 跳过前 n 次触发（含订阅时的首次），默认 0 不跳过
    ///   - max: 最多成功执行 n 次，默认 0 不限制；达上限后自动移除该订阅
    /// - Note: skip 与 max 可同时生效：先 skip，再计入/限制 max
    @discardableResult
    public func subscribe(
        _ subscribe: ((_ value: T) -> Void)?,
        disposebag: NSObject?,
        skip: Int = 0,
        max: Int = 0
    ) -> Self {
        let item = PublishItem(subscribe: subscribe, disposebag: disposebag, skip: skip, max: max)
        self.subscribeItems.append(item)
        disposebag?.qdeinit({ [weak self] in
            self?.subscribeItems.removeAll(where: { $0.disposebag == nil })
        })
        if item.deliver(value) {
            self.subscribeItems.removeAll(where: { $0 === item })
        }
        return self
    }

    /// 修改value的值，并分发到所有订阅的block
    public func accept(_ value: T) {
        self.value = value
        self.subscribeItems.removeAll(where: { $0.disposebag == nil })
        var exhaustedItems: [PublishItem] = []
        self.subscribeItems.forEach { item in
            if item.deliver(value) {
                exhaustedItems.append(item)
            }
        }
        if !exhaustedItems.isEmpty {
            self.subscribeItems.removeAll(where: { item in
                exhaustedItems.contains(where: { $0 === item })
            })
        }
    }

    /// 移除监听，nil时：移除所有
    public func removeSubscribe(_ disposebag: NSObject?) {
        if let disposebag = disposebag {
            self.subscribeItems.removeAll(where: { $0.disposebag == disposebag })
        } else {
            self.subscribeItems.removeAll()
        }
    }
}
