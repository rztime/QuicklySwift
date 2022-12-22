//
//  GrayfloatVC2.swift
//  QuicklySwift_Example
//
//  Created by rztime on 2022/12/20.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import QuicklySwift

class GrayfloatVC2: UIViewController {
    
    let tableView = UITableView.init(frame: .zero, style: .plain)
    var rowCount: Int = 15
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.qbody([
            tableView.qmakeConstraints({ make in
                make.edges.equalToSuperview()
            })
        ])
       
        tableView.qnumberofRows { [weak self] section in
            return self?.rowCount ?? 0
        }.qheightForRow { indexPath in
            return 80
        }.qcell { tableView, indexPath in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? .init(style: .subtitle, reuseIdentifier: "cell")
            cell.textLabel?.text = "title \(indexPath.row)"
            cell.textLabel?.textColor = .blue
            cell.detailTextLabel?.text = "sub \(indexPath.row)"
            cell.detailTextLabel?.textColor = .green
            cell.accessoryType = .detailDisclosureButton
            return cell
        }
        tableView.qcontentSizeChanged { [weak self] tb in
            guard let tableView = self?.tableView, let self = self else { return }
            /// 只飘灰前10列，后边的正常显示
            var maxRow = min(10, self.rowCount - 1)
            maxRow = max(0, maxRow)
            let y = tableView.rectForRow(at: IndexPath.init(row: maxRow, section: 0)).maxY
            tableView.qgrayfloat(frame: .init(x: 0, y: 0, width: qscreenwidth, height: y))
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
