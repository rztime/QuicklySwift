//
//  QCollectionViewHelper.swift
//  QuicklySwift
//
//  Created by rztime on 2022/6/22.
//

import UIKit

open class QCollectionViewHelper: QScrollViewHelper {
    open var numberofSections: (() -> Int)?
    open var numberofRows: ((_ section: Int) -> Int)?
    open var cell: ((_ collectionView: UICollectionView, _ indexPath: IndexPath) -> UICollectionViewCell)?
    open var viewForSupplementary: ((_ collectionView: UICollectionView, _ kind: String, _ indexPath: IndexPath) -> UICollectionReusableView?)?
    open var indexTitlesFor: ((_ collectionView: UICollectionView) -> [String]?)?
    open var indexPathForIndexTitle: ((_ collectionView: UICollectionView, _ title: String, _ index: Int) -> IndexPath)?
    open var canMove: ((_ indexPath: IndexPath) -> Bool)?
    open var moveAction: ((_ indexPath: IndexPath, _ toIndexPath: IndexPath) -> Void)?
    open var canEditItem: ((_ indexPath: IndexPath) -> Bool)?
    open var didSelectItem:((_ collectionView: UICollectionView, _ indexPath: IndexPath) -> Void)?
    open var willDisplayCell: ((_ cell: UICollectionViewCell, _ indexPath: IndexPath) -> Void)?
    open var didEndDisplayCell: ((_ cell: UICollectionViewCell, _ indexPath: IndexPath) -> Void)?
    open var willDisplaySupplementaryView: ((_ view: UICollectionReusableView, _ kind: String, _ indexPath: IndexPath) -> Void)?
    open var didEndDisplaySupplementaryView: ((_ view: UICollectionReusableView, _ kind: String, _ indexPath: IndexPath) -> Void)?
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
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let v = viewForSupplementary?(collectionView, kind, indexPath) {
            return v
        }
        if kind == UICollectionView.elementKindSectionHeader {
            return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: quicklycollectionsectionHeader, for: indexPath)
        }
        if kind == UICollectionView.elementKindSectionFooter {
            return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: quicklycollectionsectionFooter, for: indexPath)
        }
        return .init()
    }
    @available(iOS 14.0, *)
    public func indexTitles(for collectionView: UICollectionView) -> [String]? {
        return indexTitlesFor?(collectionView)
    }
    @available(iOS 14.0, *)
    public func collectionView(_ collectionView: UICollectionView, indexPathForIndexTitle title: String, at index: Int) -> IndexPath {
        return indexPathForIndexTitle?(collectionView, title, index) ?? .init(item: 0, section: 0)
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
    public func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        willDisplaySupplementaryView?(view, elementKind, indexPath)
    }
    public func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        didEndDisplaySupplementaryView?(view, elementKind, indexPath)
    }
    public func collectionView(_ collectionView: UICollectionView, canEditItemAt indexPath: IndexPath) -> Bool {
        return canEditItem?(indexPath) ?? true
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
