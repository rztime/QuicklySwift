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
}

fileprivate extension NSObject {
    private static var quicklyobjnameaddres = "quicklyobjnameaddres"
    var quicklyObj: QuicklyObjectHelper? {
        set {
            objc_setAssociatedObject(self, &NSObject.quicklyobjnameaddres, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &NSObject.quicklyobjnameaddres) as? QuicklyObjectHelper
        }
    }
}
