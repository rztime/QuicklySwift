//
//  LabelTestViewController.swift
//  QuicklySwift_Example
//
//  Created by rztime on 2024/8/2.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit
import QuicklySwift
import RZColorfulSwift

class LabelTestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        let label = UILabel().qnumberOfLines(0)
        self.view.qbody([
            label.qmakeConstraints({ make in
                make.left.right.equalToSuperview()
                make.center.equalToSuperview()
            })
        ])
        label.rz.colorfulConfer { confer in
            confer.text("哈哈哈")?.font(.systemFont(ofSize: 16))
            confer.text("啊啊啊")?.font(.systemFont(ofSize: 16)).textColor(.red)
            confer.text("\n")
            
            confer.text("哈哈哈")?.font(.systemFont(ofSize: 16))
            confer.text("啊啊啊")?.font(.systemFont(ofSize: 16)).textColor(.red)
            confer.text("\n")
            
            confer.text("哈哈哈")?.font(.systemFont(ofSize: 16))
            confer.text("啊啊啊")?.font(.systemFont(ofSize: 16)).textColor(.red)
            confer.text("\n")
            
            confer.text("哈哈哈")?.font(.systemFont(ofSize: 16))
            confer.text("啊啊啊")?.font(.systemFont(ofSize: 16)).textColor(.red)
            confer.text("\n")
            
            confer.text("哈哈哈")?.font(.systemFont(ofSize: 16))
            confer.text("啊啊啊")?.font(.systemFont(ofSize: 16)).textColor(.red)
            confer.text("\n")
            
            confer.text("哈哈哈")?.font(.systemFont(ofSize: 16))
            confer.text("啊啊啊")?.font(.systemFont(ofSize: 16)).textColor(.red)
            confer.text("\n")
            
            confer.text("哈哈哈")?.font(.systemFont(ofSize: 16))
            confer.text("啊啊啊")?.font(.systemFont(ofSize: 16)).textColor(.red)
            confer.text("\n")
            
            confer.text("哈哈哈")?.font(.systemFont(ofSize: 16))
            confer.text("啊啊啊")?.font(.systemFont(ofSize: 16)).textColor(.red)
            confer.text("\n")
            
            confer.text("哈哈哈")?.font(.systemFont(ofSize: 16))
            confer.text("啊啊啊")?.font(.systemFont(ofSize: 16)).textColor(.red)
            confer.text("\n")
            
            confer.text("哈哈哈")?.font(.systemFont(ofSize: 16))
            confer.text("啊啊啊")?.font(.systemFont(ofSize: 16)).textColor(.red)
            confer.text("\n")
        }
        label.qtapNumberof(touches: 1, taps: 1) { view, tap in
            let point = tap.location(in: view)
            print("point:\(point)")
            let res = view.textAndRange(at: point)
            print("point:\(point) text:\(res?.text) range:\(res?.range)")
        }
    }
    
}

extension UILabel {
    func characterIndex(at point: CGPoint) -> Int? {
        guard let attributedText = self.attributedText else {
            return nil
        }

        let textStorage = NSTextStorage(attributedString: attributedText)
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: self.bounds.size)
        
        textContainer.lineFragmentPadding = 0.0
        textContainer.maximumNumberOfLines = self.numberOfLines
        textContainer.lineBreakMode = self.lineBreakMode
        
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        let glyphIndex = layoutManager.glyphIndex(for: point, in: textContainer)
        let characterIndex = layoutManager.characterIndexForGlyph(at: glyphIndex)
        
        return characterIndex
    }

    func textAndRange(at point: CGPoint) -> (text: String, range: NSRange)? {
        guard let characterIndex = self.characterIndex(at: point),
              let attributedText = self.attributedText else {
            return nil
        }
        
        let nsString = attributedText.string as NSString
        let range = nsString.rangeOfComposedCharacterSequence(at: characterIndex)
        let text = nsString.substring(with: range)
        
        return (text, range)
    }
}
