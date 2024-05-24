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

    open var editingStyleForRow: ((_ indexPath: IndexPath) -> UITableViewCell.EditingStyle)?
    open var commitEditingStyle: ((_ style: UITableViewCell.EditingStyle, _ indexPath: IndexPath) -> Void)?
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
        return estimatedheightForHeader?(section) ?? tableView.estimatedSectionHeaderHeight
    }
    public func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return estimatedheightForFooter?(section) ?? tableView.estimatedSectionFooterHeight
    }
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return estimatedheightForRow?(indexPath) ?? tableView.estimatedRowHeight
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
    }
    public func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        willDisplayHeader?(view, section)
    }
    public func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        willDisplayFooter?(view, section)
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
}
