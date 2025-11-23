//
//  APPLanguageInsTool.swift
//  CYSwiftExtension
//
//  Created by 一刻 on 2025/4/15.
//

import UIKit

public enum InterbationalLanguage: Int {
    /// 英语
    case English = 1
    /// 西班牙语
    case Spanish = 2
    /// 越南语
    case Vietnamese = 3
    /// 印尼语
    case Indonesian = 4
    /// 跟随系统
    case Other = 5
}

public class APPLanguageInsTool: NSObject {
    
    public static let language = APPLanguageInsTool()
    
    private override init() {
        
    }
    
    private var languageBundle: Bundle = Bundle.main
    
    /// 加载多语言
    public static func loadLanguage(_ str: String) -> String {
        return language.localValue(str: str)
    }
    
    /// 设置语言类别
    public static func setLocalLanguage(_ type: InterbationalLanguage) {
        language.setAppLanguage(type)
    }
}

private extension APPLanguageInsTool {
    func localValue(str: String) -> String {
        //table参数值传nil也是可以的，传nil系统就会默认为Localizable
        languageBundle.localizedString(forKey: str, value: nil, table: "Localizable")
    }
    
    func setAppLanguage(_ type: InterbationalLanguage) {
        var type_str = ""
        switch type {
        case .English:
            type_str = "en"
        case .Spanish:
            type_str = "es"
        case .Vietnamese:
            type_str = "vi"
        case .Indonesian:
            type_str = "id"
        case .Other:
            type_str = Locale.current.languageCode ?? ""
        }
        
        //返回项目中 en.lproj 文件的路径
        var path = Bundle.main.path(forResource: type_str, ofType: "lproj")
        if path == nil {
            path = Bundle.main.path(forResource: "en", ofType: "lproj")
        }
        
        //用这个路径生成新的bundle
        languageBundle = Bundle(path: path!)!
    }
}
