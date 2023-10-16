//
//  QAlertViewController.swift
//  QuicklySwift
//
//  Created by rztime on 2023/10/11.
//

import UIKit

public class QAlertViewController: UIViewController {
    public lazy var contentView = UIView.init(frame: .init(x: 0, y: qscreenheight, width: qscreenwidth, height: 300))
        .qcornerRadiusCustom(.allCorners, radii: 10)
        .qbackgroundColor(self.options.backgroundColor)
    
    public let stackView = QStackView.qbody(.vertical, 0, .fill, .equalSpacing, []).qframe(.init(x: 0, y: 0, width: qscreenwidth, height: 100))
    
    public var selectedIndex: Int?
    /// 小于0时，为取消
    public var finishHandle: ((Int) -> Void)?
    let options: QAlertControllerOptions
    public init(options: QAlertControllerOptions) {
        self.options = options
        super.init(nibName: nil, bundle: nil)
    }
    /// 显示一个弹窗，finishHandle  < 0 表示取消
    @discardableResult
    public class func show(options: QAlertControllerOptions, finishHandle: ((_ index: Int) -> Void)?) -> QAlertViewController {
        let vc = QAlertViewController.init(options: options)
        vc.finishHandle = finishHandle
        vc.modalPresentationStyle = .overCurrentContext
        qAppFrame.present(vc, animated: false, completion: nil)
        return vc
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(white: 0, alpha: 0.2)
        let contentHeight = qscreenheight - 200
        self.view.qbody([
            UIView().qmakeConstraints({ make in
                make.edges.equalToSuperview()
            }).qtap({ [weak self] view in
                if self?.options.dismissWhenTouchOutByAlert == true {
                    self?.contentShow(false)
                }
            }),
            contentView
                .qmakeConstraints({ make in
                    make.center.equalToSuperview()
                    make.width.equalTo(300)
                    make.height.lessThanOrEqualTo(contentHeight)
                })
        ])
        let textScrollView = UIScrollView()
        let actionScrollView = UIScrollView()
        contentView.qbody([
            textScrollView
                .qmakeConstraints({ make in
                    make.left.right.equalToSuperview()
                    make.top.equalToSuperview().inset(10)
                    make.height.equalTo(0)
                }),
            actionScrollView
                .qmakeConstraints({ make in
                    make.top.equalTo(textScrollView.snp.bottom).offset(10)
                    make.left.right.equalToSuperview()
                    make.height.equalTo(0)
                    make.bottom.equalToSuperview()
                })
        ])
        let textStack = VStackView.qbody([])
        /// 标题
        if let t = self.options.title, t.length > 0 {
            textStack.qbody([addLabel(title: t)])
        }
        /// 描述
        if let t = self.options.desc, t.length > 0 {
            textStack.qbody([addLabel(title: t)])
        }
        textScrollView.qbody([
            textStack.qmakeConstraints({ make in
                make.edges.equalToSuperview()
                make.width.equalTo(300)
            })
        ])
        
        /// 选项
        let actions = self.options.actions
        let count = actions.count + ((self.options.cancel?.length ?? 0) > 0 ? 1 : 0)
        if count < 3 {
            if let t = self.options.subDesc, t.length > 0 {
                textStack.qbody([addLabel(title: t)])
            }
            let actionStack = HStackView.qbody([]).qdistribution(.fillEqually)
            let acs = actions.enumerated().compactMap { [weak self] t -> UIView? in
                let v = self?.addLabel(title: t.element).qtag(t.offset).qtap { [weak self] view in
                    self?.selectedIndex = view.tag
                    self?.contentShow(false)
                }
                v?.qbody([
                    UIView().qmakeConstraints({ make in
                        make.top.equalToSuperview()
                        make.left.right.equalToSuperview()
                        make.height.equalTo(1)
                    }).qbackgroundColor(self?.options.separatorColor),
                ])
                if t.offset > 0 {
                    v?.qbody([
                        UIView().qmakeConstraints({ make in
                            make.left.equalToSuperview()
                            make.top.bottom.equalToSuperview()
                            make.width.equalTo(1)
                        }).qbackgroundColor(self?.options.separatorColor),
                    ])
                }
                return v
            }
            actionStack.qbody(acs)
            if let t = self.options.cancel, t.length > 0 {
                let c = addLabel(title: t).qtap { [weak self] view in
                    self?.contentShow(false)
                }
                c.qbody([
                    UIView().qmakeConstraints({ make in
                        make.left.equalToSuperview()
                        make.top.bottom.equalToSuperview()
                        make.width.equalTo(1)
                    }).qbackgroundColor(self.options.separatorColor),
                    UIView().qmakeConstraints({ make in
                        make.top.equalToSuperview()
                        make.left.right.equalToSuperview()
                        make.height.equalTo(1)
                    }).qbackgroundColor(self.options.separatorColor),
                ])
                actionStack.qbody([c])
            }
            actionScrollView.qbody([
                actionStack.qmakeConstraints({ make in
                    make.left.right.top.bottom.equalToSuperview()
                    make.width.equalTo(300)
                })
            ])
        } else {
            let actionStack = VStackView.qbody([])
            let acs = actions.enumerated().compactMap { [weak self] t -> UIView? in
                let v = self?.addLabel(title: t.element).qtag(t.offset).qtap { [weak self] view in
                    self?.selectedIndex = view.tag
                    self?.contentShow(false)
                }
                v?.qbody([
                    UIView().qmakeConstraints({ make in
                        make.top.equalToSuperview()
                        make.left.right.equalToSuperview()
                        make.height.equalTo(1)
                    }).qbackgroundColor(self?.options.separatorColor),
                ])
                return v
            }
            actionStack.qbody(acs)
            if let t = self.options.subDesc, t.length > 0 {
                actionStack.qbody([addLabel(title: t)])
            }
            if let t = self.options.cancel, t.length > 0 {
                let c = addLabel(title: t).qtap { [weak self] view in
                    self?.contentShow(false)
                }
                c.qbody([
                    UIView().qmakeConstraints({ make in
                        make.top.equalToSuperview()
                        make.left.right.equalToSuperview()
                        make.height.equalTo(1)
                    }).qbackgroundColor(self.options.separatorColor),
                ])
                actionStack.qbody([c])
            }
            actionScrollView.qbody([
                actionStack.qmakeConstraints({ make in
                    make.left.right.top.bottom.equalToSuperview()
                    make.width.equalTo(300)
                })
            ])
        }
        self.view.addSubview(contentView)
        textScrollView.qcontentSizeChanged { scrollView in
            scrollView.snp.updateConstraints { make in
                let height = min(scrollView.contentSize.height, contentHeight / 2.0)
                make.height.equalTo(height)
            }
        }
        actionScrollView.qcontentSizeChanged { scrollView in
            scrollView.snp.updateConstraints { make in
                let height = min(scrollView.contentSize.height, contentHeight / 2.0)
                make.height.equalTo(height)
            }
        }
        let color = self.options.gradientColor
        let view1 = UIView().qgradientColors([color.withAlphaComponent(0), color], locations: [0, 1], start: .init(x: 0.5, y: 0), end: .init(x: 0.5, y: 1))
        let view2 = UIView().qgradientColors([color.withAlphaComponent(0), color], locations: [0, 1], start: .init(x: 0.5, y: 0), end: .init(x: 0.5, y: 1))
        self.contentView.qbody([
            view1.qmakeConstraints({ make in
                make.bottom.left.right.equalTo(textScrollView)
                make.height.equalTo(15)
            }),
            view2.qmakeConstraints({ make in
                make.bottom.left.right.equalTo(actionScrollView)
                make.height.equalTo(15)
            }),
        ])
        
        self.contentView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        self.contentView.layoutIfNeeded()
        textScrollView.qcontentOffsetChanged { [weak view1] scrollView in
            view1?.isHidden = Int(scrollView.contentOffset.y + scrollView.frame.size.height) >= Int(scrollView.contentSize.height - 5)
        }
        actionScrollView.qcontentOffsetChanged { [weak view2] scrollView in
            view2?.isHidden = Int(scrollView.contentOffset.y + scrollView.frame.size.height) >= Int(scrollView.contentSize.height - 5)
        }
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        contentShow(true)
    }
    public func contentShow(_ show: Bool) {
        self.view.alpha = show ? 0 : 1
        UIView.animate(withDuration: 0.38, delay: 0) {
            self.contentView.transform = show ? CGAffineTransform(scaleX: 1, y: 1) : CGAffineTransform(scaleX: 0.1, y: 0.1)
            self.view.alpha = show ? 1 : 0
        } completion: { _ in
            if !show {
                self.dismiss(animated: false) {
                    self.finishHandle?(self.selectedIndex ?? -1)
                }
            }
        }
    }
    @discardableResult
    func addLabel(title: NSAttributedString) -> UIView {
        let v = UIView()
        v.qbody([
            UILabel()
                .qnumberOfLines(0)
                .qattributedText(title)
                .qmakeConstraints({ make in
                    make.left.right.equalToSuperview().inset(15)
                    make.top.bottom.equalToSuperview().inset(5)
                    make.height.greaterThanOrEqualTo(34)
                })
        ])
        return v
    }
}
