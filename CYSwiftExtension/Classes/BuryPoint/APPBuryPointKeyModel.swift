//
//  APPBuryPointKeyModel.swift
//  CYSwiftExtension
//
//  Created by 一刻 on 2025/9/12.
//

import UIKit

@objcMembers public class APPBuryPointKeyModel: NSObject {
    /*
     通用配置
     */
    /// Key -- IDFV
    var idfvKey: String?
    /// Key -- IDFA
    var idfaKey: String?
    /// Key -- 经度
    var longitudeKey: String?
    /// Key -- 纬度
    var latitudeKey: String?
    
    /*
     定位上报
     */
    /// Key -- 国家
    var countryKey: String?
    /// Key -- 国家代码
    var countryCodeKey: String?
    /// Key -- 省
    var provinceKey: String?
    /// Key -- 市
    var cityKey: String?
    /// Key -- 区、县
    var districtKey: String?
    /// 服务器地址
    var locationServiceUrl: String?
    
    /*
     风控上报
     */
    /// Key -- 产品 ID
    var productIdKey: String?
    var productId: String?
    /// Key -- 风控类型
    var riskControlTypeKey: String?
    var riskControlType: String?
    /// Key -- 订单号
    var orderNumberKey: String?
    var orderNumber: String?
    /// Key -- 开始时间
    var beginTimeKey: String?
    var beginTime: String?
    /// Key -- 结束时间
    var endTimeKey: String?
    var endTime: String?
    /// Key -- 服务器地址
    var riskControlUrl: String?
    
    /*
     设备信息上报
     */
    /* ---------------------------------------- */
    /// Key -- 可用存储大小
    var availableStorageSizeKey: String?
    /// Key -- 总存储大小
    var totalStorageSizeKey: String?
    /// Key -- 可用内存大小
    var availableMemorySizeKey: String?
    /// Key -- 总内存大小
    var totalMemorySizeKey: String?
    /// Key -- 设备信息
    var deviceInfoKey: String?
    
    /* ---------------------------------------- */
    /// Key -- 剩余电量
    var remaininingPowerKey: String?
    /// Key -- 设备是否在充电
    var isRechargingKey: String?
    /// Key -- 电量
    var powerKey: String?
    
    /* ---------------------------------------- */
    /// Key -- 系统版本
    var systemVersionKey: String?
    /// Key -- 设备名字
    var deviceNameKey: String?
    /// Key -- 设备型号
    var deviceModelKey: String?
    /// Key -- 系统信息
    var systemInfoKey: String?
    
    /* ---------------------------------------- */
    /// Key -- 时区
    var timeZoneKey: String?
    /// Key -- 运营商
    var SIMInfoKey: String?
    /// Key -- 网络类型
    var networkTypeKey: String?
    /// Key -- IP 地址
    var ipKey: String?
    /// Key -- 网络信息
    var deviceNetKey: String?
    
    /* ---------------------------------------- */
    /// Key -- Wifi
    var wifiKey: String?
    
    /* ---------------------------------------- */
    /// Key -- Mac 地址 1
    var macAddressKey1: String?
    /// Key -- Mac 地址 2
    var macAddressKey2: String?
    /// Key -- WiFi 名字 1
    var wifiNameKey1: String?
    /// Key -- WiFi 名字 2
    var wifiNameKey2: String?
    /// Key -- Wifi
    var wifiDetailKey: String?
    /// 设备信息的地址
    var deviceInfoURL: String?
}
