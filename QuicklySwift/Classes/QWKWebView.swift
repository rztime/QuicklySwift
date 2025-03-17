//
//  QWKWebView.swift
//  QuicklySwift
//
//  Created by rztime on 2025/3/10.
//

import UIKit
import WebKit

public extension WKWebView {
    @discardableResult
    func qloadURL(_ url: URL?) -> Self {
        if let url = url {
            self.load(.init(url: url))
        }
        return self
    }
    @discardableResult
    func qnavigationDelegate(_ d: (any WKNavigationDelegate)?) -> Self {
        self.navigationDelegate = d
        return self
    }
    @discardableResult
    func quiDelegate(_ d: (any WKUIDelegate)?) -> Self {
        self.uiDelegate = d
        return self
    }
    @discardableResult
    func qallowsBackForwardNavigationGestures(_ a: Bool) -> Self {
        self.allowsBackForwardNavigationGestures = a
        return self
    }
    @discardableResult
    func qcustomUserAgent(_ ua: String?) -> Self {
        self.customUserAgent = ua
        return self
    }
    @discardableResult
    func qallowsLinkPreview(_ a: Bool) -> Self {
        self.allowsLinkPreview = a
        return self
    }
    @discardableResult
    func qpageZoom(_ z: CGFloat) -> Self {
        if #available(iOS 14.0, *) {
            self.pageZoom = z
        }
        return self
    }
    @discardableResult
    func qmediaType(_ t: String?) -> Self {
        if #available(iOS 14.0, *) {
            self.mediaType = t
        }
        return self
    }
    @discardableResult
    func qinteractionState(_ i: Any?) -> Self {
        if #available(iOS 15.0, *) {
            self.interactionState = i
        }
        return self
    }
    @discardableResult
    func qunderPageBackgroundColor(_ c: UIColor) -> Self {
        if #available(iOS 15.0, *) {
            self.underPageBackgroundColor = c
        }
        return self
    }
    @discardableResult
    func qisFindInteractionEnabled(_ e: Bool) -> Self {
        if #available(iOS 16.0, *) {
            self.isFindInteractionEnabled = e
        }
        return self
    }
    @discardableResult
    func qisInspectable(_ i: Bool) -> Self {
        if #available(iOS 16.4, *) {
            self.isInspectable = i
        }
        return self
    }
}
/// 进度
public enum QWKWebViewLoadingProgress {
    case none  // 未加载 | 加载结束（失败|成功）
    case progress(progress: CGFloat)   // 0-1
}
private var quicklyWKProgress: UInt8 = 1
private var quicklyWKTitle: UInt8 = 2
/// 添加监听
public extension WKWebView {
    /// 进度监听
    var qestimatedProgressPublish: QPublish<QWKWebViewLoadingProgress>? {
        if let p = self._qestimatedProgressPublish {
            return p
        }
        let p = QPublish<QWKWebViewLoadingProgress>.init(value: .none)
        self._qestimatedProgressPublish = p
        self.qaddObserver(key: "estimatedProgress", options: [.new, .old, .initial], context: nil) { [weak self] sender, key, value in
            guard let self = self else { return }
            let progress = CGFloat(self.estimatedProgress)
            if progress < 0.05 || progress >= 1 {
                self._qestimatedProgressPublish?.accept(.none)
            } else {
                self._qestimatedProgressPublish?.accept(.progress(progress: progress))
            }
        }
        return p
    }
    /// 标题变化
    var qtitlePublish: QPublish<String?> {
        set {
            objc_setAssociatedObject(self, &quicklyWKTitle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            if let t = objc_getAssociatedObject(self, &quicklyWKTitle) as? QPublish<String?> {
                return t
            }
            let t = QPublish<String?>.init(value: nil)
            self.qtitlePublish = t
            self.qaddObserver(key: "title", options: [.new, .old], context: nil) { [weak t] sender, key, value in
                t?.accept(sender.title)
            }
            return t
        }
    }
}
extension WKWebView {
    /// wkwebviewHelper内部使用
    internal var _qestimatedProgressPublish: QPublish<QWKWebViewLoadingProgress>? {
        set {
            objc_setAssociatedObject(self, &quicklyWKProgress, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            if let p = objc_getAssociatedObject(self, &quicklyWKProgress) as? QPublish<QWKWebViewLoadingProgress> {
                return p
            }
            return nil
        }
    }
}
// MARK: WKNavigationDelegate
public extension WKWebView {
    /// 发送请求前，决定是否跳转
    @discardableResult
    func qdecidePolicyForNavigationActionDecisionHandler(_ handle: ((_ webView: WKWebView, _ navAction: WKNavigationAction, _ completionHandler: @escaping ((WKNavigationActionPolicy) -> Void)) -> Void)?) -> Self {
        self.qdelegateHelper.decidePolicyForNavigationActionDecisionHandler = handle
        return self
    }
    /// 接到响应后，决定是否跳转
    @discardableResult
    func qdecidePolicyForNavigationResponseDecisionHandler(_ handle: ((_ webView: WKWebView, _ navResponse: WKNavigationResponse, _ completionHandler: @escaping ((WKNavigationResponsePolicy) -> Void)) -> Void)?) -> Self {
        self.qdelegateHelper.decidePolicyForNavigationResponseDecisionHandler = handle
        return self
    }
    /// 页面开始加载
    @discardableResult
    func qdidStartProvisionalNavigation(_ star: ((_ webView: WKWebView, _ nav: WKNavigation) -> Void)?) -> Self {
        self.qdelegateHelper.didStartProvisionalNavigation = star
        return self
    }
    /// 接收到服务器跳转请求
    @discardableResult
    func qdidReceiveServerRedirectForProvisionalNavigation(_ receive: ((_ webView: WKWebView, _ nav: WKNavigation) -> Void)?) -> Self {
        self.qdelegateHelper.didReceiveServerRedirectForProvisionalNavigation = receive
        return self
    }
    /// 页面加载失败（尝试加载，但未收到服务器响应数据前，就发生了错误）（进度0之前发生错误）
    @discardableResult
    func qdidFailProvisionalNavigationWithError(_ fail: ((_ webView: WKWebView, _ nav: WKNavigation, _ error: any Error) -> Void)?) -> Self {
        self.qdelegateHelper.didFailProvisionalNavigationWithError = fail
        return self
    }
    /// 内容开始返回
    @discardableResult
    func qdidCommit(_ commit: ((_ webView: WKWebView, _ nav: WKNavigation) -> Void)?) -> Self {
        self.qdelegateHelper.didCommit = commit
        return self
    }
    /// 页面加载完成
    @discardableResult
    func qdidFinish(_ finish: ((_ webView: WKWebView, _ nav: WKNavigation) -> Void)?) -> Self {
        self.qdelegateHelper.didFinish = finish
        return self
    }
    /// 页面加载失败（收到了服务器响应，加载过程中发生了错误）（进度0-1之间发生错误）
    @discardableResult
    func qdidFailWithError(_ fail: ((_ webView: WKWebView, _ nav: WKNavigation, _ error: any Error) -> Void)?) -> Self {
        self.qdelegateHelper.didFailWithError = fail
        return self
    }
    /// 要求客户端进行身份验证
    @discardableResult
    func qdidReceiveChallengeCompletionHandler(_ handle: ((_ webView: WKWebView, _ chanllenge: URLAuthenticationChallenge, _ completionHandler: @escaping ((URLSession.AuthChallengeDisposition, URLCredential?) -> Void)) -> Void)?) -> Self {
        self.qdelegateHelper.didReceiveChallengeCompletionHandler = handle
        return self
    }
    ///  Web 内容进程崩溃或被系统终止时, 可以在此方法中实现恢复逻辑，例如重新加载页面或提示用户
    @discardableResult
    func qwebContentProcessDidTerminate(_ t: ((_ webView: WKWebView) -> Void)?) -> Self {
        self.qdelegateHelper.webContentProcessDidTerminate = t
        return self
    }
    /// 尝试连接到使用过时 TLS 版本的服务器时，系统会调用此方法
    @discardableResult
    func qauthenticationChallengeShouldAllowDeprecatedTLS(_ tls: ((_ webView: WKWebView, _ chanllenge: URLAuthenticationChallenge, _ completionHandler: @escaping ((Bool) -> Void)) -> Void)?) -> Self {
        self.qdelegateHelper.authenticationChallengeShouldAllowDeprecatedTLS = tls
        return self
    }
    /// 某个导航操作（例如点击链接或提交表单），而该操作被系统识别为需要下载文件时，系统会调用此方法
    @discardableResult
    @available(iOS 14.5, *)
    func qnavigationActionDidBecomeDownload(_ d: ((_ webView: WKWebView, _ navAction: WKNavigationAction, _ download: WKDownload) -> Void)?) -> Self {
        if let d = d as? ((WKWebView, WKNavigationAction, Any) -> Void)? {
            self.qdelegateHelper.navigationActionDidBecomeDownload = d
        } else {
            self.qdelegateHelper.navigationActionDidBecomeDownload = nil
        }
        return self
    }
    /// 接收到服务器的响应，并且该响应被识别为需要下载文件时，系统会调用此方法
    /// 可以在此方法中处理下载任务，例如启动下载、监控下载进度或保存文件
    @discardableResult
    @available(iOS 14.5, *)
    func qnavigationResponseDidBecomeDownload(_ d: ((_ webView: WKWebView, _ response: WKNavigationResponse, _ download: WKDownload) -> Void)?) -> Self {
        if let d = d as? ((WKWebView, WKNavigationResponse, Any) -> Void)? {
            self.qdelegateHelper.navigationResponseDidBecomeDownload = d
        } else {
            self.qdelegateHelper.navigationResponseDidBecomeDownload = nil
        }
        return self
    }
}
// MARK: WKUIDelegate
public extension WKWebView {
    /// 当需要创建一个新的 WebView 来处理目标为 _blank 的链接或弹出窗口时，系统会调用此方法
    @discardableResult
    func qcreateWebViewWithConfigurationForNavigationActionAndWindowFeatures(_ d: ((_ webView: WKWebView, _ configuration: WKWebViewConfiguration, _ navAction: WKNavigationAction, _ windowFeatures: WKWindowFeatures) -> WKWebView?)?) -> Self {
        self.qdelegateHelper.createWebViewWithConfigurationForNavigationActionAndWindowFeatures = d
        return self
    }
    /// 通过 JavaScript 调用 window.close() 关闭时，系统会调用此方法
    @discardableResult
    func qwebViewDidClose(_ c: ((_ webView: WKWebView) -> Void)?) -> Self {
        self.qdelegateHelper.webViewDidClose = c
        return self
    }
    /// 显示JavaScript的alert弹窗，并在确认后执行completionHandler回调。
    @discardableResult
    func qrunJavaScriptAlertPanelWithMessageInitiatedByFrameCompletionHandler(_ run: ((_ webView: WKWebView, _ message: String, _ frame: WKFrameInfo, _ completionHandler: @escaping (() -> Void)) -> Void)?) -> Self {
        self.qdelegateHelper.runJavaScriptAlertPanelWithMessageInitiatedByFrameCompletionHandler = run
        return self
    }
    /// 显示JavaScript确认对话框，根据用户选择（确定或取消）,通过completionHandler返回布尔值结果。
    @discardableResult
    func qrunJavaScriptConfirmPanelWithMessageInitiatedByFrameCompletionHandler(_ run: ((_ webView: WKWebView, _ message: String, _ frame: WKFrameInfo, _ completionHandler: @escaping ((Bool) -> Void)) -> Void)?) -> Self {
        self.qdelegateHelper.runJavaScriptConfirmPanelWithMessageInitiatedByFrameCompletionHandler = run
        return self
    }
    /// 处理JavaScript的输入对话框，输入文本并通过completionHandler返回输入的字符串或nil
    @discardableResult
    func qrunJavaScriptTextInputPanelWithPromptDefaultTextInitiatedByFrameCompletionHandler(_ run: ((_ webView: WKWebView, _ prompt: String, _ defaultText: String?, _ frame: WKFrameInfo, _ completionHandler: @escaping ((String?) -> Void)) -> Void)?) -> Self {
        self.qdelegateHelper.runJavaScriptTextInputPanelWithPromptDefaultTextInitiatedByFrameCompletionHandler = run
        return self
    }
    // 处理WKWebView中媒体权限请求（如摄像头或麦克风）
    @discardableResult
    @available(iOS 15.0, *)
    func qrequestMediaCapturePermissionForOriginInitiatedByFrameAndType(_ r: ((_ webView: WKWebView, _ origin: WKSecurityOrigin, _ frame: WKFrameInfo, _ type: WKMediaCaptureType, _ completionHandler: @escaping ((WKPermissionDecision) -> Void)) -> Void)?) -> Self {
        if let r = r as? ((WKWebView, Any, WKFrameInfo, Any, ((Any) -> Void)) -> Void)? {
            self.qdelegateHelper.requestMediaCapturePermissionForOriginInitiatedByFrameAndType = r
        } else {
            self.qdelegateHelper.requestMediaCapturePermissionForOriginInitiatedByFrameAndType = nil
        }
        return self
    }
    /// 处理WKWebView中设备方向和运动数据的权限请求
    @discardableResult
    @available(iOS 15.0, *)
    func qrequestDeviceOrientationAndMotionPermissionForOriginInitiatedByFrameDecisionHandler(_ r: ((_ webView: WKWebView, _ origin: WKSecurityOrigin, _ frame: WKFrameInfo, _ completionHandler: @escaping ((WKPermissionDecision) -> Void)) -> WKPermissionDecision)?) -> Self {
        if let r = r as? ((WKWebView, Any, WKFrameInfo, ((Any) -> Void)) -> Void)? {
            self.qdelegateHelper.requestDeviceOrientationAndMotionPermissionForOriginInitiatedByFrameDecisionHandler = r
        } else {
            self.qdelegateHelper.requestDeviceOrientationAndMotionPermissionForOriginInitiatedByFrameDecisionHandler = nil
        }
        return self
    }
    /// 为WKWebView中的特定元素配置上下文菜单
    @discardableResult
    @available(iOS 13.0, *)
    func qcontextMenuConfigurationForElementCompletionHandler(_ c: ((_ webView: WKWebView, _ info: WKContextMenuElementInfo, _ completionHandler: @escaping ((UIContextMenuConfiguration?) -> Void)) -> Void)?) -> Self {
        if let c = c as? ((WKWebView, Any, ((Any?) -> Void)) -> Void)? {
            self.qdelegateHelper.contextMenuConfigurationForElementCompletionHandler = c
        } else {
            self.qdelegateHelper.contextMenuConfigurationForElementCompletionHandler = nil
        }
        return self
    }
    /// 即将显示指定元素的上下文菜单时，用于处理菜单显示前的逻辑
    @discardableResult
    @available(iOS 13.0, *)
    func qcontextMenuWillPresentForElement(_ c: ((_ webView: WKWebView, _ info: WKContextMenuElementInfo) -> Void)?) -> Self {
        if let c = c as? ((WKWebView, Any) -> Void)? {
            self.qdelegateHelper.contextMenuWillPresentForElement = c
        } else {
            self.qdelegateHelper.contextMenuWillPresentForElement = nil
        }
        return self
    }
    /// 选择上下文菜单项并即将触发提交动作时调用，用于处理菜单项提交前的逻辑
    @discardableResult
    @available(iOS 13.0, *)
    func qcontextMenuForElementWillCommitWithAnimator(_ c: ((_ webView: WKWebView, _ info: WKContextMenuElementInfo, _ animator: any UIContextMenuInteractionCommitAnimating) -> Void)?) -> Self {
        if let c = c as? ((WKWebView, Any, Any) -> Void)? {
            self.qdelegateHelper.contextMenuForElementWillCommitWithAnimator = c
        } else {
            self.qdelegateHelper.contextMenuForElementWillCommitWithAnimator = nil
        }
        return self
    }
    /// 上下文菜单交互结束时调用，用于处理菜单关闭后的逻辑
    @discardableResult
    @available(iOS 13.0, *)
    func qcontextMenuDidEndForElement(_ c: ((_ webView: WKWebView, _ info: WKContextMenuElementInfo) -> Void)?) -> Self {
        if let c = c as? ((WKWebView, Any) -> Void)? {
            self.qdelegateHelper.contextMenuDidEndForElement = c
        } else {
            self.qdelegateHelper.contextMenuDidEndForElement = nil
        }
        return self
    }
    /// 即将显示编辑菜单时调用，允许通过animator自定义菜单的呈现动画或行为
    @discardableResult
    @available(iOS 16.4, *)
    func qwillPresentEditMenuWithAnimator(_ w: ((_ webView: WKWebView, _ animator: any UIEditMenuInteractionAnimating) -> Void)?) -> Self {
        if let w = w as? ((WKWebView, Any) -> Void)? {
            self.qdelegateHelper.willPresentEditMenuWithAnimator = w
        } else {
            self.qdelegateHelper.willPresentEditMenuWithAnimator = nil
        }
        return self
    }
    /// 编辑菜单即将消失时调用，允许通过animator自定义菜单的消失动画或行为
    @discardableResult
    @available(iOS 16.4, *)
    func qwillDismissEditMenuWithAnimator(_ w: ((_ webView: WKWebView, _ animator: any UIEditMenuInteractionAnimating) -> Void)?) -> Self {
        if let w = w as? ((WKWebView, Any) -> Void)? {
            self.qdelegateHelper.willDismissEditMenuWithAnimator = w
        } else {
            self.qdelegateHelper.willDismissEditMenuWithAnimator = nil
        }
        return self
    }
}
// MARK: JS 与 原生交互相关（桥）
public extension WKWebView {
    /// 加桥
    @discardableResult
    func qaddJSMessage(_ message: String) -> Self {
        self.qdelegateHelper.qaddJSMessageWith(names: [message])
        return self
    }
    /// 加桥
    @discardableResult
    func qaddJSMessages(_ messages: [String]) -> Self {
        self.qdelegateHelper.qaddJSMessageWith(names: messages)
        return self
    }
    /// 加桥之后，收到桥消息的回调
    @discardableResult
    func qdidReceiveJSMessage(_ r: ((_ controller: WKUserContentController, _ message: WKScriptMessage) -> Void)?) -> Self {
        self.qdelegateHelper.userContentControllerDidReceiveMessage = r
        return self
    }
    /// 移除桥
    @discardableResult
    func qremoveJSMessage(_ message: String) -> Self {
        self.configuration.userContentController.removeScriptMessageHandler(forName: message)
        return self
    }
    /// 移除桥
    @discardableResult
    func qremoveJSMessages(_ messages: [String]) -> Self {
        messages.forEach({self.configuration.userContentController.removeScriptMessageHandler(forName: $0)})
        return self
    }
}
// MARK: 获取网页内容
public extension WKWebView {
    ///  获取网页源码
    /// - Parameters:
    ///   - elementSelector: 指定标签内的源码   "#id"  ".class", 如：
    ///     <div id='customid', class = 'customclass'>xxx </div>
    ///     elementSelector = "div"  or "div#customid" or "div.customclass"
    ///     返回匹配的第一个结果
    ///   - reslut: 返回html源码
    func qgetOuterHtml(elementSelector: String? = nil, _ reslut: ((_ html: String?, _ error: Error?) -> Void)?) {
        var js: String
        if let e = elementSelector, !e.isEmpty {
            js = "document.querySelector('\(e)').outerHTML.toString()"
        } else {
            js = "document.documentElement.outerHTML.toString()"
        }
        self.evaluateJavaScript(js, completionHandler: { res, error in
            if let html = res as? String {
                reslut?(html, nil)
            } else if let e = error {
                reslut?(nil, e)
            }
        })
    }
    
    /// 获取网页内容text，不包含标签等等
    /// - Parameters:
    ///   - elementSelector: 指定标签内的源码   "#id"  ".class", 如：
    ///     <div id='customid', class = 'customclass'>xxx </div>
    ///     elementSelector = "div"  or "div#customid" or "div.customclass"
    ///     返回匹配的第一个结果
    ///   - reslut: 返回纯文本text
    func qgetInnerText(elementSelector: String? = nil, _ reslut: ((_ text: String?, _ error: Error?) -> Void)?) {
        var js: String
        if let e = elementSelector, !e.isEmpty {
            js = "document.querySelector('\(e)').innerText.toString()"
        } else {
            js = "document.documentElement.innerText.toString()"
        }
        self.evaluateJavaScript(js, completionHandler: { res, error in
            if let text = res as? String {
                reslut?(text, nil)
            } else if let e = error {
                reslut?(nil, e)
            }
        })
    }
}
