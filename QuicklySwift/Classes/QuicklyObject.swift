//
//  QuicklyObject.swift
//  QuicklySwift
//
//  Created by rztime on 2022/10/19.
//

import UIKit

public extension NSObject {
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
        v.deinitAction = de
        helper?.addSubview(v)
        return self
    }
}
private extension NSObject {
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
private class QuicklyObjectHelper: UIView {
    open var deinitAction: (() -> Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isHidden = true
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        self.deinitAction?()
    }
}
