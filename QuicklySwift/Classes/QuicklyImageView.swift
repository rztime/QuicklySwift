//
//  QuicklyImageView.swift
//  QuicklySwift
//
//  Created by rztime on 2022/6/2.
//

import UIKit

public extension UIImageView {
    /// 设置图片
    @discardableResult
    func qimage(_ image: UIImage) -> Self {
        self.image = image
        return self
    }
}
