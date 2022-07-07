//
//  TransitionOneViewController.swift
//  QuicklySwift_Example
//
//  Created by rztime on 2022/7/4.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import QuicklySwift

class TransitionOneViewController: UIViewController {
    let imageView = UIImageView.init(image: UIImage.init(named: "1111"))

    let imageView1 = UIImageView.init(image: UIImage.init(named: "1111"))
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.view.qbody([
            imageView.qmakeConstraints({ make in
                make.centerY.equalToSuperview().inset(-150)
                make.centerX.equalToSuperview()
                make.size.equalTo(100)
            }),
            UILabel().qtext("点击 push pop 跳转 相册预览功能").qmakeConstraints({ make in
                make.top.equalTo(self.imageView.snp.bottom).offset(4)
                make.centerX.equalTo(self.imageView)
            }),
            
            imageView1.qmakeConstraints({ make in
                make.centerY.equalToSuperview().inset(150)
                make.centerX.equalToSuperview()
                make.size.equalTo(100)
            }),
            
            UILabel().qtext("拖拽图片 push pop 跳转").qmakeConstraints({ make in
                make.top.equalTo(self.imageView1.snp.bottom).offset(4)
                make.centerX.equalTo(self.imageView1)
            }),
            
        ])
        
        imageView.qtap { [weak self] view in
            /// 仿相册预览
            let vc = TransitionTwoViewController()
            vc.qphotoBrowserTrainsition { [weak vc] in
                return vc?.currentIndex ?? 0
            } previous: { [weak self] index in
                return self?.targetView(index)
            } current: { [weak vc] index in
                return vc?.targetView(index)
            }
            qAppFrame.pushViewController(vc)
        }
        /// 拖拽进入 push
        imageView1.qpanNumberof(touches: 1, max: 1) { view, pan in
            if pan.state == .began {
                let vc = TransitionTwoViewController.init()
                vc.qtransitionWithInteractivePush(with: pan) { interactiveInfo in
                    let toVc = interactiveInfo?.transitionContext?.viewController(forKey: .to)
                    let toView = toVc?.view ?? .init()
                    toView.frame = .init(x: qscreenwidth, y: 0, width: qscreenwidth, height: qscreenheight)
                    interactiveInfo?.transitionContext?.containerView.qbody([toView])
                    interactiveInfo?.toView = toView
                    interactiveInfo?.viewCenter = toView.center
                } change: { interactiveInfo in
                    let pan = interactiveInfo?.panGesture ?? .init()
                    let trans = pan.location(in: pan.view)
                    var percet = abs(trans.x / qscreenwidth)
                    percet = min(1, max(0, percet))
                    interactiveInfo?.update(percet)
                    let center = interactiveInfo?.viewCenter ?? .zero
                    interactiveInfo?.toView?.center = .init(x: center.x + trans.x * 2, y: center.y)
                } finish: { interactiveInfo in
                    let pan = interactiveInfo?.panGesture ?? .init()
                    let trans = pan.location(in: pan.view)
                    var percet = abs(trans.x / qscreenwidth)
                    percet = min(1, max(0, percet))
                    if percet < 0.2 {
                        UIView.animate(withDuration: 0.3, delay: 0, options: .transitionCrossDissolve) {
                            interactiveInfo?.toView?.center = interactiveInfo?.viewCenter ?? .zero
                        } completion: { _ in
                            interactiveInfo?.toView?.removeFromSuperview()
                            interactiveInfo?.cancel()
                            interactiveInfo?.transitionContext?.completeTransition(false)
                        }
                    } else {
                        UIView.animate(withDuration: 0.3, delay: 0, options: .transitionCrossDissolve) {
                            interactiveInfo?.toView?.center = CGRect.qfull.qcenter
                        } completion: { _ in
                            interactiveInfo?.finish()
                            interactiveInfo?.transitionContext?.completeTransition(true)
                        }
                    }
                }

                qAppFrame.pushViewController(vc)
            }
        }
    }
    func targetView(_ index: Int) -> UIView? {
        return self.imageView
    }
}
