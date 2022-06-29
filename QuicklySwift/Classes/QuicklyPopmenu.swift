//
//  QuicklyPopmenu.swift
//  QuicklySwift
//
//  Created by rztime on 2022/6/28.
//

import UIKit
/// 气泡弹窗
open class QuicklyPopmenu: UIView {
    
    public let contentView = UIView()
    public let statcView = UIStackView()
    
    public var titles: [String] = []
    public var font = UIFont.systemFont(ofSize: 14)
    public var textColor = UIColor.white
    
    public var titleAttributes: [NSAttributedString] = []
    
    public var itemSize: CGSize?
    
    /// 气泡弹窗显示的的参照点
    public var referPoint: CGPoint?
    
    /// 如果是手势点击，要显示的位置的参照view
    public weak var target: UIView?
    /// 手势点击时，在target的位置
    public var fingerLocation: CGPoint?

    /// 气泡的三角形大小
    public var deltaSize = CGSize.init(width: 10, height: 10)
    /// 气泡四角圆角
    public var corners: UIRectCorner = .allCorners
    /// 圆角度
    public var radii: CGFloat = 10
    // 气泡的位置
    public var location: QairbubbleLocation = .bottom(x: 0)
    /// 气泡背景色
    public var bgcolor: UIColor? = UIColor.init(white: 0, alpha: 1)
    
    /// 排列
    public enum QPopmenuStyle {
        /// 水平排列，一排count个
        case horizontal(count: Int)
        /// 垂直排列
        case vertical
    }
    public var style: QPopmenuStyle = .vertical
    /// 点击之后的回调
    public var complete: ((_ index: Int) -> Void)?
    
    public init(style: QPopmenuStyle) {
        super.init(frame: .qfull)
        super.backgroundColor = .black.withAlphaComponent(0.3)
        self.style = style
        statcView.qaxis(.vertical).qspacing(15).qalignment(.leading)
        let btn = UIButton.init(type: .custom).qtap { [weak self] view in
            self?.removeFromSuperview()
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear) {
                self?.alpha = 0
            } completion: { _ in
                self?.removeFromSuperview()
            }
        }
        
        self.qbody([
            btn.qmakeConstraints({ make in
                make.edges.equalToSuperview()
            }),
            contentView.qmakeConstraints({ make in
                make.left.top.equalToSuperview()
            })
        ])
        contentView.qbody([ statcView ])
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @discardableResult
    open class func show(titles: [String] = [], attributedTitles: [NSAttributedString] = [], style: QPopmenuStyle, referto: CGPoint, complete: ((_ index: Int) -> Void)?) -> QuicklyPopmenu {
        let popmenu = QuicklyPopmenu.init(style: style)
        popmenu.titleAttributes = attributedTitles
        popmenu.titles = titles
        popmenu.referPoint = referto
        popmenu.reload()
        popmenu.show()
        popmenu.complete = complete
        return popmenu
    }
    
    @discardableResult
    /// 手势点击时，在targetview上显示菜单
    /// - Parameters:
    ///   - titles: 标题
    ///   - style: 弹窗类型
    ///   - fingerLocation: 手势在targetview的位置
    ///   - target: 要参照的点击view
    open class func show(titles: [String] = [], attributedTitles: [NSAttributedString] = [], style: QPopmenuStyle, fingerLocation: CGPoint, target: UIView, complete: ((_ index: Int) -> Void)?) -> QuicklyPopmenu {
        let popmenu = QuicklyPopmenu.init(style: style)
        popmenu.target = target
        popmenu.titleAttributes = attributedTitles
        popmenu.titles = titles
        popmenu.fingerLocation = fingerLocation
        popmenu.target = target
        popmenu.reload()
        popmenu.show()
        popmenu.complete = complete
        return popmenu
    }
}
extension QuicklyPopmenu {
    /// 如果通过show方法之后，拿到view，修改了内部的信息，需要调用reload() 生效
    public func reload() {
        statcView.snp.remakeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets.init(top: 10, left: 15, bottom: 10 + deltaSize.height, right: 15))
        }
        statcView.qremoveAllArrangedSubviews()
        var items: [NSAttributedString] = self.titleAttributes
        if !titles.isEmpty {
            items = titles.compactMap { text in
                let p = NSMutableParagraphStyle.init()
                p.alignment = .center
                return NSAttributedString.init(string: text, attributes: [.font: self.font, .foregroundColor: self.textColor, .paragraphStyle: p])
            }
        }
        var index = 0
        func creatLabel(_ text: NSAttributedString?) -> UILabel {
            let label = UILabel.init().qattributedText(text).qnumberOfLines(0).qtag(index)
                .qtap { [weak self] view in
                    self?.complete?(view.tag)
                    UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear) {
                        self?.alpha = 0
                    } completion: { _ in
                        self?.removeFromSuperview()
                    }
                }
            index += 1
            if let size = self.itemSize {
                label.snp.makeConstraints { make in
                    make.size.equalTo(size)
                }
            }
            return label
        }
        switch style {
        case .horizontal(let count):
            items.qgroup(step: count).forEach { hor in
                let labels : [UILabel] = hor.compactMap { text in
                    return creatLabel(text)
                }
                let H = HStackView.qbody(labels).qalignment(.top).qspacing(15)
                statcView.qaddArrangedSubview(H)
            }
        case .vertical:
            let labels: [UILabel] = items.compactMap { text in
                return creatLabel(text)
            }
            statcView.qbody(labels)
        }
        statcView.layoutIfNeeded()
        contentView.layoutIfNeeded()
        var tempPoint: CGPoint = .zero
        if let refer =  referPoint {
            tempPoint = refer
        } else if let finger = fingerLocation, let target = target  {
            let targetframe = target.convert(target.bounds, to: qappKeyWindow)
            tempPoint = .init(x: finger.x + targetframe.minX, y: targetframe.minY)
        }
        var frame = CGRect.init(x: tempPoint.x - contentView.frame.width / 2, y: tempPoint.y - contentView.frame.height, width: contentView.frame.width, height: contentView.frame.height)
      
        if frame.minX < 20 {
            frame.origin.x = 20
        }
        if frame.maxX > qscreenwidth - 20 {
            frame.origin.x = qscreenwidth - 20 - frame.size.width
        }
        if frame.minY < qnavigationbarHeight + 10 {
            frame.origin.y = tempPoint.y + 10 + (target?.frame.height ?? 0)
            self.location = .up(x: 0)
            statcView.snp.remakeConstraints { make in
                make.edges.equalToSuperview().inset(UIEdgeInsets.init(top: 10 + deltaSize.height, left: 15, bottom: 10, right: 15))
            }
        } else {
            self.location = .bottom(x: 0)
            statcView.snp.remakeConstraints { make in
                make.edges.equalToSuperview().inset(UIEdgeInsets.init(top: 10, left: 15, bottom: 10 + deltaSize.height, right: 15))
            }
        }

        contentView.layer.qairbubble(self.corners, radii: self.radii, air: self.deltaSize, location: self.location, color: self.bgcolor)
        contentView.snp.updateConstraints { make in
            make.left.equalToSuperview().inset(frame.minX)
            make.top.equalToSuperview().inset(frame.minY)
        }
    }
    public func show() {
        qappKeyWindow.addSubview(self)
        self.alpha = 0
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear) {
            self.alpha = 1
        } completion: { _ in
            
        }
    }
}
