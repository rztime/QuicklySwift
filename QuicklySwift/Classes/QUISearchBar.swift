//
//  QuicklySearchBar.swift
//  QuicklySwift
//
//  Created by rztime on 2026/9/22.
//

import UIKit

public extension UISearchBar {
    @discardableResult
    func qtext(_ text: String?) -> Self {
        self.text = text
        return self
    }
    @discardableResult
    func qplaceholder(_ text: String?) -> Self {
        self.placeholder = text
        return self
    }
    @discardableResult
    func qprompt(_ text: String?) -> Self {
        self.prompt = text
        return self
    }
    @discardableResult
    func qbarStyle(_ style: UIBarStyle) -> Self {
        self.barStyle = style
        return self
    }
    @discardableResult
    func qsearchBarStyle(_ style: UISearchBar.Style) -> Self {
        self.searchBarStyle = style
        return self
    }
    @discardableResult
    func qbarTintColor(_ color: UIColor?) -> Self {
        self.barTintColor = color
        return self
    }
    @discardableResult
    func qisTranslucent(_ translucent: Bool) -> Self {
        self.isTranslucent = translucent
        return self
    }
    @discardableResult
    func qshowsCancelButton(_ show: Bool) -> Self {
        self.showsCancelButton = show
        return self
    }
    @discardableResult
    func qshowsCancelButton(_ show: Bool, animated: Bool) -> Self {
        self.setShowsCancelButton(show, animated: animated)
        return self
    }
    @discardableResult
    func qshowsBookmarkButton(_ show: Bool) -> Self {
        self.showsBookmarkButton = show
        return self
    }
    @discardableResult
    func qshowsSearchResultsButton(_ show: Bool) -> Self {
        self.showsSearchResultsButton = show
        return self
    }
    @discardableResult
    func qisSearchResultsButtonSelected(_ selected: Bool) -> Self {
        self.isSearchResultsButtonSelected = selected
        return self
    }
    @discardableResult
    func qshowsScopeBar(_ show: Bool) -> Self {
        self.showsScopeBar = show
        return self
    }
    @discardableResult
    func qscopeButtonTitles(_ titles: [String]?) -> Self {
        self.scopeButtonTitles = titles
        return self
    }
    @discardableResult
    func qselectedScopeButtonIndex(_ index: Int) -> Self {
        self.selectedScopeButtonIndex = index
        return self
    }
    @discardableResult
    func qkeyboardType(_ type: UIKeyboardType) -> Self {
        self.keyboardType = type
        return self
    }
    @discardableResult
    func qreturnKeyType(_ type: UIReturnKeyType) -> Self {
        self.returnKeyType = type
        return self
    }
    @discardableResult
    func qautocapitalizationType(_ type: UITextAutocapitalizationType) -> Self {
        self.autocapitalizationType = type
        return self
    }
    @discardableResult
    func qautocorrectionType(_ type: UITextAutocorrectionType) -> Self {
        self.autocorrectionType = type
        return self
    }
    @discardableResult
    func qbackgroundImage(_ image: UIImage?) -> Self {
        self.backgroundImage = image
        return self
    }
    @discardableResult
    func qsearchFieldBackgroundImage(_ image: UIImage?, for state: UIControl.State = .normal) -> Self {
        self.setSearchFieldBackgroundImage(image, for: state)
        return self
    }
    @discardableResult
    func qinputAccessoryView(_ view: UIView?) -> Self {
        self.inputAccessoryView = view
        return self
    }
    @discardableResult
    func qdelegate(_ delegate: UISearchBarDelegate?) -> Self {
        self.delegate = delegate
        return self
    }
}

// MARK: - searchBar delegate 的 quickly 方法
public extension UISearchBar {
    @discardableResult
    func qshouldBeginEditing(_ value: ((_ searchBar: UISearchBar) -> Bool)?) -> Self {
        self.qsearchBarHelper.shouldBeginEditing = value
        return self
    }
    @discardableResult
    func qdidBeginEditing(_ value: ((_ searchBar: UISearchBar) -> Void)?) -> Self {
        self.qsearchBarHelper.didBeginEditing = value
        return self
    }
    @discardableResult
    func qshouldEndEditing(_ value: ((_ searchBar: UISearchBar) -> Bool)?) -> Self {
        self.qsearchBarHelper.shouldEndEditing = value
        return self
    }
    @discardableResult
    func qdidEndEditing(_ value: ((_ searchBar: UISearchBar) -> Void)?) -> Self {
        self.qsearchBarHelper.didEndEditing = value
        return self
    }
    @discardableResult
    func qtextDidChange(_ value: ((_ searchBar: UISearchBar, _ searchText: String) -> Void)?) -> Self {
        self.qsearchBarHelper.textDidChange = value
        return self
    }
    @discardableResult
    func qshouldChangeText(_ value: ((_ searchBar: UISearchBar, _ range: NSRange, _ replaceText: String) -> Bool)?) -> Self {
        self.qsearchBarHelper.shouldChangeText = value
        return self
    }
    @discardableResult
    func qsearchButtonClicked(_ value: ((_ searchBar: UISearchBar) -> Void)?) -> Self {
        self.qsearchBarHelper.searchButtonClicked = value
        return self
    }
    @discardableResult
    func qbookmarkButtonClicked(_ value: ((_ searchBar: UISearchBar) -> Void)?) -> Self {
        self.qsearchBarHelper.bookmarkButtonClicked = value
        return self
    }
    @discardableResult
    func qcancelButtonClicked(_ value: ((_ searchBar: UISearchBar) -> Void)?) -> Self {
        self.qsearchBarHelper.cancelButtonClicked = value
        return self
    }
    @discardableResult
    func qresultsListButtonClicked(_ value: ((_ searchBar: UISearchBar) -> Void)?) -> Self {
        self.qsearchBarHelper.resultsListButtonClicked = value
        return self
    }
    @discardableResult
    func qselectedScopeButtonIndexDidChange(_ value: ((_ searchBar: UISearchBar, _ selectedScope: Int) -> Void)?) -> Self {
        self.qsearchBarHelper.selectedScopeButtonIndexDidChange = value
        return self
    }
}

open class QSearchBarHelper: UIView {
    open var shouldBeginEditing: ((_ searchBar: UISearchBar) -> Bool)?
    open var didBeginEditing: ((_ searchBar: UISearchBar) -> Void)?
    open var shouldEndEditing: ((_ searchBar: UISearchBar) -> Bool)?
    open var didEndEditing: ((_ searchBar: UISearchBar) -> Void)?
    open var textDidChange: ((_ searchBar: UISearchBar, _ searchText: String) -> Void)?
    open var shouldChangeText: ((_ searchBar: UISearchBar, _ range: NSRange, _ replaceText: String) -> Bool)?
    open var searchButtonClicked: ((_ searchBar: UISearchBar) -> Void)?
    open var bookmarkButtonClicked: ((_ searchBar: UISearchBar) -> Void)?
    open var cancelButtonClicked: ((_ searchBar: UISearchBar) -> Void)?
    open var resultsListButtonClicked: ((_ searchBar: UISearchBar) -> Void)?
    open var selectedScopeButtonIndexDidChange: ((_ searchBar: UISearchBar, _ selectedScope: Int) -> Void)?

    open weak var target: UISearchBar?

    public init(target: UISearchBar) {
        super.init(frame: .zero)
        self.target = target
        target.delegate = self
        self.isHidden = true
        target.addSubview(self)
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension QSearchBarHelper: UISearchBarDelegate {
    /// 仅当对应 block 非 nil 时声明实现，未设置则交给系统默认
    open override func responds(to aSelector: Selector!) -> Bool {
        if aSelector == #selector(searchBarShouldBeginEditing(_:)) {
            return shouldBeginEditing != nil
        }
        if aSelector == #selector(searchBarTextDidBeginEditing(_:)) {
            return didBeginEditing != nil
        }
        if aSelector == #selector(searchBarShouldEndEditing(_:)) {
            return shouldEndEditing != nil
        }
        if aSelector == #selector(searchBarTextDidEndEditing(_:)) {
            return didEndEditing != nil
        }
        if aSelector == #selector(searchBar(_:textDidChange:)) {
            return textDidChange != nil
        }
        if aSelector == #selector(searchBar(_:shouldChangeTextIn:replacementText:)) {
            return shouldChangeText != nil
        }
        if aSelector == #selector(searchBarSearchButtonClicked(_:)) {
            return searchButtonClicked != nil
        }
        if aSelector == #selector(searchBarBookmarkButtonClicked(_:)) {
            return bookmarkButtonClicked != nil
        }
        if aSelector == #selector(searchBarCancelButtonClicked(_:)) {
            return cancelButtonClicked != nil
        }
        if aSelector == #selector(searchBarResultsListButtonClicked(_:)) {
            return resultsListButtonClicked != nil
        }
        if aSelector == #selector(searchBar(_:selectedScopeButtonIndexDidChange:)) {
            return selectedScopeButtonIndexDidChange != nil
        }
        return super.responds(to: aSelector)
    }

    public func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return shouldBeginEditing?(searchBar) ?? true
    }
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        didBeginEditing?(searchBar)
    }
    public func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return shouldEndEditing?(searchBar) ?? true
    }
    public func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        didEndEditing?(searchBar)
    }
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        textDidChange?(searchBar, searchText)
    }
    public func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return shouldChangeText?(searchBar, range, text) ?? true
    }
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchButtonClicked?(searchBar)
    }
    public func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        bookmarkButtonClicked?(searchBar)
    }
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        cancelButtonClicked?(searchBar)
    }
    public func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
        resultsListButtonClicked?(searchBar)
    }
    public func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        selectedScopeButtonIndexDidChange?(searchBar, selectedScope)
    }
}
