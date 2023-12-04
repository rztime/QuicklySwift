//
//  QGrayFloatManager.swift
//  QuicklySwift
//
//  Created by rztime on 2022/12/20.
//

import UIKit
import Foundation

/// 是否飘灰 改变之后的通知
public let qfloatgrayChangeName = Notification.Name("qfloatgrayChangeName")
public let qfloatgrayzpositionChangeName = Notification.Name("qfloatgrayzpositionChangeName")
public let qfloatgrayColorChangeName = Notification.Name("qfloatgrayColorChangeName")

private var quicklyFloatgrayKey: UInt8 = 2

/// 给UIView添加一个滤镜，用于飘灰
/// 在tableView等设置frame区域，可以飘灰比如首屏，之后的正常显示
/// 原理是在view上加一个飘灰view的滤镜，但是此滤镜在某些iOS12部分小版本手机上存在问题，比如空白，无法正常显示，所以这里仅支持iOS 13以上
public extension UIView {
    /// 设置飘灰的区域，一个页面可能会几个飘灰区域，通过tag不同来区分
    @discardableResult
    func qgrayfloat(tag: Int = 0, edges: UIEdgeInsets) -> Self {
        var grayView = self.subviews.first(where: { $0.isKind(of: QGrayFloatView.self) && $0.tag == tag })
        if grayView == nil {
            let v = QGrayFloatView.init(frame: .qfull)
            self.addSubview(v)
            grayView = v
        }
        grayView?.snp.remakeConstraints { make in
            make.edges.equalToSuperview().inset(edges).priorityLow()
            make.width.equalToSuperview().priorityLow()
        }
        return self
    }
    /// 设置飘灰区域，一个页面可能会几个飘灰区域，通过tag不同来区分
    @discardableResult
    func qgrayfloat(tag: Int = 0, frame: CGRect) -> Self {
        var grayView = self.subviews.first(where: { $0.isKind(of: QGrayFloatView.self) && $0.tag == tag })
        if grayView == nil {
            let v = QGrayFloatView.init(frame: frame)
            self.addSubview(v)
            grayView = v
        }
        grayView?.snp.removeConstraints()
        grayView?.frame = frame
        return self
    }
    /// 设置是否飘灰 true： 飘灰
    /// 需要先设置飘灰区域
    var qgrayfloatActive: Bool {
        set {
            objc_setAssociatedObject(self, &quicklyFloatgrayKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
            let grayViews = self.subviews.filter({$0.isKind(of: QGrayFloatView.self)})
            grayViews.forEach { v in
                v.isHidden = !newValue
            }
        }
        get {
            if let v = objc_getAssociatedObject(self, &quicklyFloatgrayKey) as? Bool {
                return v
            }
            return false
        }
    }
    /// 移除飘灰view, 移除之后，飘灰无效，再次飘灰需要设置飘灰区域
    @discardableResult
    func qgrayfloatRemove(tag: Int = 0) -> Self {
        let grayView = self.subviews.first(where: { $0.isKind(of: QGrayFloatView.self) && $0.tag == tag })
        grayView?.removeFromSuperview()
        return self
    }
    /// 移除所有的飘灰view，移除之后，飘灰无效，再次飘灰需要设置飘灰区域
    @discardableResult
    func qgrayfloatRemoveAll() -> Self {
        let grayViews = self.subviews.filter({$0.isKind(of: QGrayFloatView.self)})
        grayViews.forEach { v in
            v.removeFromSuperview()
        }
        return self
    }
}

/// 飘灰管理
public class QGrayFloatManager {
    
    public static var shared: QGrayFloatManager = .init()
    /// 飘灰是否生效
    public var isgrayActive: Bool = false {
        didSet {
            if oldValue == isgrayActive {
                return
            }
            NotificationCenter.default.post(name: qfloatgrayChangeName, object: nil)
        }
    }
    /// 飘灰view的zpositon，默认为1， view.layer.zPosition默认为0，数值越大，图层越处于顶层
    public var zposition: CGFloat = 1 {
        didSet {
            if oldValue == zposition {
                return
            }
            NotificationCenter.default.post(name: qfloatgrayzpositionChangeName, object: nil)
        }
    }
    /// 飘灰的颜色
    public var grayColor: UIColor = .init(white: 0.99, alpha: 1) {
        didSet {
            if oldValue.isEqual(grayColor) {
                return
            }
            NotificationCenter.default.post(name: qfloatgrayColorChangeName, object: nil)
        }
    }
}
/// 飘灰的view
open class QGrayFloatView: UIView {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = false
        self.isHidden = true
        if #available(iOS 13.0, *) {
            // 在iOS 12上，有部分生效，部分不生效，不生效时，相当于在view上加了一个灰色的图层遮住导致显示空白
            self.backgroundColor = QGrayFloatManager.shared.grayColor
            self.layer.zPosition = QGrayFloatManager.shared.zposition
            self.layer.compositingFilter = "saturationBlendMode"
            
            self.qshowToWindow { view, showed in
                view.isHidden = !QGrayFloatManager.shared.isgrayActive
            }
            NotificationCenter.qaddObserver(name: qfloatgrayChangeName, object: nil, target: self) { [weak self] notification in
                self?.isHidden = !QGrayFloatManager.shared.isgrayActive
            }
            NotificationCenter.qaddObserver(name: qfloatgrayzpositionChangeName, object: nil, target: self) { [weak self] notification in
                self?.layer.zPosition = QGrayFloatManager.shared.zposition
            }
            NotificationCenter.qaddObserver(name: qfloatgrayColorChangeName, object: nil, target: self) { [weak self] notification in
                self?.backgroundColor = QGrayFloatManager.shared.grayColor
            }
        } else {
            backgroundColor = .clear
        }
    }
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return nil
    }
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
