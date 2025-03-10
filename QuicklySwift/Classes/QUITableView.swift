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
    /// 注册cell
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
    @discardableResult
    func qsectionHeaderTopPadding(_ padding: CGFloat) -> Self {
        if #available(iOS 15.0, *) {
            self.sectionHeaderTopPadding = padding
        }
        return self
    }
    /// 获取item的数量
    func qitemsCount() -> Int {
        var count = 0
        let sections = self.numberOfSections
        var i = 1
        while i <= sections {
            count += self.numberOfRows(inSection: i - 1)
            i += 1
        }
        return count
    }
}
// MARK: - DataSource
public extension UITableView {
    /// 设置section数量
    /// 使用quickly方法时 内部会设置QTableViewHelper 此时请勿设置tableView的delagte 和 DataSource，
    @discardableResult
    func qnumberofSections(_ count: (() -> Int)?) -> Self {
        self.qtableViewHelper.numberofSections = count
        return self
    }
    /// 设置每个section多少row
    /// 使用quickly方法时 内部会设置QTableViewHelper 此时请勿设置tableView的delagte 和 DataSource，
    @discardableResult
    func qnumberofRows(_ count: ((_ section: Int) -> Int)?) -> Self {
        self.qtableViewHelper.numberofRows = count
        return self
    }
    /// 设置cell
    /// 使用quickly方法时 内部会设置QTableViewHelper 此时请勿设置tableView的delagte 和 DataSource，
    @discardableResult
    func qcell(_ cell: ((_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell)?) -> Self {
        self.qtableViewHelper.cell = cell
        return self
    }
    /// 设置section title
    @discardableResult
    func qtitleForHeder(_ title: ((_ section: Int) -> String)?) -> Self {
        self.qtableViewHelper.titleForHeader = title
        return self
    }
    /// 设置footer title
    @discardableResult
    func qtitleForFooter(_ title: ((_ section: Int) -> String)?) -> Self {
        self.qtableViewHelper.titleForFooter = title
        return self
    }
    /// 是否可以编辑
    @discardableResult
    func qcanEdit(_ canEdit: ((_ indexPath: IndexPath) -> Bool)?) -> Self {
        self.qtableViewHelper.canEdit = canEdit
        return self
    }
    /// 是否可以移动
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
    /// 移动item
    @discardableResult
    func qmoveAction(_ move: ((_ indexPath: IndexPath, _ toIndexPath: IndexPath) -> Void)?) -> Self {
        self.qtableViewHelper.moveAction = move
        return self
    }
    /// 编辑
    @discardableResult
    func qcommitEditingStyle(_ editStyle: ((_ style: UITableViewCell.EditingStyle, _ indexPath: IndexPath) -> Void)?) -> Self {
        self.qtableViewHelper.commitEditingStyle = editStyle
        return self
    }
}

// MARK: - delegate
public extension UITableView {
    /// cell row 高度
    @discardableResult
    func qheightForRow(_ height: ((_ indexPath: IndexPath) -> CGFloat)?) -> Self {
        self.qtableViewHelper.heightForRow = height
        return self
    }
    /// 选中cell
    @discardableResult
    func qdidSelectRow(_ row: ((_ tableView: UITableView, _ indexPath: IndexPath) -> Void)?) -> Self {
        self.qtableViewHelper.didSelectRow = row
        return self
    }
    /// header 高度
    @discardableResult
    func qheightForHeader(_ height: ((_ section: Int) -> CGFloat)?) -> Self {
        self.qtableViewHelper.heightForHeader = height
        return self
    }
    /// footer 高度
    @discardableResult
    func qheightForFooter(_ height: ((_ section: Int) -> CGFloat)?) -> Self {
        self.qtableViewHelper.heightForFooter = height
        return self
    }
    /// 预估 header 高度
    @discardableResult
    func qestimatedheightForHeader(_ height: ((_ section: Int) -> CGFloat)?) -> Self {
        self.qtableViewHelper.estimatedheightForHeader = height
        return self
    }
    /// 预估 footer 高度
    @discardableResult
    func qestimatedheightForFooter(_ height: ((_ section: Int) -> CGFloat)?) -> Self {
        self.qtableViewHelper.estimatedheightForFooter = height
        return self
    }
    /// 预估 cell row 高度
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
    /// 将要显示cell
    @discardableResult
    func qwillDisplayCell(_ display: ((_ cell: UITableViewCell, _ indexPath: IndexPath) -> Void)?) -> Self {
        self.qtableViewHelper.willDisplayCell = display
        return self
    }
    /// 将要显示header
    @discardableResult
    func qwillDisplayHeader(_ display: ((_ view: UIView, _ section: Int) -> Void)?) -> Self {
        self.qtableViewHelper.willDisplayHeader = display
        return self
    }
    /// 将要显示header
    @discardableResult
    func qwillDisplayFooter(_ display: ((_ view: UIView, _ section: Int) -> Void)?) -> Self {
        self.qtableViewHelper.willDisplayFooter = display
        return self
    }
    /// 结束显示cell
    @discardableResult
    func qdidEndDisplayCell(_ display: ((_ cell: UITableViewCell, _ indexPath: IndexPath) -> Void)?) -> Self {
        self.qtableViewHelper.didEndDisplayCell = display
        return self
    }
    /// 结束显示header
    @discardableResult
    func qdidEndDisplayHeader(_ display: ((_ view: UIView, _ section: Int) -> Void)?) -> Self {
        self.qtableViewHelper.didEndDisplayHeader = display
        return self
    }
    /// 结束显示header
    @discardableResult
    func qdidEndDisplayFooter(_ display: ((_ view: UIView, _ section: Int) -> Void)?) -> Self {
        self.qtableViewHelper.didEndDisplayFooter = display
        return self
    }
    /// 取消选中cell
    @discardableResult
    func qdidDeselectRow(_ row: ((_ tableView: UITableView, _ indexPath: IndexPath) -> Void)?) -> Self {
        self.qtableViewHelper.didDeselectRow = row
        return self
    }
    /// 编辑的action
    @discardableResult
    func qeditActions(_ actions: ((_ indexPath: IndexPath) -> [UITableViewRowAction]?)?) -> Self {
        self.qtableViewHelper.editActions = actions
        return self
    }
    /// 编辑style
    @discardableResult
    func qeditingStyleForRow(_ style: ((_ indexPath: IndexPath) -> UITableViewCell.EditingStyle)?) -> Self {
        self.qtableViewHelper.editingStyleForRow = style
        return self
    }
}
