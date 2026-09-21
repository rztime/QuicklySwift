//
//  QuicklyTextField.swift
//  QuicklySwift
//
//  Created by rztime on 2022/6/1.
//

import UIKit

public extension UITextField {
    @discardableResult
    func qtext(_ text: String?)-> Self {
        self.text = text
        return self
    }
    @discardableResult
    func qattributedText(_ text: NSAttributedString?) -> Self {
        self.attributedText = text
        return self
    }
    @discardableResult
    func qtextColor(_ color: UIColor?) -> Self {
        self.textColor = color
        return self
    }
    @discardableResult
    func qfont(_ font: UIFont?) -> Self {
        self.font = font
        return self
    }
    @discardableResult
    func qtextAliginment(_ align: NSTextAlignment) -> Self {
        self.textAlignment = align
        return self
    }
    @discardableResult
    func qplaceholder(_ text: String?) -> Self {
        self.placeholder = text
        return self
    }
    @discardableResult
    func qattributedPlaceholder(_ text: NSAttributedString?) -> Self {
        self.attributedPlaceholder = text
        return self
    }
    @discardableResult
    func qclearsOnBeginEditing(_ clear: Bool) -> Self {
        self.clearsOnBeginEditing = clear
        return self
    }
    @discardableResult
    func qadjustsFontSizeToFitWidth(_ value: Bool) -> Self {
        self.adjustsFontSizeToFitWidth = value
        return self
    }
    @discardableResult
    func qminimumFontSize(_ size: CGFloat) -> Self {
        self.minimumFontSize = size
        return self
    }
    @discardableResult
    func qdelegate(_ delegate: UITextFieldDelegate?) -> Self {
        self.delegate = delegate
        return self
    }
    @discardableResult
    func qbackground(_ image: UIImage?) -> Self {
        self.background = image
        return self
    }
    @discardableResult
    func qdisabledBackground(_ image: UIImage?) -> Self {
        self.disabledBackground = image
        return self
    }
    @discardableResult
    func qclearButtonMode(_ mode: UITextField.ViewMode) -> Self {
        self.clearButtonMode = mode
        return self
    }
    @discardableResult
    func qleftView(_ view: UIView, _ mode: UITextField.ViewMode) -> Self {
        self.leftView = view
        self.leftViewMode = mode
        return self
    }
    @discardableResult
    func qrightView(_ view: UIView, _ mode: UITextField.ViewMode) -> Self {
        self.rightView = view
        self.rightViewMode = mode
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
public extension UITextField {
    ///最多输入字数。区别在于表情只算1个长度
    @discardableResult
    func qmaxCount(_ count: Int) -> Self {
        self.qtextFieldHelper.maxCount = count
        return self
    }
    /// 最多输入字数。区别在于一个表情长度=2（也有大于2）
    @discardableResult
    func qmaxLength(_ length: Int) -> Self {
        self.qtextFieldHelper.maxLength = length
        return self
    }
    /// selected Range
    var qselectedRange: NSRange {
        set {
            let beginning = self.beginningOfDocument
            let startPosition = self.position(from: beginning, offset: newValue.location) ?? UITextPosition.init()
            let endPosition = self.position(from: beginning, offset: newValue.location + newValue.length) ?? UITextPosition.init()
            let selectRange = self.textRange(from: startPosition, to: endPosition)
            self.selectedTextRange = selectRange
        }
        get {
            let beginning = self.beginningOfDocument
            let selectedRange = self.selectedTextRange
            let selectionStart = selectedRange?.start ?? UITextPosition.init()
            let selectionEnd = selectedRange?.end  ?? UITextPosition.init()

            let location = self.offset(from: beginning, to: selectionStart)
            let length = self.offset(from: selectionStart, to: selectionEnd)
            return NSRange.init(location: location, length: length)
        }
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
public extension UITextField {
    /// 输入文字改变的回调
    @discardableResult
    func qtextChanged(_ changed: ((_ textField: UITextField) -> Void)?) -> Self {
        self.qtextFieldHelper.didChanged = changed
        return self
    }
    @discardableResult
    func qshouldBeginEditing(_ value: ((_ textField: UITextField) -> Bool)?) -> Self {
        self.qtextFieldHelper.shouldBeginEditing = value
        return self
    }
    @discardableResult
    func qdidBeginEditing(_ value: ((_ textField: UITextField) -> Void)?) -> Self {
        self.qtextFieldHelper.didBeginEditing = value
        return self
    }
    @discardableResult
    func qshouldEndEditing(_ value: ((_ textField: UITextField) -> Bool)?) -> Self {
        self.qtextFieldHelper.shouldEndEditing = value
        return self
    }
    @discardableResult
    func qdidEndEditing(_ value: ((_ textField: UITextField) -> Void)?) -> Self {
        self.qtextFieldHelper.didEndEditing = value
        return self
    }
    @discardableResult
    func qshouldChangeText(_ value: ((_ textField: UITextField, _ range: NSRange, _ replaceText: String) -> Bool)?) -> Self {
        self.qtextFieldHelper.shouldChangeText = value
        return self
    }
    @discardableResult
    func qdidChangeSelection(_ value: ((_ textField: UITextField) -> Void)?) -> Self {
        self.qtextFieldHelper.didChangeSelection = value
        return self
    }
    @discardableResult
    func qshouldClear(_ value: ((_ textField: UITextField) -> Bool)?) -> Self {
        self.qtextFieldHelper.shouldClear = value
        return self
    }
    @discardableResult
    func qshouldReturn(_ value: ((_ textField: UITextField) -> Bool)?) -> Self {
        self.qtextFieldHelper.shouldReturn = value
        return self
    }
    /// 结束编辑（带 reason，iOS 10+）。系统若调用此回调，会替代无 reason 的 didEndEditing
    @discardableResult
    func qdidEndEditingWithReason(_ value: ((_ textField: UITextField, _ reason: UITextField.DidEndEditingReason) -> Void)?) -> Self {
        self.qtextFieldHelper.didEndEditingWithReason = value
        return self
    }
    /// 自定义选区编辑菜单（iOS 16+），返回 nil 使用系统默认菜单
    @available(iOS 16.0, *)
    @discardableResult
    func qeditMenuForCharactersInRange(_ value: ((_ textField: UITextField, _ range: NSRange, _ suggestedActions: [UIMenuElement]) -> UIMenu?)?) -> Self {
        if let value = value {
            self.qtextFieldHelper.editMenuForCharactersInRange = { textField, range, suggestedActions in
                let actions = (suggestedActions as? [UIMenuElement]) ?? []
                return value(textField, range, actions)
            }
        } else {
            self.qtextFieldHelper.editMenuForCharactersInRange = nil
        }
        return self
    }
    /// 编辑菜单即将显示（iOS 16+）
    @available(iOS 16.0, *)
    @discardableResult
    func qwillPresentEditMenuWithAnimator(_ value: ((_ textField: UITextField, _ animator: any UIEditMenuInteractionAnimating) -> Void)?) -> Self {
        if let value = value {
            self.qtextFieldHelper.willPresentEditMenuWithAnimator = { textField, animator in
                guard let animator = animator as? UIEditMenuInteractionAnimating else { return }
                value(textField, animator)
            }
        } else {
            self.qtextFieldHelper.willPresentEditMenuWithAnimator = nil
        }
        return self
    }
    /// 编辑菜单即将消失（iOS 16+）
    @available(iOS 16.0, *)
    @discardableResult
    func qwillDismissEditMenuWithAnimator(_ value: ((_ textField: UITextField, _ animator: any UIEditMenuInteractionAnimating) -> Void)?) -> Self {
        if let value = value {
            self.qtextFieldHelper.willDismissEditMenuWithAnimator = { textField, animator in
                guard let animator = animator as? UIEditMenuInteractionAnimating else { return }
                value(textField, animator)
            }
        } else {
            self.qtextFieldHelper.willDismissEditMenuWithAnimator = nil
        }
        return self
    }
}
open class QTextFieldHelper: UIView {
    open var shouldBeginEditing: ((_ textField: UITextField) -> Bool)?
    open var didBeginEditing: ((_ textField: UITextField) -> Void)?
    open var shouldEndEditing: ((_ textField: UITextField) -> Bool)?
    open var didEndEditing: ((_ textField: UITextField) -> Void)?
    open var didEndEditingWithReason: ((_ textField: UITextField, _ reason: UITextField.DidEndEditingReason) -> Void)?
    open var shouldChangeText: ((_ textField: UITextField, _ range: NSRange, _ replaceText: String) -> Bool)?
    
    open var didChangeSelection: ((_ textField: UITextField) -> Void)?
    /// 文字改变之后的回调
    open var didChanged: ((_ textField: UITextField) -> Void)?
    
    /*
    // MARK: - maxCount  maxLength 的区别，
    // maxCount：表情长度 = 1     如“中文你好👰” count = 5
    // maxLength： 表情长度 = 2（也有超过2的） 如“中文你好👰” lengt = 6
    */
    
    /// 最多输入个数
    open var maxLength = 0
    /// 最多输入个数
    open var maxCount = 0
    
    open var shouldClear: ((_ textField: UITextField) -> Bool)?
    open var shouldReturn: ((_ textField: UITextField) -> Bool)?
    /// 返回 UIMenu?（iOS 16+），suggestedActions / 返回值用 Any 擦除以兼容更低部署版本
    open var editMenuForCharactersInRange: ((_ textField: UITextField, _ range: NSRange, _ suggestedActions: [Any]) -> Any?)?
    /// animator 为 iOS 16+ 类型，用 Any 擦除
    open var willPresentEditMenuWithAnimator: ((_ textField: UITextField, _ animator: Any) -> Void)?
    /// animator 为 iOS 16+ 类型，用 Any 擦除
    open var willDismissEditMenuWithAnimator: ((_ textField: UITextField, _ animator: Any) -> Void)?
    open weak var target: UITextField?
    public init(target: UITextField) {
        super.init(frame: .zero)
        self.target = target
        target.delegate = self
        self.isHidden = true
        target.addSubview(self)
        self.target?.addTarget(self, action: #selector(textFieldChanged(_ :)), for: .editingChanged)
    }
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc open func textFieldChanged(_ textField: UITextField) {
        defer {
            self.didChanged?(textField)
        }
        guard (self.maxCount > 0 || self.maxLength > 0), let _ = textField.text else { return }
        /// 中文输入时，先不处理
        if textField.qisZhInput() {
            return
        }
        var newText = textField.attributedText ?? .init()
        var selectedRange = textField.qselectedRange
        if self.maxCount > 0, newText.string.count > self.maxCount {
            newText = newText.qsubstring(emoji: .count, to: self.maxCount)
        } else if self.maxLength > 0, newText.string.qasNSString.length > self.maxLength {
            newText = newText.qsubstring(emoji: .length, to: self.maxLength)
        } else {
            return
        }
        textField.attributedText = newText
        if selectedRange.location > newText.length {
            selectedRange.location = newText.length
        }
        if selectedRange.location + selectedRange.length > newText.length {
            selectedRange.length = 0
        }
        DispatchQueue.main.async {
            if (textField.text?.count ?? 0) >= selectedRange.upperBound {
                textField.qselectedRange = selectedRange
            }
        }
    }
}
extension QTextFieldHelper: UITextFieldDelegate {
    open override func responds(to aSelector: Selector!) -> Bool {
        if #available(iOS 16.0, *) {
            if aSelector == #selector(textField(_:editMenuForCharactersIn:suggestedActions:)) {
                return editMenuForCharactersInRange != nil
            }
            if aSelector == #selector(textField(_:willPresentEditMenuWith:)) {
                return willPresentEditMenuWithAnimator != nil
            }
            if aSelector == #selector(textField(_:willDismissEditMenuWith:)) {
                return willDismissEditMenuWithAnimator != nil
            }
        }
        if aSelector == #selector(textFieldDidEndEditing(_:reason:)) {
            return didEndEditingWithReason != nil
        }
        return super.responds(to: aSelector)
    }
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return shouldBeginEditing?(textField) ?? true
    }
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        didBeginEditing?(textField)
    }
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return shouldEndEditing?(textField) ?? true
    }
    public func textFieldDidEndEditing(_ textField: UITextField) {
        didEndEditing?(textField)
    }
    /// 若实现本方法，系统会替代调用无 reason 的 textFieldDidEndEditing:
    public func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        didEndEditingWithReason?(textField, reason)
        didEndEditing?(textField)
    }
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return shouldChangeText?(textField, range, string) ?? true
    }
    @available(iOS 13.0, *)
    public func textFieldDidChangeSelection(_ textField: UITextField) {
        didChangeSelection?(textField)
    }
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return shouldClear?(textField) ?? true
    }
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return shouldReturn?(textField) ?? true
    }
    @available(iOS 16.0, *)
    public func textField(_ textField: UITextField, editMenuForCharactersIn range: NSRange, suggestedActions: [UIMenuElement]) -> UIMenu? {
        return editMenuForCharactersInRange?(textField, range, suggestedActions) as? UIMenu
    }
    @available(iOS 16.0, *)
    public func textField(_ textField: UITextField, willPresentEditMenuWith animator: any UIEditMenuInteractionAnimating) {
        willPresentEditMenuWithAnimator?(textField, animator)
    }
    @available(iOS 16.0, *)
    public func textField(_ textField: UITextField, willDismissEditMenuWith animator: any UIEditMenuInteractionAnimating) {
        willDismissEditMenuWithAnimator?(textField, animator)
    }
}
