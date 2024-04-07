//
//  QuicklyObject.swift
//  QuicklySwift
//
//  Created by rztime on 2022/10/19.
//

import UIKit
import Foundation

public extension QuicklyProtocal where Self: NSObject {
    /// 被释放时的回调
    @discardableResult
    func qdeinit(_ de: (()-> Void)?) -> Self {
        /// 通过给NSobject，添加一个obj，然后再obj里添加view的方式持有，当NSObject要被释放时，
        var helper = self.quicklyObj
        if helper == nil {
            helper = QuicklyObjectHelper.init(frame: .zero)
            self.quicklyObj = helper
        }
        let v = QuicklyObjectHelper.init(frame: .zero)
        helper?.addSubview(v)
        v.deinitAction = de
        return self
    }
    func qaddObserver(key: String, options: NSKeyValueObservingOptions, context: UnsafeMutableRawPointer?, handle: ((_ sender: Self, _ key: String, _ value: [NSKeyValueChangeKey : Any]?) -> Void)?) {
        /// 通过给NSobject，添加一个obj，然后再obj里添加view的方式持有，当NSObject要被释放时，
        var helper = self.quicklyObj
        if helper == nil {
            helper = QuicklyObjectHelper.init(frame: .zero)
            self.quicklyObj = helper
        }
        let v = QuicklyObjectHelper.init(frame: .zero)
        helper?.addSubview(v)
        v.addObs(target: self, key: key, options: options, context: context) { [weak self] sender, key, value in
            if let sender = sender as? Self, sender == self {
                handle?(sender, key, value)
            }
        }
    }
    @discardableResult
    func qthen(_ then: ((_ : Self) -> Void)?) -> Self {
        then?(self)
        return self
    }
}

private var quicklyobjnameaddres: UInt8 = 1
fileprivate extension NSObject {
    var quicklyObj: QuicklyObjectHelper? {
        set {
            objc_setAssociatedObject(self, &quicklyobjnameaddres, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &quicklyobjnameaddres) as? QuicklyObjectHelper
        }
    }
}

// MARK: - 相关辅助
public extension Optional {
    /// 是否是空，数字 = 0 也是 空
    var qisEmpty: Bool {
        if case .none = self {
            return true
        }
        if let t = self as? String {
            return t.isEmpty
        }
        if let t = self as? Array<Any> {
            return t.isEmpty
        }
        if let t = self as? NSNumber {
            return t == 0
        }
        if let t = self as? NSAttributedString {
            return t.string.isEmpty
        }
        if let t = self as? NSDictionary {
            return t.allKeys.count == 0
        }
        return false
    }
}
public protocol QuicklyIsEmptyProtoal {}
public extension QuicklyIsEmptyProtoal {
    var qisEmpty: Bool {
        if let t = self as? String {
            return t.isEmpty
        }
        if let t = self as? Array<Any> {
            return t.isEmpty
        }
        if let t = self as? NSNumber {
            return t == 0
        }
        if let t = self as? NSAttributedString {
            return t.string.isEmpty
        }
        if let t = self as? NSDictionary {
            return t.allKeys.count == 0
        }
        return false
    }
}
extension String: QuicklyIsEmptyProtoal {}
extension NSAttributedString: QuicklyIsEmptyProtoal {}
extension Array: QuicklyIsEmptyProtoal {}
extension NSDictionary: QuicklyIsEmptyProtoal {}
extension NSNumber: QuicklyIsEmptyProtoal {}
