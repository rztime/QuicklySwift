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
}
// MARK: - 对UItableView delegate dataSource设置quickly方法
public extension UITableView {
    /// 注册cell
    @discardableResult
    func qregister(_ cell: AnyClass?, identifier: String) -> Self {
        self.register(cell, forCellReuseIdentifier: identifier)
        return self
    }
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
    /// cell row 高度
    @discardableResult
    func qheightForRow(_ height: ((_ indexPath: IndexPath) -> CGFloat)?) -> Self {
        self.qtableViewHelper.heightForRow = height
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
    /// 选中cell
    @discardableResult
    func qdidSelectRow(_ row: ((_ tableView: UITableView, _ indexPath: IndexPath) -> Void)?) -> Self {
        self.qtableViewHelper.didSelectRow = row
        return self
    }
    /// 取消选中cell
    @discardableResult
    func qdidDeselectRow(_ row: ((_ tableView: UITableView, _ indexPath: IndexPath) -> Void)?) -> Self {
        self.qtableViewHelper.didDeselectRow = row
        return self
    }
    /// 是否可以编辑
    @discardableResult
    func qcanEdit(_ canEdit: ((_ indexPath: IndexPath) -> Bool)?) -> Self {
        self.qtableViewHelper.canEdit = canEdit
        return self
    }
    /// 编辑的action
    @discardableResult
    func qeditActions(_ actions: ((_ indexPath: IndexPath) -> [UITableViewRowAction]?)?) -> Self {
        self.qtableViewHelper.editActions = actions
        return self
    }
    /// 是否可以移动
    @discardableResult
    func qcanMove(_ canMove: ((_ indexPath: IndexPath) -> Bool)?) -> Self {
        self.qtableViewHelper.canMove = canMove
        return self
    }
    /// 移动item
    @discardableResult
    func qmoveAction(_ move: ((_ indexPath: IndexPath, _ toIndexPath: IndexPath) -> Void)?) -> Self {
        self.qtableViewHelper.moveAction = move
        return self
    }
    /// sectionindexTitles
    @discardableResult
    func qsectionIndexTitles(_ titles: (() -> [String]?)?) -> Self {
        self.qtableViewHelper.sectionIndexTitles = titles
        return self
    }
    /// 编辑
    @discardableResult
    func qcommitEditingStyle(_ editStyle: ((_ style: UITableViewCell.EditingStyle, _ indexPath: IndexPath) -> Void)?) -> Self {
        self.qtableViewHelper.commitEditingStyle = editStyle
        return self
    }
    /// 编辑style
    @discardableResult
    func qeditingStyleForRow(_ style: ((_ indexPath: IndexPath) -> UITableViewCell.EditingStyle)?) -> Self {
        self.qtableViewHelper.editingStyleForRow = style
        return self
    }
}

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
        return heightForHeader?(section) ?? 0
    }
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return heightForFooter?(section) ?? 0
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightForRow?(indexPath) ?? UITableView.automaticDimension
    }
    public func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return estimatedheightForHeader?(section) ?? 0
    }
    public func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return estimatedheightForFooter?(section) ?? 0
    }
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return estimatedheightForRow?(indexPath) ?? 44
    }
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return viewForHeader?(tableView, section)
    }
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return viewForFooter?(tableView, section)
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
