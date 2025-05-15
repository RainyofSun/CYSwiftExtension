//
//  APPMultimediaTool.swift
//  CYSwiftExtension
//
//  Created by 一刻 on 2025/4/16.
//

import UIKit
import TZImagePickerController
import YYKit
import JKSwiftExtension

public enum MultimediaType {
    case Camera
    case Photo
}

public protocol APPMultimediaProtocol: AnyObject {
    /// 选择图片完成
    func selectedPictureFormMultimediaComplete(_ filePath: String)
}

public class APPMultimediaTool: NSObject {
    
    weak open var toolDelegate: APPMultimediaProtocol?
    
    private weak var persent_vc: UIViewController?
    private lazy var proxy = APPTZImageickerHandler(proxyDelegateHandler: self)
    
    public init(presentViewController controller: UIViewController) {
        super.init()
        self.persent_vc = controller
    }
    
    deinit {
        print("DELLOC ---- APPMultimediaTool")
    }
    
    public func showAlertSheet(callBlock:(@escaping (Bool) -> Void)) {
        let alertSheet: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        let alertAction1: UIAlertAction = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default) { _ in
            callBlock(true)
        }
        alertSheet.addAction(alertAction1)
        
        let alertAction2: UIAlertAction = UIAlertAction(title: "Photo", style: UIAlertAction.Style.default) { _ in
            callBlock(false)
        }
        alertSheet.addAction(alertAction2)
        
        let alertAction3: UIAlertAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { _ in
            
        }
        alertSheet.addAction(alertAction3)
        
        self.persent_vc?.present(alertSheet, animated: true)
    }
    
    public func takingPhoto(_ isFrontCamera: Bool, tips: String = "Authorize camera access to easily take ID card photos and have a convenient operation process.") {
        AVCaptureDevice.requestAccess(for: AVMediaType.video) {[weak self] (auth: Bool) in
            if !auth {
                dispatch_async_on_main_queue {
                    self?.showSystemAlertController(tips)
                }
                return
            }
            
            dispatch_async_on_main_queue {
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                    let pickerController = UIImagePickerController()
                    pickerController.allowsEditing = false
                    pickerController.sourceType = .camera
                    pickerController.cameraDevice = isFrontCamera ? .front : .rear
                    pickerController.delegate = self
                    self?.persent_vc?.navigationController?.present(pickerController, animated: true)
                }
            }
        }
    }
    
    public func takingPictureFormAlbum(tips: String = "Grant album permission to conveniently select and upload identity photos and accelerate the application process") {
        PHPhotoLibrary.requestAuthorization(for: PHAccessLevel.readWrite) { [weak self] (authStatus: PHAuthorizationStatus) in
            guard let _self = self else {
                return
            }
            
            guard authStatus == .authorized || authStatus == .limited else {
                dispatch_async_on_main_queue {
                    self?.showSystemAlertController(tips)
                }
                return
            }
            
            dispatch_async_on_main_queue {
                let imagePickerVc = TZImagePickerController(maxImagesCount: 1, columnNumber: 4, delegate: _self.proxy, pushPhotoPickerVc: true)
                imagePickerVc?.allowPickingImage = true
                imagePickerVc?.allowTakeVideo = false
                imagePickerVc?.allowPickingGif = false
                imagePickerVc?.allowPickingVideo = false
                imagePickerVc?.allowCrop = true
                imagePickerVc?.cropRect = CGRect(x: 0, y: (UIScreen.main.bounds.height - UIScreen.main.bounds.width) * 0.5, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
                imagePickerVc?.statusBarStyle = .lightContent
                imagePickerVc?.modalPresentationStyle = .fullScreen
                _self.persent_vc?.present(imagePickerVc!, animated: true, completion: nil)
            }
        }
    }
    
    private func showSystemAlertController(_ title: String) {
        let alertVC: UIAlertController = UIAlertController(title: nil, message: title, preferredStyle: UIAlertController.Style.alert)
        let okAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (okAction: UIAlertAction) in
            
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { (cancel: UIAlertAction) in
            if UIApplication.shared.canOpenURL(NSURL(string: UIApplication.openSettingsURLString)! as URL) {
                UIApplication.shared.open(NSURL(string: UIApplication.openSettingsURLString)! as URL, options: [:], completionHandler: nil)
            }
        }
        
        alertVC.addAction(okAction)
        alertVC.addAction(cancelAction)
        
        self.persent_vc?.present(alertVC, animated: true)
    }
}

extension APPMultimediaTool: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let originalImg: UIImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        let compress_img_data = originalImg.jk.compressDataSize(maxSize: 1024 * 1024)
        var filePath: String = ""
        if let document = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
            // 存储到临时路径下
            filePath = document + "/\(Date.jk.secondStamp).png"
        }
        
        try? compress_img_data?.write(to: NSURL(fileURLWithPath: filePath) as URL)
        picker.dismiss(animated: true)
        
        self.toolDelegate?.selectedPictureFormMultimediaComplete(filePath)
    }
}

// MARK: TZImagePickerControllerDelegate
extension APPMultimediaTool: TZImagePickerControllerProxyProtocol {
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!) {
        
        guard let image = photos.first else {
            return
        }

        let compress_img_data = image.jk.compressDataSize(maxSize: 1024 * 1024)
        var filePath: String = ""
        if let document = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
            // 存储到临时路径下
            filePath = document + "/\(Date.jk.secondStamp).png"
        }
        
        try? compress_img_data?.write(to: NSURL(fileURLWithPath: filePath) as URL)
        picker.dismiss(animated: true)
        
        self.toolDelegate?.selectedPictureFormMultimediaComplete(filePath)
    }
}
