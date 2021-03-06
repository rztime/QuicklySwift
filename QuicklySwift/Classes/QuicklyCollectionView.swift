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
    /// ??????cell
    @discardableResult
    func qregistercell(_ cellClass: AnyClass?, _ identifier: String) -> Self {
        self.register(cellClass, forCellWithReuseIdentifier: identifier)
        return self
    }
    /// ??????SupplementaryView
    @discardableResult
    func qregisterSupplementaryView(_ viewClass: AnyClass?, _ elementKind: String, _ identifier: String) -> Self {
        self.register(viewClass, forSupplementaryViewOfKind: elementKind, withReuseIdentifier: identifier)
        return self
    }
}
// MARK: - dataSource
public extension UICollectionView {
    /// ??????section??????
    /// ??????quickly????????? ???????????????QTableViewHelper ??????????????????tableView???delagte ??? DataSource???
    @discardableResult
    func qnumberofSections(_ count: (() -> Int)?) -> Self {
        self.qcollectionViewHelper.numberofSections = count
        return self
    }
    /// ????????????section??????row
    /// ??????quickly????????? ???????????????QTableViewHelper ??????????????????tableView???delagte ??? DataSource???
    @discardableResult
    func qnumberofRows(_ count: ((_ section: Int) -> Int)?) -> Self {
        self.qcollectionViewHelper.numberofRows = count
        return self
    }
    /// ??????cell
    /// ??????quickly????????? ???????????????QTableViewHelper ??????????????????tableView???delagte ??? DataSource???
    @discardableResult
    func qcell(_ cell: ((_ collectionView: UICollectionView, _ indexPath: IndexPath) -> UICollectionViewCell)?) -> Self {
        self.qcollectionViewHelper.cell = cell
        return self
    }
    /// ???????????????view
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
    /// ??????iOS 14??????, ???????????????
    @discardableResult
    func qindexTitles(_ titles: ((_ collectionView: UICollectionView) -> [String]?)?) -> Self {
        self.qcollectionViewHelper.indexTitlesFor = titles
        return self
    }
    /// ??????iOS 14?????? ?????????????????????????????????????????????
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
    /// iOS 14??????
    @discardableResult
    func qcanEditItem(_ edit: ((_ indexPath: IndexPath) -> Bool)?) -> Self {
        self.qcollectionViewHelper.canEditItem = edit
        return self
    }
}
// MARK: - UICollectionViewDelegateFlowLayoutDelegate
public extension UICollectionView {
    /// ???????????????UICollectionViewDelegateFlowLayout
    @discardableResult
    func qsizeForItem(_ item: ((_ layout: UICollectionViewLayout, _ indexPath: IndexPath) -> CGSize)?) -> Self {
        self.qcollectionViewHelper.sizeForItem = item
        return self
    }
    /// ???????????????UICollectionViewDelegateFlowLayout
    @discardableResult
    func qinsetForSection(_ inset: ((_ layout: UICollectionViewLayout, _ section: Int) -> UIEdgeInsets)?) -> Self {
        self.qcollectionViewHelper.insetForSection = inset
        return self
    }
    /// ???????????????UICollectionViewDelegateFlowLayout
    @discardableResult
    func qminimumLineSpacing(_ space: ((_ layout: UICollectionViewLayout, _ section: Int) -> CGFloat)?) -> Self {
        self.qcollectionViewHelper.minimumLineSpacing = space
        return self
    }
    /// ???????????????UICollectionViewDelegateFlowLayout
    @discardableResult
    func qminimumInteritemSpacing(_ space: ((_ layout: UICollectionViewLayout, _ section: Int) -> CGFloat)?) -> Self {
        self.qcollectionViewHelper.minimumInteritemSpacing = space
        return self
    }
    /// ???????????????UICollectionViewDelegateFlowLayout
    @discardableResult
    func qreferenceSizeForHeader(_ size: ((_ layout: UICollectionViewLayout, _ section: Int) -> CGSize)?) -> Self {
        self.qcollectionViewHelper.referenceSizeForHeader = size
        return self
    }
    /// ???????????????UICollectionViewDelegateFlowLayout
    @discardableResult
    func qreferenceSizeForFooter(_ size: ((_ layout: UICollectionViewLayout, _ section: Int) -> CGSize)?) -> Self {
        self.qcollectionViewHelper.referenceSizeForFooter = size
        return self
    }
}
 
