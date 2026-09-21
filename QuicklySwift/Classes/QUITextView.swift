//
//  QuicklyTextView.swift
//  QuicklySwift
//
//  Created by rztime on 2022/6/1.
//

import UIKit
import SnapKit

public extension UITextView {
    @discardableResult
    func qdelegate(_ delegate: UITextViewDelegate?) -> Self {
        self.delegate = delegate
        return self
    }
    @discardableResult
    func qtext(_ text: String)-> Self {
        self.text = text
        return self
    }
    @discardableResult
    func qfont(_ font: UIFont) -> Self {
        self.font = font
        return self
    }
    @discardableResult
    func qtextColor(_ color: UIColor?) -> Self {
        self.textColor = color
        return self
    }
    @discardableResult
    func qtextAliginment(_ align: NSTextAlignment) -> Self {
        self.textAlignment = align
        return self
    }
    @discardableResult
    func qselectedRange(range: NSRange) -> Self {
        self.selectedRange = range
        return self
    }
    @discardableResult
    func qisEditable(_ editable: Bool) -> Self {
        self.isEditable = editable
        return self
    }
    @discardableResult
    func qattributedText(_ text: NSAttributedString?) -> Self {
        self.attributedText = text
        return self
    }
    @discardableResult
    func qlinkTextAttributes(_ attr: [NSAttributedString.Key: Any]) -> Self {
        self.linkTextAttributes = attr
        return self
    }
    /// 给文字设置渐变色
    /// - Parameters:
    ///   - gradinent: 渐变色
    ///   - locations: 位置
    ///   - start: 起点
    ///   - end: 终点
    ///   - size: 渐变区域
    @discardableResult
    func qtextColor(gradinent: [UIColor], locations: [NSNumber], start: CGPoint, end: CGPoint, size: CGSize) -> Self {
        let image = UIImage.qimageBy(gradinentColors: gradinent, locations: locations, start: start, end: end, size: size)
        self.textColor = UIColor.init(patternImage: image)
        return self
    }
}
// MARK: - maxCount  maxLength 的区别，
// maxCount：表情长度 = 1     如“中文你好👰” count = 5
// maxLength： 表情长度 = 2（也有超过2的） 如“中文你好👰” lengt = 6
public extension UITextView {
    ///最多输入字数。区别在于表情只算1个长度
    @discardableResult
    func qmaxCount(_ count: Int) -> Self {
        self.qtextViewHelper.maxCount = count
        return self
    }
    /// 最多输入字数。区别在于一个表情长度=2（也有大于2）
    @discardableResult
    func qmaxLength(_ length: Int) -> Self {
        self.qtextViewHelper.maxLength = length
        return self
    }
    /// 无内容时，站位字符串
    @discardableResult
    func qplaceholder(_ text: String?) -> Self {
        self.qtextViewHelper.placeHolder = text
        return self
    }
    /// 无内容时，站位字符串
    @discardableResult
    func qattributedPlaceholder(_ text: NSAttributedString?) -> Self {
        self.qtextViewHelper.attributedPlaceholder = text
        return self
    }
    /// 输入中文，且输入拼音未完成 return true
    func qisZhInput() -> Bool {
        if self.isFirstResponder,
            let language = UIApplication.shared.textInputMode?.primaryLanguage,
            language.hasPrefix("zh-Han") {
            let position = self.position(from: (self.markedTextRange ?? .init()).start, offset: 0)
            if position != nil {
                return true
            }
        }
        return false
    }
}
// MARK: - textview delegate 的quickly方法
public extension UITextView {
    @discardableResult
    func qshouldBeginEditing(_ begin: ((_ textView: UITextView) -> Bool)?) -> Self {
        self.qtextViewHelper.shouldBeginEditing = begin
        return self
    }
    @discardableResult
    func qshouldEndEditing(_ end: ((_ textView: UITextView) -> Bool)?) -> Self {
        self.qtextViewHelper.shouldEndEditing = end
        return self
    }
    @discardableResult
    func qdidBeginEditing(_ begin: ((_ textView: UITextView) -> Void)?) -> Self {
        self.qtextViewHelper.didBeginEditing = begin
        return self
    }
    @discardableResult
    func qdidEndEditing(_ end: ((_ textView: UITextView) -> Void)?) -> Self {
        self.qtextViewHelper.didEndEditing = end
        return self
    }
    @discardableResult
    func qshouldChangeText(_ changed: ((_ textView: UITextView, _ range: NSRange, _ replaceText: String) -> Bool)?) -> Self {
        self.qtextViewHelper.shouldChangeText = changed
        return self
    }
    /// 文字改变的回调
    @discardableResult
    func qtextChanged(_ changed: ((_ textView: UITextView) -> Void)?) -> Self {
        self.qtextViewHelper.didChanged = changed
        return self
    }
    /// 改变光标位置的回调
    @discardableResult
    func qdidChangeSelection(_ changed: ((_ textView: UITextView) -> Void)?) -> Self {
        self.qtextViewHelper.didChangeSelection = changed
        return self
    }
    @discardableResult
    func shouldInteractWithURL(_ should: ((_ textView: UITextView, _ url: URL, _ range: NSRange, _ interaction: Int) -> Bool)?) -> Self {
        self.qtextViewHelper.shouldInteractWithURL = should
        return self
    }
    @discardableResult
    func qshouldInteractWithAttachment(_ should: ((_ textView: UITextView, _ textAttachment: NSTextAttachment, _ range: NSRange, _ interaction: Int) -> Bool)?) -> Self {
        self.qtextViewHelper.shouldInteractWithAttachment = should
        return self
    }
    /// 多段选区同时替换时是否允许（iOS 26+）。设置后系统不再回调 qshouldChangeText
    @discardableResult
    @available(iOS 26.0, *)
    func qshouldChangeTextInRanges(
        _ changed: ((_ textView: UITextView, _ ranges: [NSValue], _ replaceText: String) -> Bool)?
    ) -> Self {
        self.qtextViewHelper.shouldChangeTextInRanges = changed
        return self
    }
    /// 自定义编辑菜单（iOS 16+）。返回 nil 使用系统菜单
    @discardableResult
    @available(iOS 16.0, *)
    func qeditMenuForText(
        _ menu: ((_ textView: UITextView, _ range: NSRange, _ suggestedActions: [UIMenuElement]) -> UIMenu?)?
    ) -> Self {
        if let menu = menu {
            self.qtextViewHelper.editMenuForText = { textView, range, actions in
                let suggested = actions.compactMap { $0 as? UIMenuElement }
                return menu(textView, range, suggested)
            }
        } else {
            self.qtextViewHelper.editMenuForText = nil
        }
        return self
    }
    /// 多段选区的编辑菜单（iOS 26+）。设置后系统不再回调 qeditMenuForText
    @discardableResult
    @available(iOS 26.0, *)
    func qeditMenuForTextInRanges(
        _ menu: ((_ textView: UITextView, _ ranges: [NSValue], _ suggestedActions: [UIMenuElement]) -> UIMenu?)?
    ) -> Self {
        if let menu = menu {
            self.qtextViewHelper.editMenuForTextInRanges = { textView, ranges, actions in
                let suggested = actions.compactMap { $0 as? UIMenuElement }
                return menu(textView, ranges, suggested)
            }
        } else {
            self.qtextViewHelper.editMenuForTextInRanges = nil
        }
        return self
    }
    /// 编辑菜单即将出现（iOS 16+）
    @discardableResult
    @available(iOS 16.0, *)
    func qwillPresentEditMenu(
        _ present: ((_ textView: UITextView, _ animator: any UIEditMenuInteractionAnimating) -> Void)?
    ) -> Self {
        if let present = present {
            self.qtextViewHelper.willPresentEditMenu = { textView, animator in
                guard let animator = animator as? any UIEditMenuInteractionAnimating else { return }
                present(textView, animator)
            }
        } else {
            self.qtextViewHelper.willPresentEditMenu = nil
        }
        return self
    }
    /// 编辑菜单即将消失（iOS 16+）
    @discardableResult
    @available(iOS 16.0, *)
    func qwillDismissEditMenu(
        _ dismiss: ((_ textView: UITextView, _ animator: any UIEditMenuInteractionAnimating) -> Void)?
    ) -> Self {
        if let dismiss = dismiss {
            self.qtextViewHelper.willDismissEditMenu = { textView, animator in
                guard let animator = animator as? any UIEditMenuInteractionAnimating else { return }
                dismiss(textView, animator)
            }
        } else {
            self.qtextViewHelper.willDismissEditMenu = nil
        }
        return self
    }
    /// 点击链接、附件或自定义 tag 的主动作（iOS 17+）。返回 nil 不执行。
    /// 未设置时不拦截，已有 shouldInteractWithURL / qshouldInteractWithAttachment 仍生效
    @discardableResult
    @available(iOS 17.0, *)
    func qprimaryActionForTextItem(
        _ action: ((_ textView: UITextView, _ textItem: UITextItem, _ defaultAction: UIAction) -> UIAction?)?
    ) -> Self {
        if let action = action {
            self.qtextViewHelper.primaryActionForTextItem = { textView, textItem, defaultAction in
                guard let textItem = textItem as? UITextItem, let defaultAction = defaultAction as? UIAction else {
                    return defaultAction
                }
                return action(textView, textItem, defaultAction)
            }
        } else {
            self.qtextViewHelper.primaryActionForTextItem = nil
        }
        return self
    }
    /// 文本项菜单配置（iOS 17+）。返回 nil 不展示菜单。未设置时走系统默认
    @discardableResult
    @available(iOS 17.0, *)
    func qmenuConfigurationForTextItem(
        _ config: (
            (_ textView: UITextView, _ textItem: UITextItem, _ defaultMenu: UIMenu) -> UITextItem.MenuConfiguration?
        )?
    ) -> Self {
        if let config = config {
            self.qtextViewHelper.menuConfigurationForTextItem = { textView, textItem, defaultMenu in
                guard let textItem = textItem as? UITextItem, let defaultMenu = defaultMenu as? UIMenu else {
                    return defaultMenu
                }
                return config(textView, textItem, defaultMenu)
            }
        } else {
            self.qtextViewHelper.menuConfigurationForTextItem = nil
        }
        return self
    }
    /// 文本项菜单即将显示（iOS 17+）
    @discardableResult
    @available(iOS 17.0, *)
    func qtextItemMenuWillDisplay(
        _ display: (
            (_ textView: UITextView, _ textItem: UITextItem, _ animator: any UIContextMenuInteractionAnimating) -> Void
        )?
    ) -> Self {
        if let display = display {
            self.qtextViewHelper.textItemMenuWillDisplay = { textView, textItem, animator in
                guard let textItem = textItem as? UITextItem,
                      let animator = animator as? any UIContextMenuInteractionAnimating else { return }
                display(textView, textItem, animator)
            }
        } else {
            self.qtextViewHelper.textItemMenuWillDisplay = nil
        }
        return self
    }
    /// 文本项菜单即将结束（iOS 17+）
    @discardableResult
    @available(iOS 17.0, *)
    func qtextItemMenuWillEnd(
        _ end: (
            (_ textView: UITextView, _ textItem: UITextItem, _ animator: any UIContextMenuInteractionAnimating) -> Void
        )?
    ) -> Self {
        if let end = end {
            self.qtextViewHelper.textItemMenuWillEnd = { textView, textItem, animator in
                guard let textItem = textItem as? UITextItem,
                      let animator = animator as? any UIContextMenuInteractionAnimating else { return }
                end(textView, textItem, animator)
            }
        } else {
            self.qtextViewHelper.textItemMenuWillEnd = nil
        }
        return self
    }
    /// Writing Tools 开始改写（iOS 18+）
    @discardableResult
    @available(iOS 18.0, *)
    func qwritingToolsWillBegin(_ begin: ((_ textView: UITextView) -> Void)?) -> Self {
        self.qtextViewHelper.writingToolsWillBegin = begin
        return self
    }
    /// Writing Tools 结束改写（iOS 18+）
    @discardableResult
    @available(iOS 18.0, *)
    func qwritingToolsDidEnd(_ end: ((_ textView: UITextView) -> Void)?) -> Self {
        self.qtextViewHelper.writingToolsDidEnd = end
        return self
    }
    /// Writing Tools 需要忽略的文本范围（iOS 18+）。未设置时不拦截系统默认
    @discardableResult
    @available(iOS 18.0, *)
    func qwritingToolsIgnoredRanges(
        _ ranges: ((_ textView: UITextView, _ enclosingRange: NSRange) -> [NSValue])?
    ) -> Self {
        self.qtextViewHelper.writingToolsIgnoredRanges = ranges
        return self
    }
    /// 文本格式面板即将出现（iOS 18+）
    @discardableResult
    @available(iOS 18.0, *)
    func qwillBeginFormatting(
        _ begin: ((_ textView: UITextView, _ viewController: UITextFormattingViewController) -> Void)?
    ) -> Self {
        self.qtextViewHelper.willBeginFormatting = Self.qformattingHandler(begin)
        return self
    }
    /// 文本格式面板已出现（iOS 18+）
    @discardableResult
    @available(iOS 18.0, *)
    func qdidBeginFormatting(
        _ begin: ((_ textView: UITextView, _ viewController: UITextFormattingViewController) -> Void)?
    ) -> Self {
        self.qtextViewHelper.didBeginFormatting = Self.qformattingHandler(begin)
        return self
    }
    /// 文本格式面板即将关闭（iOS 18+）
    @discardableResult
    @available(iOS 18.0, *)
    func qwillEndFormatting(
        _ end: ((_ textView: UITextView, _ viewController: UITextFormattingViewController) -> Void)?
    ) -> Self {
        self.qtextViewHelper.willEndFormatting = Self.qformattingHandler(end)
        return self
    }
    /// 文本格式面板已关闭（iOS 18+）
    @discardableResult
    @available(iOS 18.0, *)
    func qdidEndFormatting(
        _ end: ((_ textView: UITextView, _ viewController: UITextFormattingViewController) -> Void)?
    ) -> Self {
        self.qtextViewHelper.didEndFormatting = Self.qformattingHandler(end)
        return self
    }
    /// 键盘交付输入建议时回调（iOS 18.4+）。未设置时不拦截系统插入
    @discardableResult
    @available(iOS 18.4, *)
    func qinsertInputSuggestion(
        _ insert: ((_ textView: UITextView, _ inputSuggestion: UIInputSuggestion) -> Void)?
    ) -> Self {
        if let insert = insert {
            self.qtextViewHelper.insertInputSuggestion = { textView, inputSuggestion in
                guard let inputSuggestion = inputSuggestion as? UIInputSuggestion else { return }
                insert(textView, inputSuggestion)
            }
        } else {
            self.qtextViewHelper.insertInputSuggestion = nil
        }
        return self
    }
    /// 获取range所在区域第一排的位置
    func qfistRect(for range: NSRange) -> CGRect {
        let beginning = self.beginningOfDocument
        guard let star = self.position(from: beginning, offset: range.location),
              let end = self.position(from: star, offset: range.length),
              let textRange = self.textRange(from: star, to: end) else { return .zero }
        return self.firstRect(for: textRange)
    }
    /// 获取index所在区域的位置,
    func qcaretRect(for index: Int) -> CGRect {
        let beginning = self.beginningOfDocument
        guard let star = self.position(from: beginning, offset: index) else { return .zero }
        return self.caretRect(for: star)
    }
    /// 获取range所在区域所有排的位置
    func qsectionRects(for range: NSRange) -> [CGRect] {
        let beginning = self.beginningOfDocument
        guard let star = self.position(from: beginning, offset: range.location),
              let end = self.position(from: star, offset: range.length),
              let textRange = self.textRange(from: star, to: end) else { return [] }
        let res = self.selectionRects(for: textRange)
        return res.map { $0.rect }
    }
    /// 把 iOS 18 格式面板回调收成 Any，供 QTextViewHelper 存储
    @available(iOS 18.0, *)
    private static func qformattingHandler(
        _ handler: ((_ textView: UITextView, _ viewController: UITextFormattingViewController) -> Void)?
    ) -> ((_ textView: UITextView, _ viewController: Any) -> Void)? {
        guard let handler = handler else { return nil }
        return { textView, viewController in
            guard let viewController = viewController as? UITextFormattingViewController else { return }
            handler(textView, viewController)
        }
    }
}
 
open class QTextViewHelper: QScrollViewHelper {
    open var shouldBeginEditing: ((_ textView: UITextView) -> Bool)?
    open var shouldEndEditing: ((_ textView: UITextView) -> Bool)?
    open var didBeginEditing: ((_ textView: UITextView) -> Void)?
    open var didEndEditing: ((_ textView: UITextView) -> Void)?
    open var shouldChangeText: ((_ textView: UITextView, _ range: NSRange, _ replaceText: String) -> Bool)?
    open var didChanged: ((_ textView: UITextView) -> Void)?
    open var didChangeSelection: ((_ textView: UITextView) -> Void)?
    
    open var shouldInteractWithAttachment: ((_ textView: UITextView, _ textAttachment: NSTextAttachment, _ range: NSRange, _ interaction: Int) -> Bool)?
    open var shouldInteractWithURL: ((_ textView: UITextView, _ url: URL, _ range: NSRange, _ interaction: Int) -> Bool)?
    /// 新系统类型用 Any 擦除，避免 iOS 12 部署目标无法存放 @available 存储属性
    open var shouldChangeTextInRanges: ((_ textView: UITextView, _ ranges: [NSValue], _ replaceText: String) -> Bool)?
    open var editMenuForText: ((_ textView: UITextView, _ range: NSRange, _ suggestedActions: [Any]) -> Any?)?
    open var editMenuForTextInRanges: (
        (_ textView: UITextView, _ ranges: [NSValue], _ suggestedActions: [Any]) -> Any?
    )?
    open var willPresentEditMenu: ((_ textView: UITextView, _ animator: Any) -> Void)?
    open var willDismissEditMenu: ((_ textView: UITextView, _ animator: Any) -> Void)?
    open var primaryActionForTextItem: ((_ textView: UITextView, _ textItem: Any, _ defaultAction: Any) -> Any?)?
    open var menuConfigurationForTextItem: ((_ textView: UITextView, _ textItem: Any, _ defaultMenu: Any) -> Any?)?
    open var textItemMenuWillDisplay: ((_ textView: UITextView, _ textItem: Any, _ animator: Any) -> Void)?
    open var textItemMenuWillEnd: ((_ textView: UITextView, _ textItem: Any, _ animator: Any) -> Void)?
    open var writingToolsWillBegin: ((_ textView: UITextView) -> Void)?
    open var writingToolsDidEnd: ((_ textView: UITextView) -> Void)?
    open var writingToolsIgnoredRanges: ((_ textView: UITextView, _ enclosingRange: NSRange) -> [NSValue])?
    open var willBeginFormatting: ((_ textView: UITextView, _ viewController: Any) -> Void)?
    open var didBeginFormatting: ((_ textView: UITextView, _ viewController: Any) -> Void)?
    open var willEndFormatting: ((_ textView: UITextView, _ viewController: Any) -> Void)?
    open var didEndFormatting: ((_ textView: UITextView, _ viewController: Any) -> Void)?
    open var insertInputSuggestion: ((_ textView: UITextView, _ inputSuggestion: Any) -> Void)?
    
    /*
    // MARK: - maxCount  maxLength 的区别，
    // maxCount：表情长度 = 1     如“中文你好👰” count = 5
    // maxLength： 表情长度 = 2（也有超过2的） 如“中文你好👰” lengt = 6
    */
    
    /// 最多输入个数
    open var maxLength = 0
    /// 最多输入个数
    open var maxCount = 0
    
    /// 占位字符串, 直接使用无效，需调用setUpPlaceHolderLabel()
    open var placeHolderLabel: UILabel?
    /// 占位字符串
    open var placeHolder: String? {
        didSet {
            setUpPlaceHolderLabel()
            self.placeHolderLabel?.text = placeHolder
        }
    }
    /// 占位字符串
    open var attributedPlaceholder: NSAttributedString? {
        didSet {
            setUpPlaceHolderLabel()
            self.placeHolderLabel?.attributedText = attributedPlaceholder
        }
    }
    /// 会改变默认行为的可选方法，仅在设置回调时响应，避免盖掉旧回调或系统默认
    open override func responds(to aSelector: Selector!) -> Bool {
        if #available(iOS 26.0, *) {
            if aSelector == #selector(textView(_:shouldChangeTextInRanges:replacementText:)) {
                return shouldChangeTextInRanges != nil
            }
            if aSelector == #selector(textView(_:editMenuForTextInRanges:suggestedActions:)) {
                return editMenuForTextInRanges != nil
            }
        }
        if #available(iOS 17.0, *) {
            if aSelector == #selector(textView(_:primaryActionFor:defaultAction:)) {
                return primaryActionForTextItem != nil
            }
            if aSelector == #selector(textView(_:menuConfigurationFor:defaultMenu:)) {
                return menuConfigurationForTextItem != nil
            }
        }
        if #available(iOS 18.0, *) {
            if aSelector == #selector(textView(_:writingToolsIgnoredRangesInEnclosingRange:)) {
                return writingToolsIgnoredRanges != nil
            }
        }
        if #available(iOS 18.4, *) {
            if aSelector == #selector(textView(_:insertInputSuggestion:)) {
                return insertInputSuggestion != nil
            }
        }
        return super.responds(to: aSelector)
    }
}

extension QTextViewHelper: UITextViewDelegate {
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return shouldBeginEditing?(textView) ?? true
    }
    public func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return shouldEndEditing?(textView) ?? true
    }
    public func textViewDidBeginEditing(_ textView: UITextView) {
        didBeginEditing?(textView)
    }
    public func textViewDidEndEditing(_ textView: UITextView) {
        didEndEditing?(textView)
    }
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return shouldChangeText?(textView, range, text) ?? true
    }
    public func textViewDidChange(_ textView: UITextView) {
        defer {
            didChanged?(textView)
            if let label = self.placeHolderLabel {
                label.isHidden = !textView.text.isEmpty
            }
        }
        guard (self.maxCount > 0 || self.maxLength > 0) else { return }
        /// 中文输入时，先不处理
        if textView.qisZhInput() {
            return
        }
        var newText = textView.attributedText ?? .init()
        var selectedRange = textView.selectedRange
        if self.maxCount > 0, newText.string.count > self.maxCount {
            newText = newText.qsubstring(emoji: .count, to: self.maxCount)
        } else if self.maxLength > 0, newText.string.qasNSString.length > self.maxLength {
            newText = newText.qsubstring(emoji: .length, to: self.maxLength)
        } else {
            return
        }
        textView.attributedText = newText
        if selectedRange.location > newText.length {
            selectedRange.location = newText.length
        }
        if selectedRange.location + selectedRange.length > newText.length {
            selectedRange.length = 0
        }
        DispatchQueue.main.async {
            if textView.text.count >= selectedRange.upperBound {
                textView.selectedRange = selectedRange
            }
        }
    }
    public func textViewDidChangeSelection(_ textView: UITextView) {
        didChangeSelection?(textView)
    }
    @available(iOS 10.0, *)
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return shouldInteractWithURL?(textView, URL, characterRange, interaction.rawValue) ?? true
    }
    @available(iOS 10.0, *)
    public func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return shouldInteractWithAttachment?(textView, textAttachment, characterRange, interaction.rawValue) ?? true
    }
    @available(iOS, introduced: 7.0, deprecated: 10.0)
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        return shouldInteractWithURL?(textView, URL, characterRange, 0) ?? true
    }
    @available(iOS, introduced: 7.0, deprecated: 10.0)
    public func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange) -> Bool {
        return shouldInteractWithAttachment?(textView, textAttachment, characterRange, 0) ?? true
    }
    @available(iOS 26.0, *)
    public func textView(
        _ textView: UITextView,
        shouldChangeTextInRanges ranges: [NSValue],
        replacementText text: String
    ) -> Bool {
        return shouldChangeTextInRanges?(textView, ranges, text) ?? true
    }
    @available(iOS 16.0, *)
    public func textView(
        _ textView: UITextView,
        editMenuForTextIn range: NSRange,
        suggestedActions: [UIMenuElement]
    ) -> UIMenu? {
        guard let editMenuForText = editMenuForText else { return nil }
        return editMenuForText(textView, range, suggestedActions) as? UIMenu
    }
    @available(iOS 26.0, *)
    public func textView(
        _ textView: UITextView,
        editMenuForTextInRanges ranges: [NSValue],
        suggestedActions: [UIMenuElement]
    ) -> UIMenu? {
        guard let editMenuForTextInRanges = editMenuForTextInRanges else { return nil }
        return editMenuForTextInRanges(textView, ranges, suggestedActions) as? UIMenu
    }
    @available(iOS 16.0, *)
    public func textView(
        _ textView: UITextView,
        willPresentEditMenuWith animator: any UIEditMenuInteractionAnimating
    ) {
        willPresentEditMenu?(textView, animator)
    }
    @available(iOS 16.0, *)
    public func textView(
        _ textView: UITextView,
        willDismissEditMenuWith animator: any UIEditMenuInteractionAnimating
    ) {
        willDismissEditMenu?(textView, animator)
    }
    @available(iOS 17.0, *)
    public func textView(
        _ textView: UITextView,
        primaryActionFor textItem: UITextItem,
        defaultAction: UIAction
    ) -> UIAction? {
        guard let primaryActionForTextItem = primaryActionForTextItem else { return defaultAction }
        return primaryActionForTextItem(textView, textItem, defaultAction) as? UIAction
    }
    @available(iOS 17.0, *)
    public func textView(
        _ textView: UITextView,
        menuConfigurationFor textItem: UITextItem,
        defaultMenu: UIMenu
    ) -> UITextItem.MenuConfiguration? {
        guard let menuConfigurationForTextItem = menuConfigurationForTextItem else {
            return UITextItem.MenuConfiguration(menu: defaultMenu)
        }
        return menuConfigurationForTextItem(textView, textItem, defaultMenu) as? UITextItem.MenuConfiguration
    }
    @available(iOS 17.0, *)
    public func textView(
        _ textView: UITextView,
        textItemMenuWillDisplayFor textItem: UITextItem,
        animator: any UIContextMenuInteractionAnimating
    ) {
        textItemMenuWillDisplay?(textView, textItem, animator)
    }
    @available(iOS 17.0, *)
    public func textView(
        _ textView: UITextView,
        textItemMenuWillEndFor textItem: UITextItem,
        animator: any UIContextMenuInteractionAnimating
    ) {
        textItemMenuWillEnd?(textView, textItem, animator)
    }
    @available(iOS 18.0, *)
    public func textViewWritingToolsWillBegin(_ textView: UITextView) {
        writingToolsWillBegin?(textView)
    }
    @available(iOS 18.0, *)
    public func textViewWritingToolsDidEnd(_ textView: UITextView) {
        writingToolsDidEnd?(textView)
    }
    @available(iOS 18.0, *)
    public func textView(
        _ textView: UITextView,
        writingToolsIgnoredRangesInEnclosingRange enclosingRange: NSRange
    ) -> [NSValue] {
        return writingToolsIgnoredRanges?(textView, enclosingRange) ?? []
    }
    @available(iOS 18.0, *)
    public func textView(
        _ textView: UITextView,
        willBeginFormattingWith viewController: UITextFormattingViewController
    ) {
        willBeginFormatting?(textView, viewController)
    }
    @available(iOS 18.0, *)
    public func textView(
        _ textView: UITextView,
        didBeginFormattingWith viewController: UITextFormattingViewController
    ) {
        didBeginFormatting?(textView, viewController)
    }
    @available(iOS 18.0, *)
    public func textView(
        _ textView: UITextView,
        willEndFormattingWith viewController: UITextFormattingViewController
    ) {
        willEndFormatting?(textView, viewController)
    }
    @available(iOS 18.0, *)
    public func textView(
        _ textView: UITextView,
        didEndFormattingWith viewController: UITextFormattingViewController
    ) {
        didEndFormatting?(textView, viewController)
    }
    @available(iOS 18.4, *)
    public func textView(_ textView: UITextView, insertInputSuggestion inputSuggestion: UIInputSuggestion) {
        insertInputSuggestion?(textView, inputSuggestion)
    }
}
public extension QTextViewHelper {
    /// 设置占位符label
    func setUpPlaceHolderLabel() {
        if let _ = self.placeHolderLabel {
            return
        }
        let label = UILabel.init().qnumberOfLines(0).qisUserInteractionEnabled(false)
        self.placeHolderLabel = label
        self.target?.addSubview(label)
        self.target?.qsizeChanged({ [weak self] view in
            if let textView = view as? UITextView {
                if self?.attributedPlaceholder == nil {
                    self?.placeHolderLabel?.font = textView.font ?? .systemFont(ofSize: 11)
                    self?.placeHolderLabel?.textColor = UIColor.lightGray
                }
                let rect = textView.qcaretRect(for: 0)
                self?.placeHolderLabel?.snp.remakeConstraints({ make in
                    make.left.equalToSuperview().inset(textView.contentInset.left + 4)
                    make.top.equalToSuperview().inset(rect.origin.y)
                    let w = textView.frame.size.width - textView.contentInset.left - textView.contentInset.right - 4
                    make.width.equalTo(w)
                })
            }
        })
    }
}
