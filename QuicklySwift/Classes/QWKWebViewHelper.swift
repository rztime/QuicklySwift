//
//  QWKWebViewHelper.swift
//  QuicklySwift
//
//  Created by rztime on 2025/3/10.
//

import UIKit
import WebKit
private var qwkwebviewhelper: UInt8 = 1
public extension WKWebView {
    var qdelegateHelper: QWKWebViewHelper {
        set {
            objc_setAssociatedObject(self, &qwkwebviewhelper, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            if let h = objc_getAssociatedObject(self, &qwkwebviewhelper) as? QWKWebViewHelper {
                return h
            }
            let helper = QWKWebViewHelper.init(webView: self)
            self.navigationDelegate = helper
            self.uiDelegate = helper
            self.qdelegateHelper = helper
            return helper
        }
    }
}
open class QWKWebViewHelper: NSObject {
    /// WKNavigationDelegate
    open var decidePolicyForNavigationActionDecisionHandler: ((_ webView: WKWebView, _ navAction: WKNavigationAction, _ complete: @escaping ((WKNavigationActionPolicy) -> Void)) -> Void)?
    open var decidePolicyForNavigationResponseDecisionHandler: ((_ webView: WKWebView, _ navResponse: WKNavigationResponse, _ complete: @escaping ((WKNavigationResponsePolicy) -> Void)) -> Void)?
    open var didStartProvisionalNavigation: ((_ webView: WKWebView, _ nav: WKNavigation) -> Void)?
    open var didReceiveServerRedirectForProvisionalNavigation: ((_ webView: WKWebView, _ nav: WKNavigation) -> Void)?
    open var didFailProvisionalNavigationWithError: ((_ webView: WKWebView, _ nav: WKNavigation, _ error: any Error) -> Void)?
    open var didCommit: ((_ webView: WKWebView, _ nav: WKNavigation) -> Void)?
    open var didFinish: ((_ webView: WKWebView, _ nav: WKNavigation) -> Void)?
    open var didFailWithError: ((_ webView: WKWebView, _ nav: WKNavigation, _ error: any Error) -> Void)?
    open var didReceiveChallengeCompletionHandler: ((_ webView: WKWebView, _ chanllenge: URLAuthenticationChallenge, _ complete: @escaping ((URLSession.AuthChallengeDisposition, URLCredential?) -> Void)) -> Void)?
    open var webContentProcessDidTerminate: ((_ webView: WKWebView) -> Void)?
    open var authenticationChallengeShouldAllowDeprecatedTLS: ((_ webView: WKWebView, _ chanllenge: URLAuthenticationChallenge, _ complete: @escaping ((Bool) -> Void)) -> Void)?
    open var navigationActionDidBecomeDownload: ((_ webView: WKWebView, _ navAction: WKNavigationAction, _ download: Any) -> Void)?
    open var navigationResponseDidBecomeDownload: ((_ webView: WKWebView, _ response: WKNavigationResponse, _ download: Any) -> Void)?
 
    /// WKUIDelegate
    open var createWebViewWithConfigurationForNavigationActionAndWindowFeatures: ((_ webView: WKWebView, _ configuration: WKWebViewConfiguration, _ navAction: WKNavigationAction, _ windowFeatures: WKWindowFeatures) -> WKWebView?)?
    open var webViewDidClose: ((_ webView: WKWebView) -> Void)?
    open var runJavaScriptAlertPanelWithMessageInitiatedByFrameCompletionHandler: ((_ webView: WKWebView, _ message: String, _ frame: WKFrameInfo, _ complete: @escaping (()-> Void)) -> Void)?
    open var runJavaScriptConfirmPanelWithMessageInitiatedByFrameCompletionHandler: ((_ webView: WKWebView, _ message: String, _ frame: WKFrameInfo, _ complete: @escaping ((Bool) -> Void)) -> Void)?
    open var runJavaScriptTextInputPanelWithPromptDefaultTextInitiatedByFrameCompletionHandler: ((_ webView: WKWebView, _ prompt: String, _ defaultText: String?, _ frame: WKFrameInfo, _ complete: @escaping ((String?) -> Void)) -> Void)?
    open var requestMediaCapturePermissionForOriginInitiatedByFrameAndType: ((_ webView: WKWebView, _ origin: Any, _ frame: WKFrameInfo, _ type: Any, _ complete: @escaping ((Any) -> Void)) -> Void)?
    open var requestDeviceOrientationAndMotionPermissionForOriginInitiatedByFrameDecisionHandler: ((_ webView: WKWebView, _ origin: Any, _ frame: WKFrameInfo, _ complete: @escaping ((Any) -> Void)) -> Void)?
    open var contextMenuConfigurationForElementCompletionHandler: ((_ webView: WKWebView, _ info: Any, _ complete: @escaping ((Any?) -> Void)) -> Void)?
    open var contextMenuWillPresentForElement: ((_ webView: WKWebView, _ info: Any) -> Void)?
    open var contextMenuForElementWillCommitWithAnimator: ((_ webView: WKWebView, _ info: Any, _ animator: Any) -> Void)?
    open var contextMenuDidEndForElement: ((_ webView: WKWebView, _ info: Any) -> Void)?
    open var willPresentEditMenuWithAnimator: ((_ webView: WKWebView, _ animator: Any) -> Void)?
    open var willDismissEditMenuWithAnimator: ((_ webView: WKWebView, _ animator: Any) -> Void)?
    
    // JS 桥
    open var userContentControllerDidReceiveMessage: ((_ controller: WKUserContentController, _ message: WKScriptMessage) -> Void)?
    
    open var jsContent: [WKUserContentController] = []
    open weak var _webView: WKWebView?
    public init(webView: WKWebView) {
        super.init()
        _webView = webView
        webView.qdeinit { [weak self] in
            self?.jsContent.forEach { c in
                if #available(iOS 14.0, *) {
                    c.removeAllScriptMessageHandlers()
                } else {
                    c.jsNames.forEach({c.removeScriptMessageHandler(forName: $0)})
                }
            }
            self?.jsContent = []
        }
    }
}
// MARK: WKNavigationDelegate
extension QWKWebViewHelper: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping @MainActor (WKNavigationActionPolicy) -> Void) {
        if let d = self.decidePolicyForNavigationActionDecisionHandler {
            d(webView, navigationAction, { result in
                decisionHandler(result)
            })
        } else{
            decisionHandler(.allow)
        }
    }
    public func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping @MainActor (WKNavigationResponsePolicy) -> Void) {
        if let d = self.decidePolicyForNavigationResponseDecisionHandler {
            d(webView, navigationResponse, { result in
                decisionHandler(result)
            })
        } else {
            decisionHandler(.allow)
        }
    }
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.didStartProvisionalNavigation?(webView, navigation)
    }
    public func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        self.didReceiveServerRedirectForProvisionalNavigation?(webView, navigation)
    }
    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: any Error) {
        self.didFailProvisionalNavigationWithError?(webView, navigation, error)
        webView._qestimatedProgressPublish?.accept(.none)
    }
    public func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        self.didCommit?(webView, navigation)
    }
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.didFinish?(webView, navigation)
        webView._qestimatedProgressPublish?.accept(.none)
    }
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: any Error) {
        self.didFailWithError?(webView, navigation, error)
        webView._qestimatedProgressPublish?.accept(.none)
    }
    public func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping @MainActor (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if let d = self.didReceiveChallengeCompletionHandler {
            d(webView, challenge, { result, URI in
                completionHandler(result, URI)
            })
        } else {
            completionHandler(.performDefaultHandling, nil)
        }
    }
    public func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        self.webContentProcessDidTerminate?(webView)
    }
    public func webView(_ webView: WKWebView, authenticationChallenge challenge: URLAuthenticationChallenge, shouldAllowDeprecatedTLS decisionHandler: @escaping @MainActor (Bool) -> Void) {
        if let a = self.authenticationChallengeShouldAllowDeprecatedTLS {
            a(webView, challenge, { result in
                decisionHandler(result)
            })
        } else {
            decisionHandler(false)
        }
    }
    @available(iOS 14.5, *)
    public func webView(_ webView: WKWebView, navigationAction: WKNavigationAction, didBecome download: WKDownload) {
        self.navigationActionDidBecomeDownload?(webView, navigationAction, download)
    }
    @available(iOS 14.5, *)
    public func webView(_ webView: WKWebView, navigationResponse: WKNavigationResponse, didBecome download: WKDownload) {
        self.navigationResponseDidBecomeDownload?(webView, navigationResponse, download)
    }
}
// MARK: WKUIDelegate
extension QWKWebViewHelper: WKUIDelegate {
    public func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        return self.createWebViewWithConfigurationForNavigationActionAndWindowFeatures?(webView, configuration, navigationAction, windowFeatures)
    }
    public func webViewDidClose(_ webView: WKWebView) {
        self.webViewDidClose?(webView)
    }
    public func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping @MainActor () -> Void) {
        if let r = self.runJavaScriptAlertPanelWithMessageInitiatedByFrameCompletionHandler {
            r(webView, message, frame, {
                completionHandler()
            })
        } else {
            UIAlertController.qwith(title: webView.title, message, actions: ["确定"]) { _ in
                completionHandler()
            }
        }
    }
    public func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping @MainActor (Bool) -> Void) {
        if let r = self.runJavaScriptConfirmPanelWithMessageInitiatedByFrameCompletionHandler {
            r(webView, message, frame, { result in
                completionHandler(result)
            })
        } else {
            UIAlertController.qwith(title: webView.title, message, actions: ["取消", "确定"]) { index in
                if index == 1 {
                    completionHandler(true)
                } else {
                    completionHandler(false)
                }
            }
        }
    }
    public func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping @MainActor (String?) -> Void) {
        if let r = self.runJavaScriptTextInputPanelWithPromptDefaultTextInitiatedByFrameCompletionHandler {
            r(webView, prompt, defaultText, frame, { text in
                completionHandler(text)
            })
        } else {
            var textField : UITextField?
            let vc = UIAlertController.qwith(title: webView.title, prompt, actions: ["取消", "确定"]) { index in
                if index == 1 {
                    completionHandler(textField?.text)
                } else {
                    completionHandler(nil)
                }
                textField = nil
            }
            vc.addTextField { t in
                textField = t
                t.placeholder = defaultText
            }
        }
    }
    @available(iOS 15.0, *)
    public func webView(_ webView: WKWebView, requestMediaCapturePermissionFor origin: WKSecurityOrigin, initiatedByFrame frame: WKFrameInfo, type: WKMediaCaptureType, decisionHandler: @escaping @MainActor (WKPermissionDecision) -> Void) {
        if let r = self.requestMediaCapturePermissionForOriginInitiatedByFrameAndType {
            r(webView, origin, frame, type, { result in
                if let result = result as? WKPermissionDecision {
                    decisionHandler(result)
                } else {
                    decisionHandler(.prompt)
                }
            })
        } else {
            decisionHandler(.prompt)
        }
    }
    @available(iOS 15.0, *)
    public func webView(_ webView: WKWebView, requestDeviceOrientationAndMotionPermissionFor origin: WKSecurityOrigin, initiatedByFrame frame: WKFrameInfo, decisionHandler: @escaping @MainActor (WKPermissionDecision) -> Void) {
        if let r = self.requestDeviceOrientationAndMotionPermissionForOriginInitiatedByFrameDecisionHandler {
            r(webView, origin, frame, { result in
                if let result = result as? WKPermissionDecision {
                    decisionHandler(result)
                } else {
                    decisionHandler(.prompt)
                }
            })
        } else {
            decisionHandler(.prompt)
        }
    }
    @available(iOS 13.0, *)
    public func webView(_ webView: WKWebView, contextMenuConfigurationForElement elementInfo: WKContextMenuElementInfo, completionHandler: @escaping @MainActor (UIContextMenuConfiguration?) -> Void) {
        if let r = self.contextMenuConfigurationForElementCompletionHandler {
            r(webView, elementInfo, { result in
                if let result = result as? UIContextMenuConfiguration {
                    completionHandler(result)
                } else {
                    completionHandler(nil)
                }
            })
        } else {
            completionHandler(nil)
        }
    }
    @available(iOS 13.0, *)
    public func webView(_ webView: WKWebView, contextMenuWillPresentForElement elementInfo: WKContextMenuElementInfo) {
        self.contextMenuWillPresentForElement?(webView, elementInfo)
    }
    @available(iOS 13.0, *)
    public func webView(_ webView: WKWebView, contextMenuForElement elementInfo: WKContextMenuElementInfo, willCommitWithAnimator animator: any UIContextMenuInteractionCommitAnimating) {
        self.contextMenuForElementWillCommitWithAnimator?(webView, elementInfo, animator)
    }
    @available(iOS 13.0, *)
    public func webView(_ webView: WKWebView, contextMenuDidEndForElement elementInfo: WKContextMenuElementInfo) {
        self.contextMenuDidEndForElement?(webView, elementInfo)
    }
    
    @available(iOS 16.4, *)
    public func webView(_ webView: WKWebView, willPresentEditMenuWithAnimator animator: any UIEditMenuInteractionAnimating) {
        self.willPresentEditMenuWithAnimator?(webView, animator)
    }
    @available(iOS 16.4, *)
    public func webView(_ webView: WKWebView, willDismissEditMenuWithAnimator animator: any UIEditMenuInteractionAnimating) {
        self.willDismissEditMenuWithAnimator?(webView, animator)
    }
}
// MARK: 桥
extension QWKWebViewHelper: WKScriptMessageHandler {
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        self.userContentControllerDidReceiveMessage?(userContentController, message)
    }
    public func qaddJSMessageWith(names: [String]) {
        guard !names.isEmpty, let c = self._webView?.configuration.userContentController else { return }
        if let _ = self.jsContent.first(where: {$0 == c}) {
            
        } else {
            self.jsContent.append(c)
        }
        c.jsNames.append(contentsOf: names)
        names.forEach({c.add(self, name: $0)})
    }
}
private var qwkuserContentControllerJSNames: UInt8 = 1
public extension WKUserContentController {
    var jsNames: [String] {
        set {
            objc_setAssociatedObject(self, &qwkuserContentControllerJSNames, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            if let names = objc_getAssociatedObject(self, &qwkuserContentControllerJSNames) as? [String] {
                return names
            }
            self.jsNames = []
            return self.jsNames
        }
    }
}
