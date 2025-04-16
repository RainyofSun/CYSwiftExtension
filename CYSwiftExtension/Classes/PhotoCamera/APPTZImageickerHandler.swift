//
//  APPTZImageickerHandler.swift
//  CYSwiftExtension
//
//  Created by 一刻 on 2025/4/16.
//

import UIKit
import TZImagePickerController

// 代理协议
internal protocol TZImagePickerControllerProxyProtocol {
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!)
}

// 代理类
internal class APPTZImageickerHandler: NSObject, TZImagePickerControllerDelegate {
    
    private var delegate: TZImagePickerControllerProxyProtocol?
    
    //MARK:- 初始化
    convenience public init(proxyDelegateHandler handler: TZImagePickerControllerProxyProtocol) {
        self.init()
        self.delegate = handler
    }
    
    deinit {
        print("DELLOC --- APPWebControllerScriptHandler")
    }
    
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool) {
        delegate?.imagePickerController(picker, didFinishPickingPhotos: photos)
    }
}
