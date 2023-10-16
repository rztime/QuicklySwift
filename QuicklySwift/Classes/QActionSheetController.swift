//
//  QActionSheetController.swift
//  QuicklySwift
//
//  Created by rztime on 2023/1/19.
//

import UIKit

/// 自定义ActionSheetController，支持图文混排
public class QActionSheetController: UIViewController {
    public lazy var contentView = UIView.init(frame: .init(x: 0, y: qscreenheight, width: qscreenwidth, height: 0))
        .qcornerRadiusCustom([.topLeft, .topRight], radii: 15)
        .qbackgroundColor(self.options.backgroundColor)

    public let options: QAlertControllerOptions
    
    public var selectedIndex: Int?
    
    /// 小于0时，为取消
    public var finishHandle: ((Int) -> Void)?
    
    public init(options: QAlertControllerOptions) {
        self.options = options
        super.init(nibName: nil, bundle: nil)
    }
    /// 显示一个弹窗，finishHandle  < 0 表示取消
    @discardableResult
    public class func show(options: QAlertControllerOptions, finishHandle: ((_ index: Int) -> Void)?) -> QActionSheetController {
        let vc = QActionSheetController.init(options: options)
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
        self.view.qbody([
            UIView().qmakeConstraints({ make in
                make.edges.equalToSuperview()
            }).qtap({ [weak self] _ in
                if self?.options.dismissWhenTouchOut == true {
                    self?.contentShow(false)
                }
            }),
            contentView
                .qmakeConstraints({ make in
                    make.top.equalTo(self.view.snp.bottom)
                    make.centerX.equalToSuperview()
                    make.width.equalToSuperview()
                })
        ])
        let contentMaxHeight = (qscreenheight - 200 - qbottomSafeHeight - 54) / 2.0
        /// 标题 描述
        let textVs = VStackView.qbody([])
        if let t = self.options.title, t.length > 0 {
            textVs.qbody([addLabel(title: t)])
        }
        if let t = self.options.desc, t.length > 0 {
            textVs.qbody([addLabel(title: t)])
        }
        
        let color = self.options.gradientColor
        let spev1 = UIView().qgradientColors([color.withAlphaComponent(0), color], locations: [0, 1], start: .init(x: 0.5, y: 0), end: .init(x: 0.5, y: 1))
        let scrollView1 = UIScrollView()
        let v1 = UIView().qbody([
            scrollView1.qmakeConstraints({ make in
                make.edges.equalToSuperview()
            }).qbody([
                textVs.qmakeConstraints({ make in
                    make.edges.equalToSuperview()
                    make.width.equalTo(qscreenwidth)
                }),
            ]).qcontentSizeChanged(changed: { scrollView in
                scrollView.superview?.snp.makeConstraints { make in
                    let h = min(scrollView.contentSize.height, contentMaxHeight)
                    make.height.equalTo(h)
                }
            }),
            spev1.qmakeConstraints({ make in
                make.left.right.bottom.equalToSuperview()
                make.height.equalTo(15)
            })
        ])
        /// actions
        let actionVs = VStackView.qbody([])
        if self.options.actions.count > 0 {
            let vs: [UIView] = self.options.actions.enumerated().compactMap { [weak self] action -> UIView? in
                let v = self?.addLabel(title: action.element).qtag(action.offset).qtap({ [weak self] view in
                    self?.selectedIndex = view.tag
                    self?.contentShow(false)
                })
                if action.offset > 0 {
                    v?.qbody([
                        UIView().qmakeConstraints({ make in
                            make.left.right.top.equalToSuperview()
                            make.height.equalTo(1)
                        }).qbackgroundColor(self?.options.separatorColor)
                    ])
                }
                return v
            }
            actionVs.qbody(vs)
        }
        /// 底部描述
        if let t = self.options.subDesc, t.length > 0 {
            actionVs.qbody([addLabel(title: t)])
        }
        let spev2 = UIView().qgradientColors([color.withAlphaComponent(0), color], locations: [0, 1], start: .init(x: 0.5, y: 0), end: .init(x: 0.5, y: 1))
        let scrollView2 = UIScrollView()
        let v2 = UIView().qbody([
            scrollView2.qmakeConstraints({ make in
                make.edges.equalToSuperview()
            }).qbody([
                actionVs.qmakeConstraints({ make in
                    make.edges.equalToSuperview()
                    make.width.equalTo(qscreenwidth)
                })
            ]).qcontentSizeChanged(changed: { scrollView in
                scrollView.superview?.snp.makeConstraints { make in
                    let h = min(scrollView.contentSize.height, contentMaxHeight)
                    make.height.equalTo(h)
                }
            }),
            spev2.qmakeConstraints({ make in
                make.left.right.bottom.equalToSuperview()
                make.height.equalTo(15)
            })
        ])
        // 取消
        let cancelVs = VStackView.qbody([])
        if let t = self.options.cancel, t.length > 0 {
            cancelVs.qbody([
                UIView().qmakeConstraints({ make in
                    make.height.equalTo(10)
                }).qbackgroundColor(self.options.separatorColor),
                addLabel(title: t).qtap({ [weak self] view in
                    self?.contentShow(false)
                }),
            ])
        }
        cancelVs.qbody([
            UIView().qmakeConstraints({ make in
                make.height.equalTo(qbottomSafeHeight)
            })
        ])
        let stack = [v1, v2, cancelVs].qjoined(aixs: .vertical, spacing: 0, align: .fill, distribution: .equalSpacing)
        contentView.qbody([
            stack.qmakeConstraints({ make in
                make.edges.equalToSuperview()
            })
        ])
        self.view.layoutIfNeeded()
        scrollView1.qcontentOffsetChanged(changed: { [weak spev1] scrollView in
            spev1?.isHidden = Int(scrollView.contentOffset.y + scrollView.frame.size.height) >= Int(scrollView.contentSize.height - 5)
        })
        scrollView2.qcontentOffsetChanged(changed: { [weak spev2] scrollView in
            spev2?.isHidden = Int(scrollView.contentOffset.y + scrollView.frame.size.height) >= Int(scrollView.contentSize.height - 5)
        })
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        contentShow(true)
    }
    public func contentShow(_ show: Bool) {
        self.view.alpha = show ? 0 : 1
        self.contentView.snp.remakeConstraints { make in
            if show {
                make.bottom.equalToSuperview()
            } else {
                make.top.equalTo(self.view.snp.bottom)
            }
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
        }
        UIView.animate(withDuration: 0.38, delay: 0) {
            self.view.alpha = show ? 1 : 0
            self.view.layoutIfNeeded()
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
                    make.top.bottom.equalToSuperview().inset(10)
                    make.height.greaterThanOrEqualTo(30)
                })
        ])
        return v
    }
}

class QAlertControllerAcitonItem: UITableViewCell {
    let titleLabel = UILabel().qnumberOfLines(0)
    let line = UIView()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        self.contentView.qbody([
            titleLabel.qmakeConstraints({ make in
                make.left.right.equalToSuperview().inset(15)
                make.top.bottom.equalToSuperview().inset(10)
                make.height.greaterThanOrEqualTo(30)
            }),
            line.qmakeConstraints({ make in
                make.left.bottom.right.equalToSuperview()
                make.height.equalTo(1)
            })
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public class QAlertControllerOptions {
    public enum Options {
        /// 标题
        case title(String?)
        case titleAttributeText(NSAttributedString?)
        /// 标题下的描述
        case description(String?)
        case descriptionAttributeText(NSAttributedString?)
        /// 最后一个选项之后的描述
        case subDescription(String?)
        case subDescriptionAttributeText(NSAttributedString?)
        /// 选项
        case action(String?)
        case actionAttributeText(NSAttributedString?)
        /// 取消
        case cancel(String?)
        case cancelAttributeText(NSAttributedString?)
        /// 对齐方式
        case alignment(UIStackView.Alignment)
        /// 背景色
        case backgroundColor(UIColor)
        /// 点击界面外，关闭 // 默认true   仅对ActionSheet有效
        case dismissWhenTouchOut(Bool)
        /// 点击界面外，关闭 // 默认false，仅对Alert有效
        case dismissWhenTouchOutByAlert(Bool)
        /// 分割线颜色
        case separatorColor(UIColor)
        /// 渐变色
        case gradientColor(UIColor)
    }
    
    var title: NSAttributedString?
    var desc: NSAttributedString?
    var subDesc: NSAttributedString?
    var actions: [NSAttributedString] = []
    var cancel: NSAttributedString?
    var aligment: UIStackView.Alignment = .fill
    var backgroundColor: UIColor = .white
    var dismissWhenTouchOut: Bool = true
    var dismissWhenTouchOutByAlert: Bool = false
    var separatorColor: UIColor = .init(white: 0.8, alpha: 0.3)
    var gradientColor: UIColor = .black.withAlphaComponent(0.7)
    public init(options: [QAlertControllerOptions.Options]) {
        let p = NSMutableParagraphStyle.init()
        p.alignment = .center
        p.lineSpacing = 5
        let descDict: [NSAttributedString.Key: Any] = [.paragraphStyle: p,
                                                       .foregroundColor: UIColor.init(white: 0.5, alpha: 1),
                                                       .font: UIFont.systemFont(ofSize: 11)
        ]
        let dict: [NSAttributedString.Key: Any] = [.paragraphStyle: p,
                                                   .foregroundColor: UIColor.init(white: 0.3, alpha: 1),
                                                   .font: UIFont.systemFont(ofSize: 16)
        ]
        options.forEach { opt in
            switch opt {
            case .title(let text):
                if let text = text, !text.isEmpty {
                    self.title = NSAttributedString.init(string: text, attributes: dict)
                }
            case .titleAttributeText(let text):
                if let text = text, text.length != 0 {
                    self.title = text
                }
            case .description(let text):
                if let text = text, !text.isEmpty {
                    self.desc = NSAttributedString.init(string: text, attributes: descDict)
                }
            case .descriptionAttributeText(let text):
                if let text = text, text.length != 0 {
                    self.desc = text
                }
            case .subDescription(let text):
                if let text = text, !text.isEmpty {
                    self.subDesc = NSAttributedString.init(string: text, attributes: descDict)
                }
            case .subDescriptionAttributeText(let text):
                if let text = text, text.length != 0 {
                    self.subDesc = text
                }
            case .action(let text):
                if let text = text, !text.isEmpty {
                    self.actions.append(NSAttributedString.init(string: text, attributes: dict))
                }
            case .actionAttributeText(let text):
                if let text = text, text.length != 0 {
                    self.actions.append(text)
                }
            case .cancel(let text):
                if let text = text, !text.isEmpty {
                    self.cancel = NSAttributedString.init(string: text, attributes: dict)
                }
            case .cancelAttributeText(let text):
                if let text = text, text.length != 0 {
                    self.cancel = text
                }
            case .alignment(let alignment):
                self.aligment = alignment
            case .backgroundColor(let color):
                self.backgroundColor = color
            case .dismissWhenTouchOut(let diss):
                self.dismissWhenTouchOut = diss
            case .dismissWhenTouchOutByAlert(let diss):
                self.dismissWhenTouchOutByAlert = diss
            case .separatorColor(let color):
                self.separatorColor = color
            case .gradientColor(let color):
                self.gradientColor = color
            }
        }
    }
}

