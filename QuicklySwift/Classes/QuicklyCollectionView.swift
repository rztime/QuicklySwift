//
//  QuicklyCollectionView.swift
//  QuicklySwift
//
//  Created by rztime on 2022/6/2.
//

import UIKit

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
}
public extension UICollectionView {
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

open class QCollectionViewHelper: QScrollViewHelper {
    open var numberofSections: (() -> Int)?
    open var numberofRows: ((_ section: Int) -> Int)?
    open var cell: ((_ collectionView: UICollectionView, _ indexPath: IndexPath) -> UICollectionViewCell)?
    open var canMove: ((_ indexPath: IndexPath) -> Bool)?
    open var moveAction: ((_ indexPath: IndexPath, _ toIndexPath: IndexPath) -> Void)?
    open var didSelectItem:((_ collectionView: UICollectionView, _ indexPath: IndexPath) -> Void)?
    open var willDisplayCell: ((_ cell: UICollectionViewCell, _ indexPath: IndexPath) -> Void)?
    open var didEndDisplayCell: ((_ cell: UICollectionViewCell, _ indexPath: IndexPath) -> Void)?
    open var sizeForItem: ((_ layout: UICollectionViewLayout, _ indexPath: IndexPath) -> CGSize)?
    open var insetForSection: ((_ layout: UICollectionViewLayout, _ section: Int) -> UIEdgeInsets)?
    open var minimumLineSpacing: ((_ layout: UICollectionViewLayout, _ section: Int) -> CGFloat)?
    open var minimumInteritemSpacing: ((_ layout: UICollectionViewLayout, _ section: Int) -> CGFloat)?
    open var referenceSizeForHeader: ((_ layout: UICollectionViewLayout, _ section: Int) -> CGSize)?
    open var referenceSizeForFooter: ((_ layout: UICollectionViewLayout, _ section: Int) -> CGSize)?
}
extension QCollectionViewHelper: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numberofSections?() ?? 1
    }
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberofRows?(section) ?? 0
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return cell?(collectionView, indexPath) ?? .init()
    }
    public func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return canMove?(indexPath) ?? false
    }
    public func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        moveAction?(sourceIndexPath, destinationIndexPath)
    }
}
extension QCollectionViewHelper: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectItem?(collectionView, indexPath)
    }
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        willDisplayCell?(cell, indexPath)
    }
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        didEndDisplayCell?(cell, indexPath)
    }
}
extension QCollectionViewHelper: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let item = sizeForItem {
            return item(collectionViewLayout, indexPath)
        }
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            return layout.itemSize
        }
        return .zero
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if let item = insetForSection {
            return item(collectionViewLayout, section)
        }
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            return layout.sectionInset
        }
        return .zero
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if let item = minimumLineSpacing {
            return item(collectionViewLayout, section)
        }
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            return layout.minimumLineSpacing
        }
        return .zero
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if let item = minimumInteritemSpacing {
            return item(collectionViewLayout, section)
        }
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            return layout.minimumInteritemSpacing
        }
        return .zero
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if let item = referenceSizeForHeader {
            return item(collectionViewLayout, section)
        }
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            return layout.headerReferenceSize
        }
        return .zero
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if let item = referenceSizeForFooter {
            return item(collectionViewLayout, section)
        }
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            return layout.footerReferenceSize
        }
        return .zero
    }
}

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
    @available(iOS 8.0, *)
    @discardableResult
    func qestimatedItemSize(_ size: CGSize) -> Self {
        self.estimatedItemSize = size
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
    @available(iOS 11.0, *)
    @discardableResult
    func qsectionInsetReference(_ reference: UICollectionViewFlowLayout.SectionInsetReference) -> Self {
        self.sectionInsetReference = reference
        return self
    }
    @discardableResult
    @available(iOS 9.0, *)
    func qsectionHeadersPinToVisibleBounds(_ value: Bool) -> Self {
        self.sectionHeadersPinToVisibleBounds = value
        return self
    }
    @discardableResult
    @available(iOS 9.0, *)
    func qsectionFootersPinToVisibleBounds(_ value: Bool) -> Self {
        self.sectionFootersPinToVisibleBounds = value
        return self
    }
}
