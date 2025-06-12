//
//  QUIImagePicker.swift
//  QuicklySwift
//
//  Created by rztime on 2025/4/17.
//

import UIKit
import PhotosUI

public extension UIImagePickerController {
    @discardableResult
    class func qpicker(config: ((_ picker: UIImagePickerController) -> Void)?, complete: ((_ info: [UIImagePickerController.InfoKey : Any]?) -> Void)?) -> Self? {
        let picker = UIImagePickerController()
        var helper: PHAssetDelegateHelper? = PHAssetDelegateHelper()
        helper?.didFinishPickingMedia = { picker, info in
            helper = nil
            picker.dismiss(animated: true)
            complete?(info)
        }
        helper?.didCancel = { picker in
            helper = nil
            picker.dismiss(animated: true)
            complete?(nil)
        }
        picker.qtagObject(helper)
        picker.delegate = helper
        picker.sourceType = .photoLibrary
        picker.mediaTypes = ["public.movie", "public.image"]
        config?(picker)
        DispatchQueue.main.async(execute: {
            qAppFrame.present(picker, animated: true, completion: nil)
        })
        return picker as? Self
    }
}

@available(iOS 14, *)
public extension PHPickerViewController {
    class QConfigura {
        public var config: PHPickerConfiguration = .init()
    }
    @discardableResult
    /// 选择，config里配置PHPickerConfiguration
    class func qpicker(config: ((_ config: QConfigura) -> Void)?, complete: ((_ results: [PHPickerResult]) -> Void)?) -> Self? {
        let c = QConfigura.init()
        c.config.filter = .any(of: [.images, .videos])//.images
        c.config.selectionLimit = 1
        config?(c)
        
        var helper: PHAssetDelegateHelper? = PHAssetDelegateHelper()
        helper?.didFinishPicking = { picker, results in
            helper = nil
            let picker = picker as? PHPickerViewController
            picker?.dismiss(animated: true)
            guard let results = results as? [PHPickerResult] else {
                complete?([])
                return
            }
            complete?(results)
        }
        let picker = PHPickerViewController(configuration: c.config)
        picker.delegate = helper
        DispatchQueue.main.async(execute: {
            qAppFrame.present(picker, animated: true, completion: nil)
        })
        return picker as? Self
    }
}

open class PHAssetDelegateHelper: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHPickerViewControllerDelegate {
    open var didFinishPickingMedia: ((_ picker: UIImagePickerController, _ info: [UIImagePickerController.InfoKey : Any]) -> Void)?
    open var didCancel: ((_ picker: UIImagePickerController) -> Void)?
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.didFinishPickingMedia?(picker, info)
    }
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.didCancel?(picker)
    }
    open var didFinishPicking:((_ picker: Any, _ results: [Any]) -> Void)?
    
    @available(iOS 14, *)
    public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        self.didFinishPicking?(picker, results)
    }
}
