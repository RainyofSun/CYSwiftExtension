//
//  APPInfomationCache.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/19.
//

import UIKit

public class APPInfomationCache: NSObject {
    // MARK: 多语言
    class public func internationalLanguageType() -> InterbationalLanguage {
        if let _code = UserDefaults.standard.value(forKey: APPLICATION_LANGUAGE_KEY) as? Int, let _type = InterbationalLanguage(rawValue: _code) {
            return _type
        }
        
        return .English
    }
    
    class public func saveInternationalLanguage(_ language: InterbationalLanguage) {
        UserDefaults.standard.setValue(language.rawValue, forKey: APPLICATION_LANGUAGE_KEY)
        UserDefaults.standard.synchronize()
    }
    
    // MARK: 登录信息的本地化
    class public func loginInformationReadFormDiskCache() -> String? {
        if let _str = UserDefaults.standard.value(forKey: APPLICATION_SAVE_LOGIN_MODEL) as? String {
            return _str
        }
        
        return ""
    }
    
    class public func loginInfomationSaveToDisk(_ loginInfo: String?) {
        UserDefaults.standard.set(loginInfo, forKey: APPLICATION_SAVE_LOGIN_MODEL)
        UserDefaults.standard.synchronize()
    }
    
    // MARK: 是否首次按照
    class public func applicationFirstInstall() -> Bool {
        if let _value = UserDefaults.standard.value(forKey: APPLICATION_FIRST_INSTALLATION) as? Bool {
            return _value
        }
        
        return true
    }
    
    class public func saveApplicationInstallMark() {
        UserDefaults.standard.set(false, forKey: APPLICATION_FIRST_INSTALLATION)
        UserDefaults.standard.synchronize()
    }
    
    // MARK: 今日是否已展示定位弹窗
    class public func todayShouldShowLocationAlert() -> Bool {
        let tempCalendar = Calendar.current
        let day_time = tempCalendar.component(Calendar.Component.day, from: Date())
        let record_time = UserDefaults.standard.value(forKey: APPLICATION_SHOW_LOCATION_ALERT_TODAY) as? Int
        if day_time == record_time {
            return false
        } else {
            UserDefaults.standard.set(day_time, forKey: APPLICATION_SHOW_LOCATION_ALERT_TODAY)
            UserDefaults.standard.synchronize()
            return true
        }
    }
}
