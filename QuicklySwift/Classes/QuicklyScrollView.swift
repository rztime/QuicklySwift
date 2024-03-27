//
//  QuicklyScrollView.swift
//  QuicklySwift
//
//  Created by rztime on 2022/6/2.
//

import UIKit
public extension UIScrollView {
    @discardableResult
    func qcontentOffset(_ offset: CGPoint) -> Self {
        self.contentOffset = offset
        return self
    }
    @discardableResult
    func qcontentSize(_ size: CGSize) -> Self {
        self.contentSize = size
        return self
    }
    @discardableResult
    func qcontentInset(_ inset: UIEdgeInsets) -> Self {
        self.contentInset = inset
        return self
    }
    @discardableResult
    func qcontentInsetAdjustmentBehavior(_ beavior: QContentInsetADjustmentBehavior) -> Self {
        if #available(iOS 11.0, *) {
            self.contentInsetAdjustmentBehavior = beavior.toValue
        }
        return self
    }
    @discardableResult
    func qautomaticallyAdjustsScrollIndicatorInsets(_ insets: Bool) -> Self {
        if #available(iOS 13.0, *) {
            self.automaticallyAdjustsScrollIndicatorInsets = insets
        }
        return self
    }
    @discardableResult
    func qisDirectionalLockEnabled(_ enable: Bool) -> Self {
        self.isDirectionalLockEnabled = enable
        return self
    }
    @discardableResult
    func qbounces(_ bounces: Bool) -> Self {
        self.bounces = bounces
        return self
    }
    @discardableResult
    func qalwaysBounceVertical(_ always: Bool) -> Self {
        self.alwaysBounceVertical = always
        return self
    }
    @discardableResult
    func qalwaysBounceHorizontal(_ always: Bool) -> Self {
        self.alwaysBounceHorizontal = always
        return self
    }
    @discardableResult
    func qisPagingEnabled(_ enable: Bool) -> Self {
        self.isPagingEnabled = enable
        return self
    }
    @discardableResult
    func qisScrollEnabled(_ enable: Bool) -> Self {
        self.isScrollEnabled = enable
        return self
    }
    @discardableResult
    func qshowsVerticalScrollIndicator(_ show: Bool) -> Self {
        self.showsVerticalScrollIndicator = show
        return self
    }
    @discardableResult
    func qshowsHorizontalScrollIndicator(_ show: Bool) -> Self {
        self.showsHorizontalScrollIndicator = show
        return self
    }
    @discardableResult
    func qindicatorStyle(_ style: UIScrollView.IndicatorStyle) -> Self {
        self.indicatorStyle = style
        return self
    }
    @discardableResult
    func qverticalScrollIndicatorInsets(_ insets: UIEdgeInsets) -> Self {
        if #available(iOS 11.1, *) {
            self.verticalScrollIndicatorInsets = insets
        }
        return self
    }
    @discardableResult
    func qhorizontalScrollIndicatorInsets(_ insets: UIEdgeInsets) -> Self {
        if #available(iOS 11.1, *) {
            self.horizontalScrollIndicatorInsets = insets
        }
        return self
    }
    @discardableResult
    func qscrollIndicatorInsets(_ insets: UIEdgeInsets) -> Self {
        self.scrollIndicatorInsets = insets
        return self
    }
    @discardableResult
    func qdecelerationRate(_ rate: UIScrollView.DecelerationRate) -> Self {
        self.decelerationRate = rate
        return self
    }
    @discardableResult
    func qindexDisplayMode(_ mode: UIScrollView.IndexDisplayMode) -> Self {
        self.indexDisplayMode = mode
        return self
    }
    @discardableResult
    func qminimumZoomScale(_ scale: CGFloat) -> Self {
        self.minimumZoomScale = scale
        return self
    }
    @discardableResult
    func qmaximumZoomScale(_ scale: CGFloat) -> Self {
        self.maximumZoomScale = scale
        return self
    }
    @discardableResult
    func qzoomScale(_ scale: CGFloat) -> Self {
        self.zoomScale = scale
        return self
    }
    @discardableResult
    func qbouncesZoom(_ zoom: Bool) -> Self {
        self.bouncesZoom = zoom
        return self
    }
    @discardableResult
    func qscrollsToTop(_ totop: Bool) -> Self {
        self.scrollsToTop = totop
        return self
    }
    @discardableResult
    func qkeyboardDismissMode(_ mode: UIScrollView.KeyboardDismissMode) -> Self {
        self.keyboardDismissMode = mode
        return self
    }
}

public extension QuicklyProtocal where Self: UIScrollView {
    /// contentSize 改变之后的回调
    @discardableResult
    func qcontentSizeChanged(changed: ((_ scrollView: Self) -> Void)?) -> Self {
        var contentsize = CGSize.init(width: -1, height: -1)
        self.qaddObserver(key: "contentSize", options: [.new, .old], context: nil) { sender, key, value in
            if sender.contentSize.equalTo(contentsize) { return }
            contentsize = sender.contentSize
            changed?(sender)
        }
        changed?(self)
        return self
    }
    /// contentOffset改变之后的回调
    @discardableResult
    func qcontentOffsetChanged(changed: ((_ scrollView: Self) -> Void)?) -> Self {
        var contentoffset = CGPoint.init(x: -1, y: -1)
        self.qaddObserver(key: "contentOffset", options: [], context: nil) { sender, key, value in
            if sender.contentOffset.equalTo(contentoffset) { return }
            contentoffset = sender.contentOffset
            changed?(sender)
        }
        changed?(self)
        return self
    }
    /// scrollView停止滚动
    @discardableResult
    func qdidEndScroll(_ scroll: ((_ scrollView: Self) -> Void)?) -> Self {
        self.qhelper.didStopScroll =  { scrollView in
            if let scrollView = scrollView as? Self {
                scroll?(scrollView)
            }
        }
        return self
    }
    /// 滚动回调
    @discardableResult
    func qdidScroll(_ scroll: ((_ scrollView: Self) -> Void)?) -> Self {
        self.qhelper.didScroll = { scrollView in
            if let scrollView = scrollView as? Self {
                scroll?(scrollView)
            }
        }
        return self
    }
    /// zoom
    @discardableResult
    func qdidZoom(_ zoom: ((_ scrollView: Self) -> Void)?) -> Self {
        self.qhelper.didZoom = { scrollView in
            if let scrollView = scrollView as? Self {
                zoom?(scrollView)
            }
        }
        return self
    }
    /// willBeginDragging
    @discardableResult
    func qwillBeginDragging(_ drag: ((_ scrollView: Self) -> Void)?) -> Self {
        self.qhelper.willBeginDragging = { scrollView in
            if let scrollView = scrollView as? Self {
                drag?(scrollView)
            }
        }
        return self
    }
    /// scrollViewWillEndDragging withVelocity targetContentOffset
    @discardableResult
    func qwillEndDragging(_ end: ((_ scrollView: Self, _ velocity: CGPoint, _ targetContentOffset: UnsafeMutablePointer<CGPoint>) -> Void)?) -> Self {
        self.qhelper.willEndDragging = { scrollView, v, t in
            if let scrollView = scrollView as? Self {
                end?(scrollView, v, t)
            }
        }
        return self
    }
    /// scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    @discardableResult
    func qdidEndDragging(_ end: ((_ scrollView: Self, _ decelerate: Bool) -> Void)?) -> Self {
        self.qhelper.didEndDragging = { scrollView, d in
            if let scrollView = scrollView as? Self {
                end?(scrollView, d)
            }
        }
        return self
    }
    /// scrollViewWillBeginDecelerating(_ scrollView: UIScrollView)
    @discardableResult
    func qwillBeginDecelerating(_ begin: ((_ scrollView: Self) -> Void)?) -> Self {
        self.qhelper.willBeginDecelerating = { scrollView in
            if let scrollView = scrollView as? Self {
                begin?(scrollView)
            }
        }
        return self
    }
    /// scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    @discardableResult
    func qdidEndDecelerating(_ end: ((_ scrollView: Self) -> Void)?) -> Self {
        self.qhelper.didEndDecelerating = { scrollView in
            if let scrollView = scrollView as? Self {
                end?(scrollView)
            }
        }
        return self
    }
    /// scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView)
    @discardableResult
    func qdidEndScrollingAnimation(_ end: ((_ scrollView: Self) -> Void)?) -> Self {
        self.qhelper.didEndScrollingAnimation = { scrollView in
            if let scrollView = scrollView as? Self {
                end?(scrollView)
            }
        }
        return self
    }
    /// viewForZooming(in scrollView: UIScrollView) -> UIView?
    @discardableResult
    func qviewForZooming(_ view: ((_ scrollView: Self) -> UIView?)?) -> Self {
        self.qhelper.viewForZooming = { scrollView in
            if let scrollView = scrollView as? Self {
                return view?(scrollView)
            }
            return nil
        }
        return self
    }
    /// scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?)
    @discardableResult
    func qwillBeginZooming(_ begin: ((_ scrollView: Self, _ withView: UIView?) -> Void)?) -> Self {
        self.qhelper.willBeginZooming = { scrollView, v in
            if let scrollView = scrollView as? Self {
                begin?(scrollView, v)
            }
        }
        return self
    }
    /// scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat)
    @discardableResult
    func qdidEndZooming(_ end: ((_ scrollView: Self, _ withView: UIView?, _ atScale: CGFloat) -> Void)?) -> Self {
        self.qhelper.didEndZooming = { scrollView, v, s in
            if let scrollView = scrollView as? Self {
                end?(scrollView, v, s)
            }
        }
        return self
    }
    /// scrollViewShouldScrollToTop(_ scrollView: UIScrollView)
    @discardableResult
    func qshouldScrollToTop(_ should: ((_ scrollView: Self) -> Bool)?) -> Self {
        self.qhelper.shouldScrollToTop = { scrollView in
            if let scrollView = scrollView as? Self {
                return should?(scrollView) ?? true
            }
            return true
        }
        return self
    }
    /// scrollViewDidScrollToTop(_ scrollView: UIScrollView)
    @discardableResult
    func qdidScrollToTop(_ did: ((_ scrollView: Self) -> Void)?) -> Self {
        self.qhelper.didScrollToTop = { scrollView in
            if let scrollView = scrollView as? Self {
                did?(scrollView)
            }
        }
        return self
    }
    /// scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView)
    @discardableResult
    func qdidChangeAdjustedContentInset(_ did: ((_ scrollView: Self) -> Void)?) -> Self {
        self.qhelper.didChangeAdjustedContentInset = { scrollView in
            if let scrollView = scrollView as? Self {
                did?(scrollView)
            }
        }
        return self
    }
}

public let quicklycollectionsectionHeader = "quicklycollectionsectionHeader"
public let quicklycollectionsectionFooter = "quicklycollectionsectionFooter"

open class QScrollViewHelper: NSObject, UIScrollViewDelegate {
    open var didStopScroll: ((_ scrollView: UIScrollView) -> Void)?
    open var didScroll: ((_ scrollView: UIScrollView) -> Void)?
    open var didZoom: ((_ scrollView: UIScrollView) -> Void)?
    open var willBeginDragging: ((_ scrollView: UIScrollView) -> Void)?
    open var willEndDragging: ((_ scrollView: UIScrollView, _ velocity: CGPoint, _ targetContentOffset: UnsafeMutablePointer<CGPoint>) -> Void)?
    open var didEndDragging: ((_ scrollView: UIScrollView, _ decelerate: Bool) -> Void)?
    open var willBeginDecelerating: ((_ scrollView: UIScrollView) -> Void)?
    open var didEndDecelerating: ((_ scrollView: UIScrollView) -> Void)?
    open var didEndScrollingAnimation: ((_ scrollView: UIScrollView) -> Void)?
    open var viewForZooming: ((_ scrollView: UIScrollView) -> UIView?)?
    open var willBeginZooming: ((_ scrollView: UIScrollView, _ withView: UIView?) -> Void)?
    open var didEndZooming: ((_ scrollView: UIScrollView, _ withView: UIView?, _ atScale: CGFloat) -> Void)?
    open var shouldScrollToTop: ((_ scrollView: UIScrollView) -> Bool)?
    open var didScrollToTop: ((_ scrollView: UIScrollView) -> Void)?
    open var didChangeAdjustedContentInset: ((_ scrollView: UIScrollView) -> Void)?
    
    open weak var target: UIScrollView?
    public init(target: UIScrollView) {
        super.init()
        self.target = target
        if let collectionView = target as? UICollectionView {
            collectionView.qregisterSupplementaryView(UICollectionReusableView.self, UICollectionView.elementKindSectionHeader, quicklycollectionsectionHeader)
            collectionView.qregisterSupplementaryView(UICollectionReusableView.self, UICollectionView.elementKindSectionFooter, quicklycollectionsectionFooter)
            if collectionView.backgroundColor == nil {
                collectionView.qbackgroundColor(.white)
            } 
        }
        if let tableView = target as? UITableView {
            tableView.qsectionHeaderTopPadding(0)
                .qestimatedRowHeight(44)
                .qestimatedSectionFooterHeight(0.0001)
                .qestimatedSectionHeaderHeight(0.0001)
            if tableView.tableFooterView == nil {
                tableView.tableFooterView = .init()
            }
        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        didScroll?(scrollView)
    }
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        didZoom?(scrollView)
    }
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        willBeginDragging?(scrollView)
    }
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        willEndDragging?(scrollView, velocity, targetContentOffset)
    }
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        didEndDragging?(scrollView, decelerate)
        if !decelerate {
            let stop = scrollView.isTracking && !scrollView.isDragging && !scrollView.isDecelerating
            if stop {
                didStopScroll?(scrollView)
            }
        }
    }
    public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        willBeginDecelerating?(scrollView)
    }
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        didEndDecelerating?(scrollView)
        let stop = !scrollView.isTracking && !scrollView.isDragging && !scrollView.isDecelerating
        if stop {
            didStopScroll?(scrollView)
        }
    }
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        didEndScrollingAnimation?(scrollView)
    }
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return viewForZooming?(scrollView)
    }
    public func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        willBeginZooming?(scrollView, view)
    }
    public func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        didEndZooming?(scrollView, view, scale)
    }
    public func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return shouldScrollToTop?(scrollView) ?? true
    }
    public func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        didScrollToTop?(scrollView)
    }
    public func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
        didChangeAdjustedContentInset?(scrollView)
    }
}
