//
//  QuicklySwift.swift
//  QuicklySwift
//
//  Created by rztime on 2022/6/1.
//

import UIKit
import SnapKit
class QuicklySwift { }

private var viewConstraintMake: UInt8 = 1
public extension UIView {
    /// 用于添加自动布局
    var qconstraintMake: ((_ make: ConstraintMaker) -> Void)? {
        set {
            objc_setAssociatedObject(self, &viewConstraintMake, newValue, .OBJC_ASSOCIATION_COPY)
        }
        get {
            return objc_getAssociatedObject(self, &viewConstraintMake) as? ((_ make: ConstraintMaker) -> Void)
        }
    }
}
private var qtextfieldhelperkey: UInt8 = 1
public extension UITextField {
    var qtextFieldHelper: QTextFieldHelper {
        set {
            objc_setAssociatedObject(self, &qtextfieldhelperkey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            if let v = objc_getAssociatedObject(self, &qtextfieldhelperkey) as? QTextFieldHelper {
                return v
            }
            let v = QTextFieldHelper.init(target: self)
            self.qtextFieldHelper = v
            return v
        }
    }
}

private var qscrollviewhelperkey : UInt8 = 1
public extension UIScrollView {
    var qhelper: QScrollViewHelper {
        set {
            objc_setAssociatedObject(self, &qscrollviewhelperkey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        get {
            if let helper = objc_getAssociatedObject(self, &qscrollviewhelperkey) as? QScrollViewHelper {
                return helper
            }
            if let tb = self as? UITableView {
                let helper = QTableViewHelper.init(target: tb)
                tb.delegate = helper
                tb.dataSource = helper
                self.qhelper = helper
            } else if let collectionView = self as? UICollectionView {
                let helper = QCollectionViewHelper.init(target: collectionView)
                collectionView.delegate = helper
                collectionView.dataSource = helper
                self.qhelper = helper
            } else if let textView = self as? UITextView {
                let helper = QTextViewHelper.init(target: textView)
                textView.delegate = helper
                self.qhelper = helper
            } else {
                let helper = QScrollViewHelper.init(target: self)
                self.delegate = helper
                self.qhelper = helper
            }
            return self.qhelper
        }
    }
}
public extension UITableView {
    var qtableViewHelper: QTableViewHelper {
        if let helper = self.qhelper as? QTableViewHelper {
            return helper
        }
        return .init(target: self)
    }
}
public extension UICollectionView {
    var qcollectionViewHelper: QCollectionViewHelper {
        if let helper = self.qhelper as? QCollectionViewHelper {
            return helper
        }
        return .init(target: self)
    }
}
public extension UITextView {
    var qtextViewHelper: QTextViewHelper {
        if let helper = self.qhelper as? QTextViewHelper {
            return helper
        }
        return .init(target: self)
    }
}

public protocol QuicklyProtocal {}
extension NSObject: QuicklyProtocal {}
