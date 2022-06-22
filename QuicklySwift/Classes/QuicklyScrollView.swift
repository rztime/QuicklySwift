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
    @available(iOS 11.0, *)
    func qcontentInsetAdjustmentBehavior(_ beavior: UIScrollView.ContentInsetAdjustmentBehavior) -> Self {
        self.contentInsetAdjustmentBehavior = beavior
        return self
    }
    @available(iOS 13.0, *)
    func qautomaticallyAdjustsScrollIndicatorInsets(_ insets: Bool) -> Self {
        self.automaticallyAdjustsScrollIndicatorInsets = insets
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
    @available(iOS 11.1, *)
    @discardableResult
    func qverticalScrollIndicatorInsets(_ insets: UIEdgeInsets) -> Self {
        self.verticalScrollIndicatorInsets = insets
        return self
    }
    @available(iOS 11.1, *)
    @discardableResult
    func qhorizontalScrollIndicatorInsets(_ insets: UIEdgeInsets) -> Self {
        self.horizontalScrollIndicatorInsets = insets
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

public extension UIScrollView {
    /// contentSize 改变之后的回调
    @discardableResult
    func qcontentSizeChanged(changed: ((_ scrollView: UIScrollView) -> Void)?) -> Self {
        self.qhelper.contentSizeChanged = changed
        return self
    }
    /// contentOffset改变之后的回调
    @discardableResult
    func qcontentOffsetChanged(changed: ((_ scrollView: UIScrollView) -> Void)?) -> Self {
        self.qhelper.contentOffsetChanged = changed
        return self
    }
}

// MARK: - 对UIScrollView的delegate进行quickly设置
public extension UIScrollView {
    /// scrollView停止滚动
    @discardableResult
    func qdidEndScroll(_ scroll: ((_ scrollView: UIScrollView) -> Void)?) -> Self {
        self.qhelper.didStopScroll = scroll
        return self
    }
    /// 滚动回调
    @discardableResult
    func qdidScroll(_ scroll: ((_ scrollView: UIScrollView) -> Void)?) -> Self {
        self.qhelper.didScroll = scroll
        return self
    }
    /// zoom
    @discardableResult
    func qdidZoom(_ zoom: ((_ scrollView: UIScrollView) -> Void)?) -> Self {
        self.qhelper.didZoom = zoom
        return self
    }
    /// willBeginDragging
    @discardableResult
    func qwillBeginDragging(_ drag: ((_ scrollView: UIScrollView) -> Void)?) -> Self {
        self.qhelper.willBeginDragging = drag
        return self
    }
    /// scrollViewWillEndDragging withVelocity targetContentOffset
    @discardableResult
    func qwillEndDragging(_ end: ((_ scrollView: UIScrollView, _ velocity: CGPoint, _ targetContentOffset: UnsafeMutablePointer<CGPoint>) -> Void)?) -> Self {
        self.qhelper.willEndDragging = end
        return self
    }
    /// scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    @discardableResult
    func qdidEndDragging(_ end: ((_ scrollView: UIScrollView, _ decelerate: Bool) -> Void)?) -> Self {
        self.qhelper.didEndDragging = end
        return self
    }
    /// scrollViewWillBeginDecelerating(_ scrollView: UIScrollView)
    @discardableResult
    func qwillBeginDecelerating(_ begin: ((_ scrollView: UIScrollView) -> Void)?) -> Self {
        self.qhelper.willBeginDecelerating = begin
        return self
    }
    /// scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    @discardableResult
    func qdidEndDecelerating(_ end: ((_ scrollView: UIScrollView) -> Void)?) -> Self {
        self.qhelper.didEndDecelerating = end
        return self
    }
    /// scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView)
    @discardableResult
    func qdidEndScrollingAnimation(_ end: ((_ scrollView: UIScrollView) -> Void)?) -> Self {
        self.qhelper.didEndScrollingAnimation = end
        return self
    }
    /// viewForZooming(in scrollView: UIScrollView) -> UIView?
    @discardableResult
    func qviewForZooming(_ view: ((_ scrollView: UIScrollView) -> UIView?)?) -> Self {
        self.qhelper.viewForZooming = view
        return self
    }
    /// scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?)
    @discardableResult
    func qwillBeginZooming(_ begin: ((_ scrollView: UIScrollView, _ withView: UIView?) -> Void)?) -> Self {
        self.qhelper.willBeginZooming = begin
        return self
    }
    /// scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat)
    @discardableResult
    func qdidEndZooming(_ end: ((_ scrollView: UIScrollView, _ withView: UIView?, _ atScale: CGFloat) -> Void)?) -> Self {
        self.qhelper.didEndZooming = end
        return self
    }
    /// scrollViewShouldScrollToTop(_ scrollView: UIScrollView)
    @discardableResult
    func qshouldScrollToTop(_ should: ((_ scrollView: UIScrollView) -> Bool)?) -> Self {
        self.qhelper.shouldScrollToTop = should
        return self
    }
    /// scrollViewDidScrollToTop(_ scrollView: UIScrollView)
    @discardableResult
    func qdidScrollToTop(_ did: ((_ scrollView: UIScrollView) -> Void)?) -> Self {
        self.qhelper.didScrollToTop = did
        return self
    }
    /// scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView)
    @discardableResult
    func qdidChangeAdjustedContentInset(_ did: ((_ scrollView: UIScrollView) -> Void)?) -> Self {
        self.qhelper.didChangeAdjustedContentInset = did
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
    
    open var _contentSize = CGSize.init(width: -1, height: -1)
    open var contentSizeChanged: ((_ scrollView: UIScrollView) -> Void)?
    
    open var _contentOffset = CGPoint.init(x: -1, y: -1) 
    open var contentOffsetChanged: ((_ scrollView: UIScrollView) -> Void)?
    
    open weak var target: UIScrollView?
    public init(target: UIScrollView) {
        super.init()
        self.target = target
        self.target?.addObserver(self, forKeyPath: "contentSize", options: [.new, .old], context: nil)
        self.target?.addObserver(self, forKeyPath: "contentOffset", options: [.new, .old], context: nil)
        if let collectionView = target as? UICollectionView {
            collectionView.qregisterSupplementaryView(UICollectionReusableView.self, UICollectionView.elementKindSectionHeader, quicklycollectionsectionHeader)
            collectionView.qregisterSupplementaryView(UICollectionReusableView.self, UICollectionView.elementKindSectionFooter, quicklycollectionsectionFooter)
            if collectionView.backgroundColor == nil {
                collectionView.qbackgroundColor(.white)
            } 
        }
        if let tableView = target as? UITableView, tableView.tableFooterView == nil {
            tableView.tableFooterView = .init()
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
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let object = object as? UIScrollView, object == self.target else {
            return
        }
        if keyPath == "contentSize" {
            if !object.contentSize.equalTo(self._contentSize) {
                self.contentSizeChanged?(object)
            }
            self._contentSize = object.contentSize
        } else if keyPath == "contentOffset" {
            if !object.contentOffset.equalTo(self._contentOffset) {
                self.contentOffsetChanged?(object)
            }
            self._contentOffset = object.contentOffset
        }
    }
    deinit {
        self.target?.removeObserver(self, forKeyPath: "contentSize")
        self.target?.removeObserver(self, forKeyPath: "contentOffset")
    }
}
