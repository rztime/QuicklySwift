//
//  AssetViewController.swift
//  QuicklySwift_Example
//
//  Created by rztime on 2025/4/7.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import UIKit
import QuicklySwift
import Photos
import PhotosUI

class AssetViewController: UIViewController {
    let videoBtn = UILabel().qtext("选视频")
    let imageBtn = UILabel().qtext("选图片")
    let imageView = UIImageView().qcontentMode(.scaleAspectFit)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        QuicklyAuthorization.result(with: .photoLibrary) { result in
            
        }
        self.view.backgroundColor = .white
        self.view.qbody([
            [videoBtn, imageBtn].qjoined(aixs: .vertical, spacing: 50, align: .fill, distribution: .equalSpacing)
                .qmakeConstraints({ make in
                    make.center.equalToSuperview()
                    make.width.equalTo(100)
                }),
            imageView.qmakeConstraints({ make in
                make.top.equalToSuperview().inset(qnavigationbarHeight)
                make.size.equalTo(200)
                make.centerX.equalToSuperview()
            })
        ])
        videoBtn.qtap { [weak self] view in
            UIImagePickerController.qpicker { picker in
                picker.mediaTypes = ["public.movie", "public.image"]
            } complete: { info in
                if #available(iOS 11.0, *) {
                    if let asset = info?[.phAsset] as? PHAsset {
                        asset.qimageData { progress in
                            
                        } complete: { data, suffix in
                            if let data = data {
                                self?.imageView.image = UIImage.init(data: data)
                                try? data.write(to: "/Users/rztime/Downloads/test.\(suffix)".qtoURL!)
                            }
                        }
                        asset.qconvertTo(.mp4) { p in
                            print("---p:\(p)")
                        } complete: { url, error in
                            print("---url:\(String(describing: url))")
                        }

                    }
                }
            }
        }
        imageBtn.qtap { _ in
            if #available(iOS 14, *) {
                PHPickerViewController.qpicker { config in
                    config.config.selectionLimit = 2
//                    config.config.filter = .images
                } complete: { result in
                    print("--- result:\(result.count)")
                }
            } else {
                // Fallback on earlier versions
            }
        }
    }
}
