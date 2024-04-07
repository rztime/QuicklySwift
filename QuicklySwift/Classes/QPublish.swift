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
        init(subscribe: ( (_ value: T) -> Void)?, disposebag: NSObject?) {
            self.subscribe = subscribe
            self.disposebag = disposebag
        }
    }
    var subscribeItems: [PublishItem] = []
    
    public var value: T
    public init(value: T) {
        self.value = value
    }
    /// 订阅
    @discardableResult
    public func subscribe(_ subscribe: ((_ value: T) -> Void)?, disposebag: NSObject?) -> Self {
        let item = PublishItem(subscribe: subscribe, disposebag: disposebag)
        self.subscribeItems.append(item)
        disposebag?.qdeinit({ [weak self] in
            self?.subscribeItems.removeAll(where: { $0.disposebag == nil })
        })
        subscribe?(value)
        return self
    }
    /// 修改value的值，并分发到所有订阅的block
    public func accept(_ value: T) {
        self.value = value
        self.subscribeItems.removeAll(where: {$0.disposebag == nil })
        self.subscribeItems.forEach { item in
            item.subscribe?(value)
        }
    }
    /// 移除监听，nil时：移除所有
    public func removeSubscribe(_ disposebag: NSObject?) {
        if let disposebag = disposebag {
            self.subscribeItems.removeAll(where: {$0.disposebag == disposebag })
        } else {
            self.subscribeItems.removeAll()
        }
    }
}
