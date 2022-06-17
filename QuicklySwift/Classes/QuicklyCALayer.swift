//
//  QuicklyCALayer.swift
//  QuicklySwift
//
//  Created by rztime on 2022/6/1.
//

import UIKit

public extension CALayer {
    /// 设置圆角
    @discardableResult
    func qcornerRadius(_ radius: CGFloat, _ maskToBounds: Bool = true) -> Self {
        self.cornerRadius = radius
        self.masksToBounds = maskToBounds
        return self
    }
    /// 设置边框
    @discardableResult
    func qborder(_ color: UIColor?, _ width: CGFloat) -> Self {
        self.borderColor = color?.cgColor
        self.borderWidth = width
        return self
    }
    /// 设置阴影
    @discardableResult
    func qshadow(_ color: UIColor?, _ offset: CGSize, radius: CGFloat, _ opacity: Float = 1) -> Self {
        self.shadowColor = color?.cgColor
        self.shadowOffset = offset
        self.shadowRadius = radius
        self.shadowOpacity = opacity
        return self
    }
}
public extension CALayer {
    /// 抖动
    /// - Parameters:
    ///   - time: 抖动一个周期时长
    ///   - value: 抖动弧度  0 - 360
    ///   - count: 重复次数
    @discardableResult
    func qshake(_ time: TimeInterval, _ value: Double, repeatcount: Float = MAXFLOAT) -> Self {
        let animation = CAKeyframeAnimation.init()
        animation.keyPath = "transform.rotation"
        let r = (value / 180.0 * .pi)
        animation.values = [0, r, 0, -r, 0]
        animation.duration = time
        animation.repeatCount = repeatcount
        //默认是true，切换到其他控制器再回来，动画效果会消失，需要设置成false，动画就不会停了
        animation.isRemovedOnCompletion = false
        animation.fillMode = .removed
        self.add(animation, forKey: "quicklyrotation")
        return self
    }
    /// 原地旋转动画，可循环 0 to 360，为旋转一圈
    /// - Parameters:
    ///   - from: 初始角度 0  360
    ///   - to: 结束角度
    ///   - duration: 一个周期时长
    ///   - repeatcount: 重复次数
    @discardableResult
    func qrotation(from: CGFloat, to: CGFloat, duration: TimeInterval, repeatcount: Float) -> Self {
        let rotationAnim = CABasicAnimation(keyPath: "transform.rotation.z")
        // 2.设置动画属性
        rotationAnim.fromValue = from * .pi / 180
        rotationAnim.toValue = to * Double.pi / 180
        rotationAnim.repeatCount = repeatcount
        rotationAnim.duration = duration
        rotationAnim.autoreverses = false
        //默认是true，切换到其他控制器再回来，动画效果会消失，需要设置成false，动画就不会停了
        rotationAnim.isRemovedOnCompletion = false
        self.add(rotationAnim, forKey: "quicklyrotation") // 给需要旋转的view增加动画
        return self
    }
    
    /// 转换成图片
    @discardableResult
    func qtoImage() -> UIImage? {
        var image: UIImage?
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        if let context = UIGraphicsGetCurrentContext() {
            self.render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        return image
    }
    /// 设置渐变色 （UILabel设置之后，文字将无法显示）
    /// - Parameters:
    ///   - colors: 颜色数组
    ///   - locations: 颜色对应的位置，个数与颜色数组个数匹配，否则会有额外的结果
    ///   - start: 起点
    ///   - end: 终点
    @discardableResult
    func qgradientColors(_ colors: [UIColor], locations: [NSNumber] = [0, 1], start: CGPoint, end: CGPoint) -> Self {
        var layer : CAGradientLayer
        if let oldlayer = self.sublayers?.first(where: {$0.isKind(of: CAGradientLayer.self)}) as? CAGradientLayer {
            layer = oldlayer
        } else {
            layer = .init()
        }
        layer.frame = self.bounds
        layer.colors = colors.map({$0.cgColor})
        layer.locations = locations
        layer.startPoint = start
        layer.endPoint = end
        self.insertSublayer(layer, at: 0)
        return self
    }
}
