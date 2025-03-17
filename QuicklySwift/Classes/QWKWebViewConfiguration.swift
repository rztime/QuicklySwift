//
//  QWKWebViewConfiguration.swift
//  QuicklySwift
//
//  Created by rztime on 2025/3/10.
//

import UIKit
import WebKit

public extension WKWebViewConfiguration {
    @discardableResult
    func qprocessPool(_ p: WKProcessPool) -> Self {
        self.processPool = p
        return self
    }
    @discardableResult
    func qpreferences(_ p: WKPreferences) -> Self {
        self.preferences = p
        return self
    }
    @discardableResult
    func quserContentController(_ c: WKUserContentController) -> Self {
        self.userContentController = c
        return self
    }
    @discardableResult
    func qwebsiteDataStore(_ d: WKWebsiteDataStore) -> Self {
        self.websiteDataStore = d
        return self
    }
    @discardableResult
    func qsuppressesIncrementalRendering(_ ir: Bool) -> Self {
        self.suppressesIncrementalRendering = ir
        return self
    }
    @discardableResult
    func qapplicationNameForUserAgent(_ ua: String?) -> Self {
        self.applicationNameForUserAgent = ua
        return self
    }
    @discardableResult
    func qallowsAirPlayForMediaPlayback(_ a: Bool) -> Self {
        self.allowsAirPlayForMediaPlayback = a
        return self
    }
    @discardableResult
    func qupgradeKnownHostsToHTTPS(_ u: Bool) -> Self {
        if #available(iOS 14.5, *) {
            self.upgradeKnownHostsToHTTPS = u
        }
        return self
    }
    @discardableResult
    func qmediaTypesRequiringUserActionForPlayback(_ m: WKAudiovisualMediaTypes) -> Self {
        self.mediaTypesRequiringUserActionForPlayback = m
        return self
    }
    @available(iOS 13.0, *)
    @discardableResult
    func qdefaultWebpagePreferences(_ d: WKWebpagePreferences) -> Self {
        self.defaultWebpagePreferences = d
        return self
    }
    @discardableResult
    func qlimitsNavigationsToAppBoundDomains(_ l: Bool) -> Self {
        if #available(iOS 14.0, *) {
            self.limitsNavigationsToAppBoundDomains = l
        }
        return self
    }
    @discardableResult
    func qallowsInlinePredictions(_ a: Bool) -> Self {
        if #available(iOS 17.0, *) {
            self.allowsInlinePredictions = a
        }
        return self
    }
    @discardableResult
    func qallowsInlineMediaPlayback(_ a: Bool) -> Self {
        self.allowsInlineMediaPlayback = a
        return self
    }
    @discardableResult
    func qselectionGranularity(_ s: WKSelectionGranularity) -> Self {
        self.selectionGranularity = s
        return self
    }
    @discardableResult
    func qallowsPictureInPictureMediaPlayback(_ a: Bool) -> Self {
        self.allowsPictureInPictureMediaPlayback = a
        return self
    }
    @discardableResult
    func qdataDetectorTypes(_ d: WKDataDetectorTypes) -> Self {
        self.dataDetectorTypes = d
        return self
    }
    @discardableResult
    func qignoresViewportScaleLimits(_ i: Bool) -> Self {
        self.ignoresViewportScaleLimits = i
        return self
    }
    @discardableResult
    func qsupportsAdaptiveImageGlyph(_ s: Bool) -> Self {
        if #available(iOS 18.0, *) {
            self.supportsAdaptiveImageGlyph = s
        }
        return self
    }
    @available(iOS 18.0, *)
    @discardableResult
    func qwritingToolsBehavior(_ w: UIWritingToolsBehavior) -> Self {
        self.writingToolsBehavior = w
        return self
    }
}
