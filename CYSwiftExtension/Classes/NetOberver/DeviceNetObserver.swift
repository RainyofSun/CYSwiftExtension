//
//  DeviceNetObserver.swift
//  JoyCash
//
//  Created by Yu Chen  on 2025/2/19.
//

import UIKit
import Reachability
import CoreTelephony

// 网络状态通知
public let APPLICATION_NET_CHANGE = "com.jc.notification.name.net.change"

@objcMembers public class DeviceNetObserver: NSObject {
    public enum NetworkStatus {
        case NetworkStatus_WIFI
        case NetworkStatus_Cellular
        case NetworkStatus_LTE
        case NetworkStatus_EDGE
        case NetworkStatus_NoNet
    }
    
    //单例
    public static let shared = DeviceNetObserver()
    private override init() {}
    
    private(set) var netState: NetworkStatus = .NetworkStatus_NoNet
    
    // Reachability必须一直存在，所以需要设置为全局变量
    private let reachability = Reachability.forInternetConnection()
    
    /***** 网络状态监听部分（开始） *****/
    public func StartNetworkStatusListener() {
        // 设置初始状态
        setNetState(reach: reachability!)
        // 1、设置网络状态消息监听 2、获得网络Reachability对象
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged),name: Notification.Name.reachabilityChanged,object: reachability)
        // 3、开启网络状态消息监听
        reachability?.startNotifier()
    }
    
    // 停止监测
    public func StopNetworkObserverListener() {
        reachability?.stopNotifier()
    }
    
    public func netReachable() -> Bool {
        return self.netState != NetworkStatus.NetworkStatus_NoNet
    }
    
    private func setNetState(reach: Reachability) {
        if reach.isReachable() { // 判断网络连接状态
            if reach.isReachableViaWiFi() {
                self.netState = .NetworkStatus_WIFI
            } else {
                self.netState = .NetworkStatus_Cellular
            }
        } else {
            checkConnection()
        }
    }
    
    private func checkConnection() {
        let telephonyInfo = CTTelephonyNetworkInfo()
        guard let currentConnection = telephonyInfo.currentRadioAccessTechnology else {
            self.netState = .NetworkStatus_NoNet
            return
        }
        if (currentConnection == CTRadioAccessTechnologyLTE) { // Connected to LTE
            self.netState = .NetworkStatus_LTE
        } else if(currentConnection == CTRadioAccessTechnologyEdge) { // Connected to EDGE
            self.netState = .NetworkStatus_EDGE
        } else { // Connected to 3G
            self.netState = .NetworkStatus_NoNet
        }
    }
    
    // 主动检测网络状态
    @objc func reachabilityChanged(note: NSNotification) {
        let reachability = note.object as! Reachability
        setNetState(reach: reachability)
        print("+++++++++++ 当前网络状态: \(self.netState)++++++++++++++")
        NotificationCenter.default.post(name: NSNotification.Name(APPLICATION_NET_CHANGE), object: self.netState)
    }
}
