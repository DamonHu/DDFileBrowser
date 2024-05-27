//
//  DDUtils+system.swift
//  DDUtils
//
//  Created by Damon on 2020/7/3.
//  Copyright © 2020 Damon. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration.CaptiveNetwork

public extension DDUtils {
    ///获取软件版本
    func getAppVersionString() -> String {
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        return version ?? ""
    }
    
    ///获取软件构建版本
    func getAppBuildVersionString() -> String {
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
        return version ?? ""
    }

    ///获取软件名
    func getAppNameString() -> String {
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
        return version ?? ""
    }
    
    ///获取系统的iOS版本
    func getIOSVersionString() -> String {
        return UIDevice.current.systemVersion
    }
    
    ///获取系统语言
    func getIOSLanguageStr() -> String {
        let language = Bundle.main.preferredLocalizations.first
        return language ?? ""
    }
    
    ///获取软件Bundle Identifier
    func getBundleIdentifier() -> String {
        return Bundle.main.bundleIdentifier ?? ""
    }
    
    ///获取本机机型标识
    func getSystemHardware() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
    
    ///获取本机上次重启时间
    func getSystemUpTime() -> TimeInterval {
        let timeInterval = ProcessInfo.processInfo.systemUptime
        return Date().timeIntervalSince1970 - timeInterval
    }
    
    ///获取手机WIFI的MAC地址，需要开启Access WiFi information
    func getMacAddress() -> (ssid: String?, mac: String?) {
        let interfaces:NSArray = CNCopySupportedInterfaces()!
        var ssid: String?
        var mac: String?
        for sub in interfaces {
            if let dict = CFBridgingRetain(CNCopyCurrentNetworkInfo(sub as! CFString)) {
                ssid = dict["SSID"] as? String
                mac = dict["BSSID"] as? String
                break
            }
        }
        return (ssid: ssid, mac: mac)
    }
    
    ///打开系统设置
    func openSystemSetting(completion: ((Bool) -> Void)? = nil) -> Void {
        let url = URL(string: UIApplication.openSettingsURLString)!
        UIApplication.shared.open(url, options: [:], completionHandler: completion)
    }
}
