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
        guard (self.maxCount > 0 || self.maxLength > 0), let text = textView.text else { return }
        let language = UIApplication.shared.textInputMode?.primaryLanguage
        if language?.hasPrefix("zh-Han") ?? false {
            let position = textView.position(from: (textView.markedTextRange ?? .init()).start, offset: 0)
            if position != nil {
                return
            }
        }
        var newText = text
        var selectedRange = textView.selectedRange
        if self.maxCount > 0, text.count > self.maxCount {
            newText = text.qsubstring(emoji: .count, to: self.maxCount)
        } else if self.maxLength > 0, (text as NSString).length > self.maxLength {
            newText = text.qsubstring(emoji: .length, to: self.maxLength)
        }
        textView.text = newText
        if selectedRange.location > ("\(newText)" as NSString).length {
            selectedRange.location = ("\(newText)" as NSString).length
        }
        if selectedRange.location + selectedRange.length > ("\(newText)" as NSString).length {
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
                    let w = textView.frame.size.width - textView.contentInset.left - textView.contentInset.right
                    make.width.equalTo(w)
                })
            }
        })
    }
}
