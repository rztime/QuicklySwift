//
//  SearchBarTestViewController.swift
//  QuicklySwift_Example
//
//  Created by rztime on 2026/9/22.
//  Copyright © 2026 CocoaPods. All rights reserved.
//

import UIKit
import QuicklySwift

class SearchBarTestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let searchBar = UISearchBar()
            .qbackgroundColor(.lightGray)
            .qcornerRadius(10, true)
            .qplaceholder("Search...")
            .qshowsCancelButton(true)
            .qreturnKeyType(.done)
            .qshouldBeginEditing { searchBar in
                print("----")
                return true
            }
            .qshouldChangeText { searchBar, range, replaceText in
                print("---\(replaceText)")
                return true
            }
        self.view.qbody([
            searchBar.qmakeConstraints({ make in
                make.center.equalToSuperview()
                make.width.equalTo(300)
                make.height.equalTo(60)
            })
        ])
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
