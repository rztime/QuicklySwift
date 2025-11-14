//
//  QuicklyCollectionView.swift
//  QuicklySwift
//
//  Created by rztime on 2022/6/2.
//

import UIKit

public extension UICollectionViewFlowLayout {
   @discardableResult
   func qminimumLineSpacing(_ space: CGFloat) -> Self {
       self.minimumLineSpacing = space
       return self
   }
   @discardableResult
   func qminimumInteritemSpacing(_ space: CGFloat) -> Self {
       self.minimumInteritemSpacing = space
       return self
   }
   @discardableResult
   func qitemSize(_ size: CGSize) -> Self {
       self.itemSize = size
       return self
   }
   @discardableResult
   func qestimatedItemSize(_ size: CGSize) -> Self {
       if #available(iOS 8.0, *) {
           self.estimatedItemSize = size
       }
       return self
   }
   @discardableResult
   func qscrollDirection(_ direction: UICollectionView.ScrollDirection) -> Self {
       self.scrollDirection = direction
       return self
   }
   @discardableResult
   func qheaderReferenceSize(_ size: CGSize) -> Self {
       self.headerReferenceSize = size
       return self
   }
   @discardableResult
   func qfooterReferenceSize(_ size: CGSize) -> Self {
       self.footerReferenceSize = size
       return self
   }
   @discardableResult
   func qsectionInset(_ inset: UIEdgeInsets) -> Self {
       self.sectionInset = inset
       return self
   }
 
   @discardableResult
   func qsectionInsetReference(_ reference: QCollectionViewSectionInsetReference) -> Self {
       if #available(iOS 11.0, *) {
           self.sectionInsetReference = reference.toValue
       }
       return self
   }
   @discardableResult
   func qsectionHeadersPinToVisibleBounds(_ value: Bool) -> Self {
       if #available(iOS 9.0, *) {
           self.sectionHeadersPinToVisibleBounds = value
       }
       return self
   }
   @discardableResult 
   func qsectionFootersPinToVisibleBounds(_ value: Bool) -> Self {
       if #available(iOS 9.0, *) {
           self.sectionFootersPinToVisibleBounds = value
       }
       return self
   }
}

public extension UICollectionView {
    @discardableResult
    func qdelegate(_ delegate: UICollectionViewDelegate?) -> Self {
        self.delegate = delegate
        return self
    }
    @discardableResult
    func qdataSource(_ dataSource: UICollectionViewDataSource?) -> Self {
        self.dataSource = dataSource
        return self
    }
    /// 注册cell
    @discardableResult
    func qregistercell(_ cellClass: AnyClass?, _ identifier: String) -> Self {
        self.register(cellClass, forCellWithReuseIdentifier: identifier)
        return self
    }
    /// 注册SupplementaryView
    @discardableResult
    func qregisterSupplementaryView(_ viewClass: AnyClass?, _ elementKind: String, _ identifier: String) -> Self {
        self.register(viewClass, forSupplementaryViewOfKind: elementKind, withReuseIdentifier: identifier)
        return self
    }
    /// 获取item的数量
    func qitemsCount() -> Int {
        var count = 0
        let sections = self.numberOfSections
        var i = 1
        while i <= sections {
            count += self.numberOfItems(inSection: i - 1)
            i += 1
        }
        return count
    }
}
// MARK: - dataSource
public extension UICollectionView {
    /// 设置section数量
    /// 使用quickly方法时 内部会设置QTableViewHelper 此时请勿设置tableView的delagte 和 DataSource，
    @discardableResult
    func qnumberofSections(_ count: (() -> Int)?) -> Self {
        self.qcollectionViewHelper.numberofSections = count
        return self
    }
    /// 设置每个section多少row
    /// 使用quickly方法时 内部会设置QTableViewHelper 此时请勿设置tableView的delagte 和 DataSource，
    @discardableResult
    func qnumberofRows(_ count: ((_ section: Int) -> Int)?) -> Self {
        self.qcollectionViewHelper.numberofRows = count
        return self
    }
    /// 设置cell
    /// 使用quickly方法时 内部会设置QTableViewHelper 此时请勿设置tableView的delagte 和 DataSource，
    @discardableResult
    func qcell(_ cell: ((_ collectionView: UICollectionView, _ indexPath: IndexPath) -> UICollectionViewCell)?) -> Self {
        self.qcollectionViewHelper.cell = cell
        return self
    }
    /// 设置头、尾view
    @discardableResult
    func qviewForSupplementary(_ view: ((_ collectionView: UICollectionView, _ kind: String, _ indexPath: IndexPath) -> UICollectionReusableView?)?) -> Self {
        self.qcollectionViewHelper.viewForSupplementary = view
        return self
    }
    @discardableResult
    func qcanMove(_ canMove: ((_ indexPath: IndexPath) -> Bool)?) -> Self {
        self.qcollectionViewHelper.canMove = canMove
        return self
    }
    @discardableResult
    func qmoveAction(_ move: ((_ indexPath: IndexPath, _ toIndexPath: IndexPath) -> Void)?) -> Self {
        self.qcollectionViewHelper.moveAction = move
        return self
    }
    /// 只有iOS 14有效, 右侧小导引
    @discardableResult
    func qindexTitles(_ titles: ((_ collectionView: UICollectionView) -> [String]?)?) -> Self {
        self.qcollectionViewHelper.indexTitlesFor = titles
        return self
    }
    /// 只有iOS 14有效 点击右侧小导引的时候跳转的位置
    @discardableResult
    func qindexPathForIndexTitle(_ indexPath: ((_ collectionView: UICollectionView, _ title: String, _ index: Int) -> IndexPath)?) -> Self {
        self.qcollectionViewHelper.indexPathForIndexTitle = indexPath
        return self
    }
}
// MARK: - delagte
public extension UICollectionView {
    @discardableResult
    func qdidSelectItem(_ item: ((_ collectionView: UICollectionView, _ indexPath: IndexPath) -> Void)?) -> Self {
        self.qcollectionViewHelper.didSelectItem = item
        return self
    }
    @discardableResult
    func qwillDisplayCell(_ cell: ((_ cell: UICollectionViewCell, _ indexPath: IndexPath) -> Void)?) -> Self {
        self.qcollectionViewHelper.willDisplayCell = cell
        return self
    }
    @discardableResult
    func qdidEndDisplayCell(_ cell: ((_ cell: UICollectionViewCell, _ indexPath: IndexPath) -> Void)?) -> Self {
        self.qcollectionViewHelper.didEndDisplayCell = cell
        return self
    }
    @discardableResult
    func qwillDisplaySupplementaryView(_ view: ((_ view: UICollectionReusableView, _ kind: String, _ indexPath: IndexPath) -> Void)?) -> Self {
        self.qcollectionViewHelper.willDisplaySupplementaryView = view
        return self
    }
    @discardableResult
    func qdidEndDisplaySupplementaryView(_ view: ((_ view: UICollectionReusableView, _ kind: String, _ indexPath: IndexPath) -> Void)?) -> Self {
        self.qcollectionViewHelper.didEndDisplaySupplementaryView = view
        return self
    }
    /// iOS 14有效
    @discardableResult
    func qcanEditItem(_ edit: ((_ indexPath: IndexPath) -> Bool)?) -> Self {
        self.qcollectionViewHelper.canEditItem = edit
        return self
    }
}
// MARK: - UICollectionViewDelegateFlowLayoutDelegate
public extension UICollectionView {
    /// 需要设置为UICollectionViewDelegateFlowLayout
    @discardableResult
    func qsizeForItem(_ item: ((_ layout: UICollectionViewLayout, _ indexPath: IndexPath) -> CGSize)?) -> Self {
        self.qcollectionViewHelper.sizeForItem = item
        return self
    }
    /// 需要设置为UICollectionViewDelegateFlowLayout
    @discardableResult
    func qinsetForSection(_ inset: ((_ layout: UICollectionViewLayout, _ section: Int) -> UIEdgeInsets)?) -> Self {
        self.qcollectionViewHelper.insetForSection = inset
        return self
    }
    /// 需要设置为UICollectionViewDelegateFlowLayout
    @discardableResult
    func qminimumLineSpacing(_ space: ((_ layout: UICollectionViewLayout, _ section: Int) -> CGFloat)?) -> Self {
        self.qcollectionViewHelper.minimumLineSpacing = space
        return self
    }
    /// 需要设置为UICollectionViewDelegateFlowLayout
    @discardableResult
    func qminimumInteritemSpacing(_ space: ((_ layout: UICollectionViewLayout, _ section: Int) -> CGFloat)?) -> Self {
        self.qcollectionViewHelper.minimumInteritemSpacing = space
        return self
    }
    /// 需要设置为UICollectionViewDelegateFlowLayout
    @discardableResult
    func qreferenceSizeForHeader(_ size: ((_ layout: UICollectionViewLayout, _ section: Int) -> CGSize)?) -> Self {
        self.qcollectionViewHelper.referenceSizeForHeader = size
        return self
    }
    /// 需要设置为UICollectionViewDelegateFlowLayout
    @discardableResult
    func qreferenceSizeForFooter(_ size: ((_ layout: UICollectionViewLayout, _ section: Int) -> CGSize)?) -> Self {
        self.qcollectionViewHelper.referenceSizeForFooter = size
        return self
    }
}

public extension UICollectionView {
    class QAutoRollCycle {
        public var timeInterval: TimeInterval = 0
        public var page: Int = 0
        public var timerObs = NSObject()
        public var currentPagePublish: QPublish<Int> = .init(value: 0)
        
        public var timer: Timer?
        public var currentPage: Int = 0 {
            didSet {
                let p = currentPage % page
                if p != self.currentPagePublish.value {
                    currentPagePublish.accept(p)
                }
            }
        }
        public init() { }
    }
    var qauto_roll_target: QAutoRollCycle? {
        get {
            if let obj = self.qvalue(for: "qauto_roll_target") as? QAutoRollCycle {
                return obj
            }
            let obj = QAutoRollCycle.init()
            self.qsetValue(obj, key: "qauto_roll_target")
            return obj
        }
        set {
            self.qsetValue(newValue, key: "qauto_roll_target")
        }
    }
    /// 无限循环滚动，timer = 0 时，停止滚动，
    /// page为原始滚动页数，
    /// 数据源请至少复制3次，无限循环一直在2里
    func qautoRollCycle(timer: TimeInterval, page: Int) {
        self.stopAutoScroll()
        if timer <= 0 {
            self.qdidEndDragging(nil)
                .qdidEndDecelerating(nil)
                .qdidEndScrollingAnimation(nil)
                .qshowToWindow(nil)
            return
        }
        let target = self.qauto_roll_target
        target?.timeInterval = timer
        target?.page = page
        target?.timerObs = .init()
        self
            .qdidEndDragging { [weak self] _, decelerate in
                if !decelerate {
                    self?.starAutoScroll()
                }
            }
            .qdidEndDecelerating { [weak self] _ in
                self?.starAutoScroll()
                self?.resetContentOffsetIfNeeded()
            }
            .qdidEndScrollingAnimation { [weak self] _ in
                self?.resetContentOffsetIfNeeded()
            }
            .qshowToWindow { [weak self] _, show in
                if show {
                    self?.qauto_roll_target?.timer?.qresume()
                    self?.resetContentOffsetIfNeeded()
                } else {
                    self?.qauto_roll_target?.timer?.qpause()
                }
            }
        DispatchQueue.main.async(execute: { [weak self] in
            self?.starAutoScroll()
        })
    }
    func starAutoScroll() {
        stopAutoScroll()
        guard let target = self.qauto_roll_target else { return }
        target.timer = Timer.qtimer(interval: target.timeInterval, target: target.timerObs, repeats: true, mode: .common) { [weak self] _ in
            self?.scrollToNextPage()
        }
        resetContentOffsetIfNeeded()
    }
    func stopAutoScroll() {
        self.qauto_roll_target?.timerObs = .init()
    }
    func scrollToNextPage() {
        guard let target = self.qauto_roll_target else { return }
        resetContentOffsetIfNeeded()
        let nextIndex = target.currentPage + 1
        let x = CGFloat(nextIndex) * self.frame.size.width
        self.scrollRectToVisible(.init(x: x, y: 0, width: self.frame.size.width, height: self.frame.size.height), animated: true)
        target.currentPage = nextIndex
    }
    // 处理无限循环的关键逻辑
    func resetContentOffsetIfNeeded() {
        let w = self.frame.size.width
        guard w > 0, let target = self.qauto_roll_target else { return }

        let offsetX = self.contentOffset.x
        var page = Int(offsetX / w)
        if Int(offsetX) % Int(w) != 0 {
            page = page + 1
        }
        if page <= target.page - 1 {
            page += target.page
        } else if page >= target.page * 2 + 1 {
            page -= target.page
        }
        let x = CGFloat(page) * w
        if Int(x) != Int(offsetX) {
            self.scrollRectToVisible(.init(x: x, y: 0, width: w, height: self.frame.size.height), animated: false)
        }
        // 更新当前页码
        let newx =  self.contentOffset.x
        let index = Int(newx / w)
        if target.currentPage != index {
            target.currentPage = index
        }
    }
}
