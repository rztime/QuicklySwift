//
//  QuicklyTableView.swift
//  QuicklySwift
//
//  Created by rztime on 2022/6/2.
//

import UIKit

public extension UITableView {
    @discardableResult
    func qdataSource(_ dataSource: UITableViewDataSource?) -> Self {
        self.dataSource = dataSource
        return self
    }
    @discardableResult
    func qdelegate(_ delegate: UITableViewDelegate?) -> Self {
        self.delegate = delegate
        return self
    }
    @discardableResult
    func qtableHeaderView(_ view: UIView?) -> Self {
        self.tableHeaderView = view
        return self
    }
    @discardableResult
    func qtableFooterView(_ view: UIView?) -> Self {
        self.tableFooterView = view
        return self
    }
    @discardableResult
    func qrowHeight(_ rowHeight: CGFloat) -> Self {
        self.rowHeight = rowHeight
        return self
    }
    @discardableResult
    func qsectionHeaderHeight(_ height: CGFloat) -> Self {
        self.sectionHeaderHeight = height
        return self
    }
    @discardableResult
    func qsectionFooterHeight(_ height: CGFloat) -> Self {
        self.sectionFooterHeight = height
        return self
    }
    @discardableResult
    func qestimatedRowHeight(_ height: CGFloat) -> Self {
        self.estimatedRowHeight = height
        return self
    }
    @discardableResult
    func qestimatedSectionHeaderHeight(_ height: CGFloat) -> Self {
        self.estimatedSectionHeaderHeight = height
        return self
    }
    @discardableResult
    func qestimatedSectionFooterHeight(_ height: CGFloat) -> Self {
        self.estimatedSectionFooterHeight = height
        return self
    }
    @discardableResult
    func qseparatorInset(_ inset: UIEdgeInsets) -> Self {
        self.separatorInset = inset
        return self
    }
    @discardableResult
    func qseparatorStyle(_ style: UITableViewCell.SeparatorStyle) -> Self {
        self.separatorStyle = style
        return self
    }
    @discardableResult
    func qseparatorColor(_ color: UIColor?) -> Self {
        self.separatorColor = color
        return self
    }
    @discardableResult
    func qseparatorEffect(_ effect: UIVisualEffect?) -> Self {
        self.separatorEffect = effect
        return self
    }
    /// ??????cell
    @discardableResult
    func qregister(_ cell: AnyClass?, identifier: String) -> Self {
        self.register(cell, forCellReuseIdentifier: identifier)
        return self
    }
    @discardableResult
    func qregisterForHeaderFooter(_ view: AnyClass?, identifier: String) -> Self {
        self.register(view, forHeaderFooterViewReuseIdentifier: identifier)
        return self
    }
}
// MARK: - DataSource
public extension UITableView {
    /// ??????section??????
    /// ??????quickly????????? ???????????????QTableViewHelper ??????????????????tableView???delagte ??? DataSource???
    @discardableResult
    func qnumberofSections(_ count: (() -> Int)?) -> Self {
        self.qtableViewHelper.numberofSections = count
        return self
    }
    /// ????????????section??????row
    /// ??????quickly????????? ???????????????QTableViewHelper ??????????????????tableView???delagte ??? DataSource???
    @discardableResult
    func qnumberofRows(_ count: ((_ section: Int) -> Int)?) -> Self {
        self.qtableViewHelper.numberofRows = count
        return self
    }
    /// ??????cell
    /// ??????quickly????????? ???????????????QTableViewHelper ??????????????????tableView???delagte ??? DataSource???
    @discardableResult
    func qcell(_ cell: ((_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell)?) -> Self {
        self.qtableViewHelper.cell = cell
        return self
    }
    /// ??????section title
    @discardableResult
    func qtitleForHeder(_ title: ((_ section: Int) -> String)?) -> Self {
        self.qtableViewHelper.titleForHeader = title
        return self
    }
    /// ??????footer title
    @discardableResult
    func qtitleForFooter(_ title: ((_ section: Int) -> String)?) -> Self {
        self.qtableViewHelper.titleForFooter = title
        return self
    }
    /// ??????????????????
    @discardableResult
    func qcanEdit(_ canEdit: ((_ indexPath: IndexPath) -> Bool)?) -> Self {
        self.qtableViewHelper.canEdit = canEdit
        return self
    }
    /// ??????????????????
    @discardableResult
    func qcanMove(_ canMove: ((_ indexPath: IndexPath) -> Bool)?) -> Self {
        self.qtableViewHelper.canMove = canMove
        return self
    }
    /// sectionindexTitles
    @discardableResult
    func qsectionIndexTitles(_ titles: (() -> [String]?)?) -> Self {
        self.qtableViewHelper.sectionIndexTitles = titles
        return self
    }
    /// ??????item
    @discardableResult
    func qmoveAction(_ move: ((_ indexPath: IndexPath, _ toIndexPath: IndexPath) -> Void)?) -> Self {
        self.qtableViewHelper.moveAction = move
        return self
    }
    /// ??????
    @discardableResult
    func qcommitEditingStyle(_ editStyle: ((_ style: UITableViewCell.EditingStyle, _ indexPath: IndexPath) -> Void)?) -> Self {
        self.qtableViewHelper.commitEditingStyle = editStyle
        return self
    }
}

// MARK: - delegate
public extension UITableView {
    /// cell row ??????
    @discardableResult
    func qheightForRow(_ height: ((_ indexPath: IndexPath) -> CGFloat)?) -> Self {
        self.qtableViewHelper.heightForRow = height
        return self
    }
    /// ??????cell
    @discardableResult
    func qdidSelectRow(_ row: ((_ tableView: UITableView, _ indexPath: IndexPath) -> Void)?) -> Self {
        self.qtableViewHelper.didSelectRow = row
        return self
    }
    /// header ??????
    @discardableResult
    func qheightForHeader(_ height: ((_ section: Int) -> CGFloat)?) -> Self {
        self.qtableViewHelper.heightForHeader = height
        return self
    }
    /// footer ??????
    @discardableResult
    func qheightForFooter(_ height: ((_ section: Int) -> CGFloat)?) -> Self {
        self.qtableViewHelper.heightForFooter = height
        return self
    }
    /// ?????? header ??????
    @discardableResult
    func qestimatedheightForHeader(_ height: ((_ section: Int) -> CGFloat)?) -> Self {
        self.qtableViewHelper.estimatedheightForHeader = height
        return self
    }
    /// ?????? footer ??????
    @discardableResult
    func qestimatedheightForFooter(_ height: ((_ section: Int) -> CGFloat)?) -> Self {
        self.qtableViewHelper.estimatedheightForFooter = height
        return self
    }
    /// ?????? cell row ??????
    @discardableResult
    func qestimatedheightForRow(_ height: ((_ indexPath: IndexPath) -> CGFloat)?) -> Self {
        self.qtableViewHelper.estimatedheightForRow = height
        return self
    }
    /// header view
    @discardableResult
    func qviewForHeader(_ view: ((_ tableView: UITableView, _ section: Int) -> UIView?)?) -> Self {
        self.qtableViewHelper.viewForHeader = view
        return self
    }
    /// footer view
    @discardableResult
    func qviewForFooter(_ view: ((_ tableView: UITableView, _ section: Int) -> UIView?)?) -> Self {
        self.qtableViewHelper.viewForFooter = view
        return self
    }
    /// ????????????cell
    @discardableResult
    func qwillDisplayCell(_ display: ((_ cell: UITableViewCell, _ indexPath: IndexPath) -> Void)?) -> Self {
        self.qtableViewHelper.willDisplayCell = display
        return self
    }
    /// ????????????header
    @discardableResult
    func qwillDisplayHeader(_ display: ((_ view: UIView, _ section: Int) -> Void)?) -> Self {
        self.qtableViewHelper.willDisplayHeader = display
        return self
    }
    /// ????????????header
    @discardableResult
    func qwillDisplayFooter(_ display: ((_ view: UIView, _ section: Int) -> Void)?) -> Self {
        self.qtableViewHelper.willDisplayFooter = display
        return self
    }
    /// ????????????cell
    @discardableResult
    func qdidEndDisplayCell(_ display: ((_ cell: UITableViewCell, _ indexPath: IndexPath) -> Void)?) -> Self {
        self.qtableViewHelper.didEndDisplayCell = display
        return self
    }
    /// ????????????header
    @discardableResult
    func qdidEndDisplayHeader(_ display: ((_ view: UIView, _ section: Int) -> Void)?) -> Self {
        self.qtableViewHelper.didEndDisplayHeader = display
        return self
    }
    /// ????????????header
    @discardableResult
    func qdidEndDisplayFooter(_ display: ((_ view: UIView, _ section: Int) -> Void)?) -> Self {
        self.qtableViewHelper.didEndDisplayFooter = display
        return self
    }
    /// ????????????cell
    @discardableResult
    func qdidDeselectRow(_ row: ((_ tableView: UITableView, _ indexPath: IndexPath) -> Void)?) -> Self {
        self.qtableViewHelper.didDeselectRow = row
        return self
    }
    /// ?????????action
    @discardableResult
    func qeditActions(_ actions: ((_ indexPath: IndexPath) -> [UITableViewRowAction]?)?) -> Self {
        self.qtableViewHelper.editActions = actions
        return self
    }
    /// ??????style
    @discardableResult
    func qeditingStyleForRow(_ style: ((_ indexPath: IndexPath) -> UITableViewCell.EditingStyle)?) -> Self {
        self.qtableViewHelper.editingStyleForRow = style
        return self
    }
}
