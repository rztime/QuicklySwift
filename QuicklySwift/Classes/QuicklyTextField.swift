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
}
open class QTextFieldHelper: UIView {
    open var shouldBeginEditing: ((_ textField: UITextField) -> Bool)?
    open var didBeginEditing: ((_ textField: UITextField) -> Void)?
    open var shouldEndEditing: ((_ textField: UITextField) -> Bool)?
    open var didEndEditing: ((_ textField: UITextField) -> Void)?
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
        guard (self.maxCount > 0 || self.maxLength > 0), let text = textField.text else { return }
        let language = UIApplication.shared.textInputMode?.primaryLanguage
        if language?.hasPrefix("zh-Han") ?? false {
            let position = textField.position(from: (textField.markedTextRange ?? .init()).start, offset: 0)
            if position != nil {
                return
            }
        }
        var newText = text
        var selectedRange = textField.qselectedRange
        if self.maxCount > 0, text.count > self.maxCount {
            newText = text.qsubstring(emoji: .count, to: self.maxCount)
        } else if self.maxLength > 0, (text as NSString).length > self.maxLength {
            newText = text.qsubstring(emoji: .length, to: self.maxLength)
        }
        textField.text = newText
        if selectedRange.location > ("\(newText)" as NSString).length {
            selectedRange.location = ("\(newText)" as NSString).length
        }
        if selectedRange.location + selectedRange.length > ("\(newText)" as NSString).length {
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
}
