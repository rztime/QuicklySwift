//
//  QTableViewHelper.swift
//  QuicklySwift
//
//  Created by rztime on 2022/6/22.
//

import UIKit

open class QTableViewHelper: QScrollViewHelper {
    open var numberofSections: (() -> Int)?
    open var numberofRows: ((_ section: Int) -> Int)?
    open var cell: ((_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell)?
    open var titleForHeader: ((_ section: Int) -> String?)?
    open var titleForFooter: ((_ section: Int) -> String?)?
    
    open var heightForHeader: ((_ section: Int) -> CGFloat)?
    open var heightForFooter: ((_ section: Int) -> CGFloat)?
    open var heightForRow: ((_ indexPath: IndexPath) -> CGFloat)?
    
    open var estimatedheightForHeader: ((_ section: Int) -> CGFloat)?
    open var estimatedheightForFooter: ((_ section: Int) -> CGFloat)?
    open var estimatedheightForRow: ((_ indexPath: IndexPath) -> CGFloat)?
    
    open var viewForHeader: ((_ tableView: UITableView, _ section: Int) -> UIView?)?
    open var viewForFooter: ((_ tableView: UITableView, _ section: Int) -> UIView?)?
    
    open var willDisplayCell: ((_ cell: UITableViewCell, _ indexPath: IndexPath) -> Void)?
    open var willDisplayHeader: ((_ view: UIView, _ section: Int) -> Void)?
    open var willDisplayFooter: ((_ view: UIView, _ section: Int) -> Void)?
    
    open var didEndDisplayCell: ((_ cell: UITableViewCell, _ indexPath: IndexPath) -> Void)?
    open var didEndDisplayHeader: ((_ view: UIView, _ section: Int) -> Void)?
    open var didEndDisplayFooter: ((_ view: UIView, _ section: Int) -> Void)?
    
    open var didSelectRow:((_ tableView: UITableView, _ indexPath: IndexPath) -> Void)?
    open var didDeselectRow:((_ tableView: UITableView, _ indexPath: IndexPath) -> Void)?
    
    open var canEdit: ((_ indexPath: IndexPath) -> Bool)?
    open var editActions: ((_ indexPath: IndexPath) -> [UITableViewRowAction]?)?
    
    open var canMove: ((_ indexPath: IndexPath) -> Bool)?
    open var moveAction: ((_ indexPath: IndexPath, _ toIndexPath: IndexPath) -> Void)?
    
    open var sectionIndexTitles: (() -> [String]?)?
    open var sectionForSectionIndexTitle: ((_ title: String, _ index: Int) -> Int)?

    open var editingStyleForRow: ((_ indexPath: IndexPath) -> UITableViewCell.EditingStyle)?
    open var commitEditingStyle: ((_ style: UITableViewCell.EditingStyle, _ indexPath: IndexPath) -> Void)?
    
    open var willSelectRow: ((_ tableView: UITableView, _ indexPath: IndexPath) -> IndexPath?)?
    open var willDeselectRow: ((_ tableView: UITableView, _ indexPath: IndexPath) -> IndexPath?)?
    open var shouldHighlightRow: ((_ indexPath: IndexPath) -> Bool)?
    open var didHighlightRow: ((_ indexPath: IndexPath) -> Void)?
    open var didUnhighlightRow: ((_ indexPath: IndexPath) -> Void)?
    open var accessoryButtonTapped: ((_ indexPath: IndexPath) -> Void)?
    open var indentationLevelForRow: ((_ indexPath: IndexPath) -> Int)?
    open var shouldIndentWhileEditing: ((_ indexPath: IndexPath) -> Bool)?
    open var willBeginEditingRow: ((_ indexPath: IndexPath) -> Void)?
    open var didEndEditingRow: ((_ indexPath: IndexPath?) -> Void)?
    open var targetIndexPathForMove: ((_ fromIndexPath: IndexPath, _ toProposedIndexPath: IndexPath) -> IndexPath)?
    open var titleForDeleteConfirmationButton: ((_ indexPath: IndexPath) -> String?)?
    /// 返回 UISwipeActionsConfiguration?（iOS 11+），用 Any 擦除以兼容更低部署版本
    open var leadingSwipeActions: ((_ indexPath: IndexPath) -> Any?)?
    /// 返回 UISwipeActionsConfiguration?（iOS 11+），用 Any 擦除以兼容更低部署版本
    open var trailingSwipeActions: ((_ indexPath: IndexPath) -> Any?)?
    /// 返回 UIContextMenuConfiguration?（iOS 13+），用 Any 擦除以兼容更低部署版本
    open var contextMenuConfiguration: ((_ indexPath: IndexPath, _ point: CGPoint) -> Any?)?
    /// configuration / animator 为 iOS 13+ 类型，用 Any 擦除
    open var willPerformPreviewAction: ((_ configuration: Any, _ animator: Any) -> Void)?
    
    open var cellEstimatedHeights: [String: CGFloat] = [:]
    open var headEstimatedHeights: [String: CGFloat] = [:]
    open var footEstimatedHeights: [String: CGFloat] = [:]
    
    open override func responds(to aSelector: Selector!) -> Bool {
        if #available(iOS 11.0, *) {
            if aSelector == #selector(tableView(_:leadingSwipeActionsConfigurationForRowAt:)) {
                return leadingSwipeActions != nil
            }
            if aSelector == #selector(tableView(_:trailingSwipeActionsConfigurationForRowAt:)) {
                return trailingSwipeActions != nil
            }
        }
        if #available(iOS 13.0, *) {
            if aSelector == #selector(tableView(_:contextMenuConfigurationForRowAt:point:)) {
                return contextMenuConfiguration != nil
            }
            if aSelector == #selector(tableView(_:willPerformPreviewActionForMenuWith:animator:)) {
                return willPerformPreviewAction != nil
            }
        }
        return super.responds(to: aSelector)
    }
}

extension QTableViewHelper: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return numberofSections?() ?? 1
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberofRows?(section) ?? 0
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cell?(tableView, indexPath) ?? .init(style: .default, reuseIdentifier: "quicklydefault")
    }
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return titleForHeader?(section)
    }
    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return titleForFooter?(section)
    }
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return canEdit?(indexPath) ?? false
    }
    public func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return canMove?(indexPath) ?? false
    }
    public func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sectionIndexTitles?()
    }
    public func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return sectionForSectionIndexTitle?(title, index) ?? index
    }
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        commitEditingStyle?(editingStyle, indexPath)
    }
    public func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        moveAction?(sourceIndexPath, destinationIndexPath)
    }
}
extension QTableViewHelper: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return heightForHeader?(section) ?? 0.0001
    }
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return heightForFooter?(section) ?? 0.0001
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightForRow?(indexPath) ?? UITableView.automaticDimension
    }
    public func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        if let height = estimatedheightForHeader?(section) {
            return height
        }
        if let height = self.headEstimatedHeights["\(section)"] {
            return height
        }
        return tableView.estimatedSectionHeaderHeight
    }
    public func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        if let height = estimatedheightForFooter?(section) {
            return height
        }
        if let height = self.footEstimatedHeights["\(section)"] {
            return height
        }
        return tableView.estimatedSectionFooterHeight
    }
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if let height = estimatedheightForRow?(indexPath) {
            return height
        }
        if let height = self.cellEstimatedHeights["\(indexPath.section)_\(indexPath.row)"] {
            return height
        }
        return tableView.estimatedRowHeight
    }
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let viewForHeader = viewForHeader {
            return viewForHeader(tableView, section)
        }
        return .init() // 返回view，主要是在.plain下，去掉分割线
    }
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if let viewForFooter = viewForFooter {
            return viewForFooter(tableView, section)
        }
        return .init() // 返回view，主要是在.plain下，去掉分割线
    }
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        willDisplayCell?(cell, indexPath)
        self.cellEstimatedHeights["\(indexPath.section)_\(indexPath.row)"] = cell.frame.height
    }
    public func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        willDisplayHeader?(view, section)
        self.headEstimatedHeights["\(section)"] = view.frame.height
    }
    public func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        willDisplayFooter?(view, section)
        self.footEstimatedHeights["\(section)"] = view.frame.height
    }
    public func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        didEndDisplayHeader?(view, section)
    }
    public func tableView(_ tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) {
        didEndDisplayFooter?(view, section)
    }
    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        didEndDisplayCell?(cell, indexPath)
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectRow?(tableView, indexPath)
    }
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        didDeselectRow?(tableView, indexPath)
    }
    public func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return editActions?(indexPath)
    }
    public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return editingStyleForRow?(indexPath) ?? .none
    }
    public func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if let willSelectRow = willSelectRow {
            return willSelectRow(tableView, indexPath)
        }
        return indexPath
    }
    public func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        if let willDeselectRow = willDeselectRow {
            return willDeselectRow(tableView, indexPath)
        }
        return indexPath
    }
    public func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return shouldHighlightRow?(indexPath) ?? true
    }
    public func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        didHighlightRow?(indexPath)
    }
    public func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        didUnhighlightRow?(indexPath)
    }
    public func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        accessoryButtonTapped?(indexPath)
    }
    public func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        return indentationLevelForRow?(indexPath) ?? 0
    }
    public func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return shouldIndentWhileEditing?(indexPath) ?? true
    }
    public func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        willBeginEditingRow?(indexPath)
    }
    public func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        didEndEditingRow?(indexPath)
    }
    public func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        return targetIndexPathForMove?(sourceIndexPath, proposedDestinationIndexPath) ?? proposedDestinationIndexPath
    }
    public func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return titleForDeleteConfirmationButton?(indexPath)
    }
    @available(iOS 11.0, *)
    public func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return leadingSwipeActions?(indexPath) as? UISwipeActionsConfiguration
    }
    @available(iOS 11.0, *)
    public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return trailingSwipeActions?(indexPath) as? UISwipeActionsConfiguration
    }
    @available(iOS 13.0, *)
    public func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return contextMenuConfiguration?(indexPath, point) as? UIContextMenuConfiguration
    }
    @available(iOS 13.0, *)
    public func tableView(_ tableView: UITableView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        willPerformPreviewAction?(configuration, animator)
    }
}
