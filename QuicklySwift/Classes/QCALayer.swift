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
    /// 设置部分圆角，可选某一个圆角
    @discardableResult
    func qcornerRadiusCustom(_ corners: UIRectCorner, radii: CGFloat, frame: CGRect) -> Self {
        let path = UIBezierPath.init(roundedRect: frame, byRoundingCorners: corners, cornerRadii: .init(width: radii, height: radii))
        let layer = CAShapeLayer.init()
        layer.frame = frame
        layer.path = path.cgPath
        self.mask = layer
        return self
    }
    /// 添加一个气泡
    /// - Parameters:
    ///   - corners: 气泡四角是否需要圆角
    ///   - radii: 圆角的size
    ///   - size: 气泡三角形的size
    ///   - location: 气泡三角形的位置
    ///   - color: 填充颜色
    @discardableResult
    func qairbubble(_ corners: UIRectCorner, radii: CGFloat, air size: CGSize, location: QairbubbleLocation, color: UIColor?) -> Self {
        self.sublayers?.filter({$0.isKind(of: CAShapeLayer.self)}).forEach({ layer in
            layer.removeFromSuperlayer()
        })
        let ra = CGSize.init(width: radii, height: radii)
        let path: UIBezierPath
        let p1: UIBezierPath = .init().qaddDelta(size: size, location: location, rectsize: self.bounds.size)
        switch location {
        case .up:
            path = .init(roundedRect: .init(x: 0, y: size.height, width: bounds.width, height: bounds.height - size.height), byRoundingCorners: corners, cornerRadii: ra)
        case .left:
            path = .init(roundedRect: .init(x: size.width, y: 0, width: bounds.width - size.width, height: bounds.height), byRoundingCorners: corners, cornerRadii: ra)
        case .bottom:
            path = .init(roundedRect: .init(x: 0, y: 0, width: bounds.width, height: bounds.height - size.height), byRoundingCorners: corners, cornerRadii: ra)
        case .right:
            path = .init(roundedRect: .init(x: 0, y: 0, width: bounds.width - size.width, height: bounds.height), byRoundingCorners: corners, cornerRadii: ra)
        }
        path.append(p1)
        
        let layer = CAShapeLayer.init()
        layer.frame = self.bounds
        layer.path = path.cgPath
        layer.fillColor = color?.cgColor
        self.insertSublayer(layer, at: 0)
        return self
    }
    @discardableResult
    /// 添加虚线
    /// - Parameters:
    ///   - color: 虚线颜色
    ///   - lineWidth: 虚线宽度
    ///   - height: 高度
    ///   - space: 虚线间隔
    ///   - direction: 划线方向
    func qdashLine(color: UIColor?, lineWidth: CGFloat, height: CGFloat, space: CGFloat, direction: NSLayoutConstraint.Axis) -> Self {
        self.sublayers?.filter({$0.isKind(of: CAShapeLayer.self)}).forEach({ layer in
            layer.removeFromSuperlayer()
        })
        let layer = CAShapeLayer()
        layer.bounds = self.bounds
        layer.position = self.bounds.qcenter
        layer.fillColor = color?.cgColor
        layer.strokeColor = color?.cgColor
        layer.lineJoin = .round
        layer.lineDashPhase = 0
        let path = CGMutablePath()
        switch direction {
        case .horizontal:
            layer.lineWidth = height
            layer.lineDashPattern = [NSNumber.init(value: lineWidth), NSNumber.init(value: space)]
            path.move(to: .init(x: 0, y: (self.bounds.height - height) / 2))
            path.addLine(to: .init(x: self.bounds.width, y: (self.bounds.height - height) / 2))
        case .vertical:
            layer.lineWidth = lineWidth
            layer.lineDashPattern = [NSNumber.init(value: height), NSNumber.init(value: space)]
            path.move(to: .init(x: (self.bounds.size.width - lineWidth) / 2, y: 0))
            path.addLine(to: .init(x: (self.bounds.size.width - lineWidth) / 2, y: self.bounds.height))
        @unknown default:
            break
        }
        layer.path = path
        self.addSublayer(layer)
        return self
    }
}

/// 气泡所在位置
/// x: y : 为0时，在view中间  大于0 时，frame.origin.x = x y = y; 小于0时，frame.origin.x = frame.width + x, y = frame.height + y;
/// 即 大于0 气泡位置以x、y计算；小于0，以view宽度减去x、y的值计算
public enum QairbubbleLocation {
    case up(x: CGFloat)
    case left(y: CGFloat)
    case bottom(x: CGFloat)
    case right(y: CGFloat)
}

public extension UIBezierPath {
    @discardableResult
    func qmove(to: CGPoint) -> Self {
        self.move(to: to)
        return self
    }
    @discardableResult
    func qaddLine(to: CGPoint) -> Self {
        self.addLine(to: to)
        return self
    }
    /// 添加三角形
    @discardableResult
    func qaddDelta(size delta: CGSize, location: QairbubbleLocation, rectsize: CGSize) -> Self {
        let star: CGPoint
        let next: CGPoint
        let end: CGPoint
        switch location {
        case .up(let x):
            let tempx = x == 0 ? (rectsize.width / 2) : (x > 0 ? x : rectsize.width + x)
            star = .init(x: tempx, y: 0)
            next = .init(x: tempx + delta.width / 2, y: delta.height)
            end = .init(x: tempx - delta.width / 2, y: delta.height)
        case .left(let y):
            let tempy = y == 0 ? (rectsize.height / 2) : (y > 0 ? y : rectsize.height + y)
            star = .init(x: 0, y: tempy)
            next = .init(x: delta.width, y: tempy - delta.height / 2)
            end = .init(x: delta.width, y: tempy + delta.height / 2)
        case .bottom(let x):
            let tempx = x == 0 ? (rectsize.width / 2) : (x > 0 ? x : rectsize.width + x)
            star = .init(x: tempx, y: rectsize.height)
            next = .init(x: tempx + delta.width / 2, y: rectsize.height - delta.height)
            end = .init(x: tempx - delta.width / 2, y: rectsize.height - delta.height)
        case .right(let y):
            let tempy = y == 0 ? (rectsize.height / 2) : (y > 0 ? y : rectsize.height + y)
            star = .init(x: rectsize.width, y: tempy)
            next = .init(x: rectsize.width - delta.width, y: tempy - delta.height / 2)
            end = .init(x: rectsize.width - delta.width, y: tempy + delta.height / 2)
        }
        return self.qmove(to: star).qaddLine(to: next).qaddLine(to: end)
    }
}
