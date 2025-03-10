//
//  QuicklyFileBrowser.swift
//  QuicklySwift
//
//  Created by rztime on 2023/2/14.
//

import UIKit
import QuickLook
/// 本地文件浏览器
public class QuicklyFileBrowser: UIViewController {
    let viewModel = QuicklyFileBrowserViewModel()
    let contentView = UIView().qbackgroundColor(.clear).qframe(.init(x: 0, y: qscreenheight, width: qscreenwidth, height: qscreenheight))
    let nav = QFileBrowserNav.init(frame: .init(x: 0, y: 0, width: qscreenwidth, height: 44)).qcornerRadiusCustom([.topLeft, .topRight], radii: 15)
    let navStackView = HStackView.qbody([])
    let tableViewBg = UIView()
    var tableViews: [UITableView] = []
    
    var selectedPath: String?
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .qhex(0x000000, a: 0.2)
        
        let navScrollView = UIScrollView().qbackgroundColor(.white)
        
        self.view.qbody([
            contentView.qbody([
                nav.qmakeConstraints({ make in
                    make.left.right.equalToSuperview()
                    make.top.equalToSuperview().inset(max(20, qstatusbarHeight))
                    make.height.equalTo(44)
                }),
                navScrollView.qmakeConstraints({ make in
                    make.left.right.equalToSuperview()
                    make.top.equalTo(self.nav.snp.bottom)
                    make.height.equalTo(44)
                }).qbody([
                    navStackView.qmakeConstraints({ make in
                        make.top.bottom.equalToSuperview()
                        make.height.equalTo(44)
                        make.left.right.equalToSuperview().inset(15)
                    })
                ]),
                
                tableViewBg.qmakeConstraints({ make in
                    make.left.right.bottom.equalToSuperview()
                    make.top.equalTo(navScrollView.snp.bottom)
                })
            ])
        ])
        contentView.qpanNumberof(touches: 1, max: 1) { [weak self] view, pan in
            switch pan.state {
            case .began:
                break
            case .changed:
                let point = pan.translation(in: view)
                let y = view.center.y + point.y
                view.center = .init(x: view.center.x, y: max(0, y))
            case .ended, .failed, .cancelled:
                if view.frame.minY >= 80 {
                    self?.back()
                } else {
                    self?.animation(show: true, finish: nil)
                }
            case .possible:
                self?.animation(show: true, finish: nil)
            @unknown default:
                self?.animation(show: true, finish: nil)
            }
            pan.setTranslation(.zero, in: view)
        }
        nav.backBtn.qtitle("取消").qtap { [weak self] _ in
            self?.back()
        }
        insetChildFolder(self.viewModel.folder)
    }
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if contentView.bounds != self.view.bounds {
            contentView.frame = self.view.bounds
            nav.snp.updateConstraints { make in
                make.top.equalToSuperview().inset(max(20, qstatusbarHeight))
            }
        }
    }
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.animation(show: true, finish: nil)
    }
    /// 后退
    func back() {
        if self.tableViews.count > 1 {
            nav.back()
            if navStackView.arrangedSubviews.count > 1, let last = navStackView.arrangedSubviews.last {
                navStackView.removeArrangedSubview(last)
            }
            let tableView = self.tableViews.removeLast()
            tableView.snp.remakeConstraints { make in
                make.left.equalTo(self.tableViewBg.snp.right)
                make.top.bottom.width.equalToSuperview()
            }
            UIView.animate(withDuration: 0.3, delay: 0) {
                self.tableViewBg.layoutIfNeeded()
            } completion: { _ in
                tableView.removeFromSuperview()
            }
        } else {
            self.animation(show: false) { [weak self] in
                self?.dismiss(animated: false)
            }
        }
    }
    /// 打开子文件夹
    func insetChildFolder(_ folder: QuicklyFileBrowserViewModel.FileFolder) {
        let folder = folder
        let tableView = UITableView.init(frame: .qfull, style: .plain).qbackgroundColor(.white)
        tableView
            .qheightForHeader({ section in
                if folder.childPaths.qisEmpty {
                    return 60
                } else {
                    return 0
                }
            })
            .qviewForHeader({ [weak self] tableView, section in
                if folder.childPaths.qisEmpty {
                    return UILabel().qtext("    ./文件夹为空").qfont(.systemFont(ofSize: 15)).qtap { [weak self] view in
                        self?.back()
                    }
                } else {
                    return nil
                }
            })
            .qnumberofRows { section in
                return folder.childPaths.count
            }
            .qheightForRow { indexPath in
                return 60
            }
            .qcell { tableView, indexPath in
                let cell = (tableView.dequeueReusableCell(withIdentifier: "cell") as? QuicklyFileCell) ?? QuicklyFileCell.init(style: .default, reuseIdentifier: "cell")
                cell.folder = folder.childPaths[qsafe: indexPath.row]
                let idx = indexPath.row
                cell.contentView.qlongpress(numberof: 1, minpress: 1, movement: 10) { [weak tableView] view, longpress in
                    if longpress.state == .began {
                        UIAlertController.qwith(title: "注意！！！", "文件可能是APP必要文件，请谨慎删除！！！", actions: ["删除"], cancelTitle: "取消") { index in
                            let folder = folder.childPaths.remove(at: idx)
                            FileManager.default.qdeleteFile(url: folder.path.qtoURL)
                            tableView?.reloadData()
                        }
                    }
                }
                return cell
            }
            .qdidSelectRow { [weak self] tableView, indexPath in
                guard let folder = folder.childPaths[qsafe: indexPath.row] else {
                    tableView.deselectRow(at: indexPath, animated: false)
                    return
                }
                if folder.isDirection {
                    self?.insetChildFolder(folder)
                } else if !folder.path.qisEmpty {
                    self?.selectedPath = folder.path
                    let vc = QLPreviewController.init()
                    vc.delegate = self
                    vc.dataSource = self
                    self?.present(vc, animated: true, completion: nil)
                }
            }
        func creatLabel(text: String?) -> UILabel {
            let label = UILabel.init()
            label.qfont(.systemFont(ofSize: 15)).qtextColor(.qhex(0x666666)).qtext(text)
            return label
        }
        self.tableViews.append(tableView)
        self.tableViewBg.qbody([tableView])
        if self.tableViews.count == 1 {
            nav.insetChildFolder(name: "文件浏览")
            tableView.frame = .init(x: 0, y: 0, width: qscreenwidth, height: self.tableViewBg.frame.height)
            self.navStackView.qbody([creatLabel(text: "../")])
        } else {
            nav.insetChildFolder(name: folder.name)
            tableView.frame = .init(x: qscreenwidth, y: 0, width: qscreenwidth, height: self.tableViewBg.frame.height)
            self.navStackView.qbody([creatLabel(text: "\(folder.name)/")])
        }
        UIView.animate(withDuration: 0.3, delay: 0) {
            tableView.frame = .init(x: 0, y: 0, width: qscreenwidth, height: self.tableViewBg.frame.height)
        } completion: { _ in
            tableView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
    }
    /// 显示控件
    func animation(show: Bool, finish:(() -> Void)?) {
        UIView.animate(withDuration: 0.38, delay: 0) {
            var frame = self.contentView.frame
            frame.origin.y = show ? 0 : qscreenheight
            self.contentView.frame = frame
        } completion: { _ in
            finish?()
        }
    }
}
public extension QuicklyFileBrowser {
    class func show() {
        let vc = QuicklyFileBrowser()
        vc.modalPresentationStyle = .overCurrentContext
        qAppFrame.present(vc, animated: false, completion: nil)
    }
}
extension QuicklyFileBrowser: QLPreviewControllerDelegate, QLPreviewControllerDataSource {
    public func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    public func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return NSURL.init(fileURLWithPath: self.selectedPath ?? "")
    }
}
class QFileBrowserNav: UIView {
    let backBtn: UIButton = .init(type: .custom).qfont(.systemFont(ofSize: 16)).qtitleColor(.qhex(0x333333))
    let rightBtn: UIButton = .init(type: .custom).qfont(.systemFont(ofSize: 16)).qtitleColor(.qhex(0x333333))
    
    var titleLabels: [UILabel] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.qbody([
            backBtn.qmakeConstraints({ make in
                make.left.equalToSuperview().inset(10)
                make.top.bottom.equalToSuperview()
                make.width.greaterThanOrEqualTo(44)
            }),
            rightBtn.qmakeConstraints({ make in
                make.right.equalToSuperview().inset(10)
                make.top.bottom.equalToSuperview()
                make.width.greaterThanOrEqualTo(44)
            })
        ])
        backBtn.titleLabel?.lineBreakMode = .byTruncatingTail
    }
    
    func insetChildFolder(name: String?) {
        let label = UILabel().qtextColor(.qhex(0x333333)).qfont(.systemFont(ofSize: 17)).qtext(name)
        self.titleLabels.append(label)
        self.qbody([
            label.qmakeConstraints({ make in
                make.center.equalToSuperview()
                make.left.greaterThanOrEqualTo(self.backBtn.snp.right).offset(10)
                make.right.greaterThanOrEqualTo(self.rightBtn.snp.left).offset(-10)
            })
        ])
        self.titleLabels.forEach({$0.isHidden = true})
        self.titleLabels.last?.isHidden = false
        let text = self.titleLabels[qsafe: -2]?.text ?? ""
        self.backBtn.qtitle(self.titleLabels.count <= 1 ? "取消" : "〈 \(text)")
    }
    func back() {
        if self.titleLabels.count > 1 {
            let lable = self.titleLabels.removeLast()
            lable.removeFromSuperview()
        }
        self.titleLabels.forEach({$0.isHidden = true})
        self.titleLabels.last?.isHidden = false
        let text = self.titleLabels[qsafe: -2]?.text ?? ""
        self.backBtn.qtitle(self.titleLabels.count <= 1 ? "取消" : "〈 \(text)")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class QuicklyFileBrowserViewModel {

    class FileFolder {
        var name: String = ""
        var path: String = ""
        var childPaths: [FileFolder] = []
        var isDirection: Bool = false
        
        init() { }
    }
    let folder: FileFolder = .init()
    
    init(path: String? = nil) {
        var p: URL
        if let url = path?.qtoURL {
            p = url
        } else {
            p = NSURL.fileURL(withPath: NSHomeDirectory())
        }
        folder.name = p.lastPathComponent
        folder.path = p.path
        var isDir: ObjCBool = false
        let isExit = FileManager.default.fileExists(atPath: p.path, isDirectory: &isDir)
        if isExit && isDir.boolValue{
            folder.isDirection = isDir.boolValue
            folder.childPaths = self.getChildFolder(path: p.path)
        }
    }
    
    func getChildFolder(path: String) -> [FileFolder] {
        let res = try? FileManager.default.contentsOfDirectory(at: NSURL.fileURL(withPath: path), includingPropertiesForKeys: [])
        let result = res?.compactMap({ [weak self] path -> FileFolder in
            let folder = FileFolder.init()
            folder.name = path.lastPathComponent
            folder.path = path.path
            var isDir: ObjCBool = false
            let isExit = FileManager.default.fileExists(atPath: path.path, isDirectory: &isDir)
            if isExit && isDir.boolValue {
                folder.isDirection = isDir.boolValue
                folder.childPaths = self?.getChildFolder(path: path.path) ?? []
            }
            return folder
        })
        return result ?? []
    }
}

class QuicklyFileCell: UITableViewCell {
    let imgView = UIImageView().qcornerRadius(4, true).qborder(.qhex(0xeeeeee), 1)
    let tagLabel: UILabel = .init().qadjustsFontSizeToFitWidth(true).qfont(.systemFont(ofSize: 11)).qtextAliginment(.center)
    let name: UILabel = .init().qfont(.systemFont(ofSize: 15))
    var isDirection: Bool = false
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.qbody([
            imgView.qmakeConstraints({ make in
                make.left.equalToSuperview().inset(15)
                make.centerY.equalToSuperview()
                make.size.equalTo(30)
            }),
            name.qmakeConstraints({ make in
                make.left.equalTo(self.imgView.snp.right).offset(10)
                make.centerY.equalToSuperview()
                make.right.equalToSuperview().inset(15)
            })
        ])
        imgView.qbody([
            tagLabel.qmakeConstraints({ make in
                make.left.right.equalToSuperview().inset(2)
                make.center.equalToSuperview()
            })
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var folder: QuicklyFileBrowserViewModel.FileFolder? {
        didSet {
            self.name.text = folder?.name
            self.isDirection = folder?.isDirection ?? false
            imgView.backgroundColor = isDirection ? .qhex(0x79cbf8) : .white
            self.accessoryType = isDirection ? .disclosureIndicator : .none
            self.tagLabel.isHidden = self.isDirection
            var tagText = "File"
            if !self.isDirection, let path = folder?.path {
                let url = NSURL.fileURL(withPath: path)
                tagText = url.pathExtension
            }
            self.tagLabel.text = tagText
        }
    }
}
