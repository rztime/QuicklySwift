//
//  QuicklyViewControllerAnimation.swift
//  QuicklySwift
//
//  Created by rztime on 2022/7/4.
//

import UIKit

public enum QControllerTransitionOperation {
    case push
    case pop
    case interactivePush // 手势出发的push
    case interactivePop // 手势触发的返回
}
/// 转场动画的逻辑
/// 1在转场过程中，通过transitionContext上下文，可以获取到toVC, fromVC,
/// 2通过将这个两个vc里的视图按照需求，添加到transitionContext里的containerView
/// 3经过一些列的动画实现动画效果
/// 4需要注意的是，在push pop动画完成之后，需要transitionContext.completeTransition(true) 这里true/false 表示动画完成或者取消
/// 5当交互式返回时，需要调用UIPercentDrivenInteractiveTransition的update(percet), cancel() finish()，用于交互过程的设置和动画完成之后是否取消和完成的设置，同样需要实现4里的设置
public extension UIViewController {
    /// push pop 时，自定义转场动画  可以参考相册预览的方法实例 [qphotoBrowserTrainsition]
    /// 需要在push vc前，设置在vc上
    /// - Parameters:
    ///   - duration: 转场动画时长
    ///   - enable: 是否支持操作， interactivePop 如果要支持，需要实现交互式返回pop的动画
    ///   - push: push时的动画
    ///   - pop: pop的动画
    @discardableResult
    func qtransitionAnimationWithDuration(_ duration: ((_ transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval)?,
                                          enable: ((_ operation: QControllerTransitionOperation) -> Bool)?,
                                          pushOrPop: ((_ transitionContext: UIViewControllerContextTransitioning, _ isPush: Bool) -> Void)?) -> Self {
        let animationvc : QuicklyViewControllerAnimation
        if let avc = self.children.first(where: {$0.isKind(of: QuicklyViewControllerAnimation.self)}) as? QuicklyViewControllerAnimation {
            animationvc = avc
        } else {
            animationvc = QuicklyViewControllerAnimation.init(target: self)
        }
        animationvc.animationDuration = duration
        animationvc.operationEnable = enable
        animationvc.animationPushOrPop = pushOrPop
        return self
    }

    /// 交互式返回pop的动画 ，需要自行完成动画，以及相应取消、进度设置、完成的动画
    /// - Parameters:
    ///   - begin: 动画开始
    ///   - change: 动画过程中
    ///   - finish: 动画结束
    @discardableResult
    func qtransitionWithInteractivePop(begin: ((_ interactiveInfo: QInteractivePushOrPopAnimation?) -> Void)?, change: ((_ interactiveInfo: QInteractivePushOrPopAnimation?) -> Void)?, finish: ((_ interactiveInfo: QInteractivePushOrPopAnimation?) -> Void)?) -> Self {
        var animationvc: QuicklyViewControllerAnimation?
        if let avc = self.children.first(where: {$0.isKind(of: QuicklyViewControllerAnimation.self)}) as? QuicklyViewControllerAnimation {
            animationvc = avc
        } else {
            animationvc = QuicklyViewControllerAnimation.init(target: self)
            animationvc?.operationEnable = { option in
                switch option {
                case .pop, .push, .interactivePush:
                    return false
                case .interactivePop:
                    return true
                }
            }
        }
        animationvc?.interactivePopAnimationBegin = begin
        animationvc?.interactivePopAnimationChanged = change
        animationvc?.interactivePopAnimationFinish = finish
        animationvc?.setupPanPopInteractive()
        return self
    }

    /// 交互式push的动画 ，需要自行完成动画，以及相应取消、进度设置、完成的动画
    /// - Parameters:
    ///   - pan: 对targetView进行拖拽，启动动画
    ///   - begin: 动画开始
    ///   - change: 动画过程中
    ///   - finish: 动画结束
    @discardableResult
    func qtransitionWithInteractivePush(with pan: UIPanGestureRecognizer, begin: ((_ interactiveInfo: QInteractivePushOrPopAnimation?) -> Void)?, change: ((_ interactiveInfo: QInteractivePushOrPopAnimation?) -> Void)?, finish: ((_ interactiveInfo: QInteractivePushOrPopAnimation?) -> Void)?) -> Self {
        var animationvc: QuicklyViewControllerAnimation?
        if let avc = self.children.first(where: {$0.isKind(of: QuicklyViewControllerAnimation.self)}) as? QuicklyViewControllerAnimation {
            animationvc = avc
        } else {
            animationvc = QuicklyViewControllerAnimation.init(target: self)
            animationvc?.operationEnable = { option in
                switch option {
                case .pop, .push, .interactivePop:
                    return false
                case .interactivePush:
                    return true
                }
            }
        }
        animationvc?.interactivePushAnimationBegin = begin
        animationvc?.interactivePushAnimationChanged = change
        animationvc?.interactivePushAnimationFinish = finish
        animationvc?.setupPanPushIteractive(pan)
        return self
    }
}
// MARK: - 相册预览的push pop 下滑手势返回方法
public extension UIViewController {
    
    /// 类似于相册预览的push pop 滑动返回手势的方法，最好在block中返回UIImageView
    /// - Parameters:
    ///   - index: 当前预览的index，
    ///   - previous: 相册列表的index所在位置的视图，最好返回UIImageView
    ///   - current: 预览大图的详情页的当前预览的视图，最好返回UIImageView
    @discardableResult
    func qphotoBrowserTrainsition(index: (() -> Int)?, previous: ((_ index: Int) -> UIView?)?, current: ((_ index: Int) -> UIView?)?) -> Self {
        /// 分两类实现，第一类 push 和 pop单独实现，
        /// push时：fromVC 跳转到toVC的大图，先把fromVC当前点击的UIImageView找到，并添加到上下文，然后动画移动到toVC时，UIImageView应该在的位置
        /// pop时，和push相反
        self.qtransitionAnimationWithDuration { transitionContext in
            return 0.3
        } enable: { operation in
            switch operation {
            case .push, .pop, .interactivePop:
                return true
            case .interactivePush:
                return false
            }
        } pushOrPop: { transitionContext, isPush in
            /// 找到fromVC 和toVC， 将toView加到上下文，如果不加，那么push或者pop将不会成功
            let fromVC = transitionContext.viewController(forKey: .from)
            let toVC = transitionContext.viewController(forKey: .to)
            let fromView = fromVC?.view ?? .init()
            let contentView = transitionContext.containerView
            let toview = toVC?.view ?? .init()
            contentView.addSubview(toview)
            // 找到动画前后两个视图from和to
            let idx = index?() ?? 0
            var from: UIView?
            var to: UIView?
            if isPush {  // 从当前view跳转到下一页的view，先找到当前view，以及下一个view，然后将其转换为图片，设置frame转换，完成之后移除，
                toview.isHidden = true
                from = previous?(idx)
                to = current?(idx)
            } else {
                // 从当前view跳回到上一页的view，先找到当前view，以及上一页的view，
                // 将上一页整体当做背景，然后将当前view和上一页的view做一个动画移动
                fromView.isHidden = true
                from = current?(idx)
                to = previous?(idx)
            }
            guard let from = from, let to = to else {
                // 如果两个视图有一个不存在，则按照正常push pop的方式动画
                toview.isHidden = false
                fromView.isHidden = false
                if isPush {
                    contentView.qbody([fromView, toview])
                    toview.frame = .init(x: toview.frame.width, y: 0, width: toview.frame.width, height: toview.frame.height)
                    fromView.frame = .qfull
                } else {
                    contentView.qbody([toview, fromView])
                    fromView.frame = .qfull
                    toview.frame = .init(x: -100, y: 0, width: fromView.frame.width, height: fromView.frame.height)
                }
                UIView.animate(withDuration: 0.3, delay: 0, options: .transitionCrossDissolve) {
                    if isPush {
                        toview.frame = .qfull
                        fromView.frame = .init(x: -100, y: 0, width: fromView.frame.width, height: fromView.frame.height)
                    } else {
                        toview.frame = .qfull
                        fromView.frame = .init(x: toview.frame.width, y: 0, width: toview.frame.width, height: toview.frame.height)
                    }
                } completion: { _ in
                    transitionContext.completeTransition(true)
                }
                return
            }
            /// 找到from和to 的位置
            var fromframe = from.convert(from.bounds, to: qappKeyWindow)
            let toframe = to.convert(to.bounds, to: qappKeyWindow)
            if fromframe.equalTo(.zero) {
                fromframe = .init(origin: toframe.qcenter, size: .zero)
            }
            /// 建一个UIimageView，整个动画就是把这个UIImageView从from位置移动到to位置
            let fromImage = (from as? UIImageView)?.image ?? from.qtoImage()
            let imageView = UIImageView.init(image: fromImage).qframe(fromframe)
            if isPush {
                imageView.qcontentMode(from.contentMode)
            } else {
                imageView.qcontentMode(to.contentMode)
            }
            contentView.addSubview(imageView)
            
            UIView.animate(withDuration: 0.3, delay: 0, options: .transitionCrossDissolve) {
                imageView.frame = toframe
            } completion: { _ in
                imageView.removeFromSuperview()
                toview.isHidden = false
                fromView.isHidden = false
                transitionContext.completeTransition(true)
            }
        }
        /// 第二类，手势滑动界面时，返回界面
        /// 第一步在开始时，将toView加到上下文，以及将当前view加到上下文
        /// 在移动过程中，将当前view通过移动进行位移和缩放设置
        /// 当手势结束时，通过百分比，判断是否需要成功pop
        self.qtransitionWithInteractivePop { interactiveInfo in
            // 开始时，找到fromview，然后把fromeView转成一个新的UIImageView，把它通过手势在上下文里移动、缩放
            let from = interactiveInfo?.transitionContext?.viewController(forKey: .from)
            let to = interactiveInfo?.transitionContext?.viewController(forKey: .to)
            let toView = to?.view ?? .init()
            let bg = interactiveInfo?.backgoundView ?? .init() // 加一个渐变的背景
            interactiveInfo?.toView = toView
            interactiveInfo?.transitionContext?.containerView.addSubview(toView)
            interactiveInfo?.transitionContext?.containerView.addSubview(bg)

            let idx = index?() ?? 0
            let fromView = (current?(idx) ?? from?.view) ?? .init()
            let fromFrame = fromView.convert(fromView.bounds, to: qappKeyWindow)
            let imageView = UIImageView.init(image: fromView.qtoImage()).qframe(fromFrame).qcontentMode(fromView.contentMode)
            interactiveInfo?.fromView = imageView
            interactiveInfo?.viewCenter = imageView.center
            interactiveInfo?.transitionContext?.containerView.addSubview(imageView)
        } change: { interactiveInfo in
            // 移动并缩放，以及设置手势交互返回的百分比
            let pan = interactiveInfo?.panGesture ?? .init()
            let trans = pan.translation(in: pan.view)
            var percet = 1 - abs(trans.y / qscreenheight)
            percet = min(1, max(0, percet))
            interactiveInfo?.update(percet)
            interactiveInfo?.backgoundView.alpha = percet
            let center = interactiveInfo?.viewCenter ?? .zero
            interactiveInfo?.fromView?.center = .init(x: center.x + trans.x * percet, y: center.y + trans.y)
            interactiveInfo?.fromView?.qtransform(scale: percet, percet)
        } finish: { interactiveInfo in
            /// 手势结束的时候，通过百分比来确认是否pop成功，
            let pan = interactiveInfo?.panGesture ?? .init()
            let trans = pan.translation(in: pan.view)
            var percet = 1 - abs(trans.y / qscreenheight)
            percet = min(1, max(0, percet))
            if percet > 0.9 { // 移动过小，判定pop取消
                UIView.animate(withDuration: 0.3, delay: 0, options: .transitionCrossDissolve) {
                    interactiveInfo?.fromView?.center = interactiveInfo?.viewCenter ?? .zero
                    interactiveInfo?.fromView?.qtransform(scale: 1, 1)
                } completion: { _ in
                    interactiveInfo?.cancel()
                    interactiveInfo?.transitionContext?.completeTransition(false)
                    interactiveInfo?.fromView?.removeFromSuperview()
                    interactiveInfo?.backgoundView.removeFromSuperview()
                }
            } else {
                // pop 成功
                let idx = index?() ?? 0
                let toFrame: CGRect
                if let toView = previous?(idx) {
                    toFrame = toView.convert(toView.bounds, to: qappKeyWindow)
                    interactiveInfo?.fromView?.qcontentMode(toView.contentMode)
                } else {
                    let fromFrame = interactiveInfo?.fromView?.frame ?? .zero
                    if fromFrame.qcenter.y > CGRect.qfull.qcenter.y {
                        toFrame = .init(x: fromFrame.origin.x, y: CGRect.qfull.height, width: fromFrame.width, height: fromFrame.height)
                    } else {
                        toFrame = .init(x: fromFrame.origin.x, y: -fromFrame.height, width: fromFrame.width, height: fromFrame.height)
                    }
                }
                UIView.animate(withDuration: 0.3, delay: 0, options: .transitionCrossDissolve) {
                    interactiveInfo?.fromView?.frame = toFrame
                } completion: { _ in
                    interactiveInfo?.finish()
                    interactiveInfo?.transitionContext?.completeTransition(true)
                    interactiveInfo?.fromView?.removeFromSuperview()
                    interactiveInfo?.backgoundView.removeFromSuperview()
                }
            }
        }
        return self
    }
}
/// UIViewController Push Pop时，动画的设置，实现的协议和代理
/// 转场动画的逻辑：
/// 1.通过设置navigationController.delegate = QuicklyViewControllerAnimation
/// 2.在触发push pop 或者 交互式返回时， 先走UINavigationControllerDelegate代理，
/// navigationController(_ navigationController: , animationControllerFor operation: , from fromVC: , to toVC: ) -> UIViewControllerAnimatedTransitioning?
/// 如果return nil，则表示不走代理，由系统原生实现push pop
/// 如果return 不为空，走
/// navigationController(_ navigationController: , interactionControllerFor animationController: ) -> UIViewControllerInteractiveTransitioning?
/// 判断是否需要交互，通过交互，来进行push pop的动画方法
/// 3.如果有动画，则走UIViewControllerAnimatedTransitioning，通过上下文，来实现push pop动画
/// 4.如果有交互动画，则走UIPercentDrivenInteractiveTransition来通过上下文，以及手势实现动画
///
/// 这里只实现了push pop 以及返回的手势动画处理，push的动画手势暂没有写
open class QuicklyViewControllerAnimation: UIViewController {
    /// 是否支持动画
    public var operationEnable: ((_ operation: QControllerTransitionOperation) -> Bool)?
    // MARK: - push pop时，配置
    /// push pop时间的回调
    public var animationDuration: ((_ transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval)?
    /// push或者pop动画回调
    public var animationPushOrPop: ((_ transitionContext: UIViewControllerContextTransitioning, _ isPush: Bool) -> Void)?
    /// push pop 时，当前操作类型
    private var operation: QControllerTransitionOperation = .push
    
    // MARK: - 交互式返回时，动画配置
    /// 交互式pop返回动画
    public lazy var interactivePopAnimation: QInteractivePushOrPopAnimation? = .init()
    /// 交互式pop返回，开始时的回调
    public var interactivePopAnimationBegin: ((_ interactive: QInteractivePushOrPopAnimation?) -> Void)? {
        didSet {
            self.interactivePopAnimation?.interactiveAnimationBegin = interactivePopAnimationBegin
        }
    }
    /// 交互式pop返回，移动过程中的回调
    public var interactivePopAnimationChanged: ((_ interactive: QInteractivePushOrPopAnimation?) -> Void)?
    /// 交互式返回，移动手势结束之后的回调
    public var interactivePopAnimationFinish: ((_ interactive: QInteractivePushOrPopAnimation?) -> Void)?
     
    // MARK: - 交互式push时，动画配置
    /// 交互式pop返回动画
    public lazy var interactivePushAnimation: QInteractivePushOrPopAnimation? = .init()
    /// 交互式pop返回，开始时的回调
    public var interactivePushAnimationBegin: ((_ interactive: QInteractivePushOrPopAnimation?) -> Void)? {
        didSet {
            self.interactivePushAnimation?.interactiveAnimationBegin = interactivePushAnimationBegin
        }
    }
    /// 交互式pop返回，移动过程中的回调
    public var interactivePushAnimationChanged: ((_ interactive: QInteractivePushOrPopAnimation?) -> Void)?
    /// 交互式返回，移动手势结束之后的回调
    public var interactivePushAnimationFinish: ((_ interactive: QInteractivePushOrPopAnimation?) -> Void)?
    
    weak var target: UIViewController?

    public init(target: UIViewController) {
        super.init(nibName: nil, bundle: nil)
        // 主线程放置，是为了避免在push之前，target先执行了viewDidLoad
        target.addChild(self)
        DispatchQueue.main.async {
            target.view.addSubview(self.view)
            self.view.isHidden = true
            
            target.qdidpop { [weak self] in
                self?.target?.children.first(where: {$0.isKind(of: QuicklyViewControllerAnimation.self)})?.removeFromParent()
            }
        }
        self.target = target
        qAppFrame.navigationController?.delegate = self
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let res = self.operationEnable?(.pop), res == true {
            qAppFrame.navigationController?.delegate = self
        } else if let res = self.operationEnable?(.interactivePop), res == true {
            qAppFrame.navigationController?.delegate = self
        } else {
            qAppFrame.navigationController?.delegate = nil
        }
    }
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        qAppFrame.navigationController?.delegate = nil
    }
    deinit {
        qAppFrame.navigationController?.delegate = nil
    }
    /// 交互式返回的设置
    open func setupPanPopInteractive() {
        if let enable = self.operationEnable?(.interactivePop), enable == true  {
            target?.view.qpanNumberof(touches: 1, max: 1) { [weak self] view, pan in
                switch pan.state {
                case .possible: break
                case .began:
                    self?.interactivePopAnimation?.panGesture = pan
                    qAppFrame.popViewController(animated: true)
                case .changed:
                    self?.interactivePopAnimationChanged?(self?.interactivePopAnimation)
                case .ended, .cancelled, .failed:
                    self?.interactivePopAnimationFinish?(self?.interactivePopAnimation)
                    self?.interactivePopAnimation?.panGesture = nil
                @unknown default:
                    break
                }
            }
        } else {
            target?.view.qremovePanGesture(touches: 1, max: 1)
        }
    }
    // 交互式push的设置
    open func setupPanPushIteractive(_ pan: UIPanGestureRecognizer) {
        self.interactivePushAnimation?.panGesture = pan
        pan.removeTarget(self, action: #selector(pushPanAction(_:)))
        pan.addTarget(self, action: #selector(pushPanAction(_:)))
    }
    @objc open func pushPanAction(_ pan: UIPanGestureRecognizer) {
        switch pan.state {
        case .possible: break
        case .began:
            self.interactivePushAnimation?.panGesture = pan
        case .changed:
            self.interactivePushAnimationChanged?(self.interactivePushAnimation)
        case .ended, .cancelled, .failed:
            self.interactivePushAnimationFinish?(self.interactivePushAnimation)
            self.interactivePushAnimation?.panGesture = nil
        @unknown default:
            break
        }
    }
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension QuicklyViewControllerAnimation: UIViewControllerAnimatedTransitioning {
    /// pop push时的动画时长
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.animationDuration?(transitionContext) ?? 0.3
    }
    /// push pop时的动画，交互式返回时，不会调用
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch self.operation {
        case .push:
            if let animation = self.animationPushOrPop, let enable = self.operationEnable?(.push), enable == true {
                animation(transitionContext, true)
                return
            }
        case .pop:
            if let animation = self.animationPushOrPop, let enable = self.operationEnable?(.pop), enable == true {
                animation(transitionContext, false)
                return
            }
        case .interactivePop, .interactivePush:
            return
        }
        guard let to = transitionContext.viewController(forKey: .to),
              let from = transitionContext.viewController(forKey: .from) else { return }
        
        let toView = UIImageView.init(image: to.view.qtoImage()).qframe(.qfull)
        let fromView = UIImageView.init(image: from.view.qtoImage()).qframe(.qfull)
        switch self.operation {
        case .push:
            var rect = CGRect.qfull
            rect.origin.x = rect.width
            toView.frame = rect
            transitionContext.containerView.addSubview(fromView)
            transitionContext.containerView.addSubview(toView)
        case .pop:
            transitionContext.containerView.addSubview(toView)
            transitionContext.containerView.addSubview(fromView)
        case .interactivePop, .interactivePush:
            break
        }
        transitionContext.containerView.addSubview(to.view)
        to.view.isHidden = true
        let timer = self.transitionDuration(using: transitionContext)
        UIView.animate(withDuration: timer, delay: 0, options: .transitionCrossDissolve) {
            switch self.operation {
            case .push:
                toView.frame = CGRect.qfull
            case .pop:
                var rect = CGRect.qfull
                rect.origin.x = rect.width
                fromView.frame = rect
            case .interactivePop, .interactivePush:
                break
            }
        } completion: { _ in
            toView.removeFromSuperview()
            fromView.removeFromSuperview()
            to.view.isHidden = false
            from.view.isHidden = false
            transitionContext.completeTransition(true)
        }
    }
}
extension QuicklyViewControllerAnimation: UINavigationControllerDelegate {
    /// 通过operation 判断push pop 交互式返回，是否需要自定义动画
    /// 如果返回self，则表示自定义动画
    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .none:
            break
        case .push:
            self.operation = .push
            if toVC.isEqual(target) {
                if let enable = self.operationEnable?(.push), enable == true {
                    return self
                }
                if let enable = self.operationEnable?(.interactivePush), enable == true, let _ = self.interactivePushAnimation?.panGesture {
                    self.operation = .interactivePush
                    return self
                }
            }
        case .pop:
            self.operation = .pop
            if fromVC.isEqual(target) {
                if let enable = self.operationEnable?(.pop), enable == true {
                    return self
                }
                if let enable = self.operationEnable?(.interactivePop), enable == true, let _ = self.interactivePopAnimation?.panGesture {
                    self.operation = .interactivePop
                    return self
                }
            }
        @unknown default:
            break
        }
        return nil
    }
    /// 如果返回 interactivepopAnimation 则表示交互式返回时，会使用自定义动画
    public func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if (self.operation == .interactivePop || self.operation == .pop), let enable = self.operationEnable?(.interactivePop), enable == true, let _ = self.interactivePopAnimation?.panGesture {
            return self.interactivePopAnimation
        }
        if (self.operation == .interactivePush || self.operation == .push), let enable = self.operationEnable?(.interactivePush), enable == true, let _ = self.interactivePushAnimation?.panGesture {
            return self.interactivePushAnimation
        }
        self.interactivePopAnimation?.panGesture = nil
        self.interactivePushAnimation?.panGesture = nil
        return nil
    }
}
/// 用于交互式返回时的协议
open class QInteractivePushOrPopAnimation: UIPercentDrivenInteractiveTransition {
    /// 交互式返回时，记录的手势，当手势不存在时，将用于判断不使用交互式返回
    open weak var panGesture: UIPanGestureRecognizer?
    /// 交互式返回时的上下文
    open var transitionContext: UIViewControllerContextTransitioning?
    /// 交互式返回时，当此协议生效并开始调用时，触发此回调
    open var interactiveAnimationBegin: ((_ interactive: QInteractivePushOrPopAnimation?) -> Void)?
    /// 用于返回时，加一层渐变层背景
    open lazy var backgoundView: UIView = .init().qbackgroundColor(.black.withAlphaComponent(0.9)).qtag(100).qframe(.qfull)
    /// 用于在返回时，持有手势动画的view
    open weak var fromView: UIView?
    /// 用于在push时，持有view
    open weak var toView: UIView?
    /// 记录原始位置中心
    open var viewCenter: CGPoint = .zero
    
    open override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        self.interactiveAnimationBegin?(self)
    }
}
