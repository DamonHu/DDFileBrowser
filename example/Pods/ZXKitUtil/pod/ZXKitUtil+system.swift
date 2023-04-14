//
//  ZXKitUtil+system.swift
//  ZXKitUtil
//
//  Created by Damon on 2020/7/3.
//  Copyright © 2020 Damon. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration.CaptiveNetwork
#if canImport(StoreKit)
import StoreKit
#endif

public enum ZXKitUtilOpenAppStoreType {
    case app        //应用内打开，ios10.3以下无反应
    case appStore   //跳转到App Store
    case auto       //ios10.3以上应用内打开，以下跳转到App Store打开
}

public extension ZXKitUtil {
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
    
    ///打开软件对应的App Store页面
    func openAppStorePage(openType: ZXKitUtilOpenAppStoreType, appleID: String, completion: ((Bool, Error?) -> Void)? = nil) -> Void {
        switch openType {
            case .app:
                let storeProductVC = SKStoreProductViewController()
                storeProductVC.delegate = self
                storeProductVC.loadProduct(withParameters: [SKStoreProductParameterITunesItemIdentifier : appleID]) { (success, error) in
                    if success {
                        self.getCurrentVC()?.present(storeProductVC, animated: true, completion: {
                            if let completion = completion {
                                completion(true, nil)
                            }
                        })
                    } else {
                        if let completion = completion {
                            completion(false, error)
                        }
                    }
                }
            case .appStore:
                let url = URL(string: "https://itunes.apple.com/app/id\(appleID)")!
                UIApplication.shared.open(url, options: [:]) { success in
                    if let completion = completion {
                        completion(success, nil)
                    }
                }
            case .auto:
                let storeProductVC = SKStoreProductViewController()
                storeProductVC.delegate = self
                storeProductVC.loadProduct(withParameters: [SKStoreProductParameterITunesItemIdentifier : appleID]) { (success, error) in
                    if success {
                        self.getCurrentVC()?.present(storeProductVC, animated: true, completion: {
                            if let completion = completion {
                                completion(true, nil)
                            }
                        })
                    } else {
                        let url = URL(string: "https://itunes.apple.com/app/id\(appleID)")!
                        UIApplication.shared.open(url, options: [:]) { success in
                            if let completion = completion {
                                completion(success, nil)
                            }
                        }
                    }
                }
        }
    }

    /// 打开软件对应的评分页面
    /// - Parameters:
    ///   - openType: 打开评分页面的类型
    ///   - appleID: 打开的appid
    ///   - openWriteAction: 是否直接到输入评论的页面，仅对跳转到appStore有效
    func openAppStoreReviewPage(openType: ZXKitUtilOpenAppStoreType, appleID: String = "", openWriteAction: Bool = true) -> Void {
        switch openType {
            case .app:
                if #available(iOS 14.0, *) {
                    var scene: UIWindowScene?
                    for windowScene:UIWindowScene in ((UIApplication.shared.connectedScenes as? Set<UIWindowScene>)!) {
                        if windowScene.activationState == .foregroundActive {
                            scene = windowScene
                            break
                        }
                    }
                    if let scene = scene {
                        SKStoreReviewController.requestReview(in: scene)
                    } else {
                        //使用链接方式
                        self.openAppStoreReviewPage(openType: .appStore, appleID: appleID)
                    }
                } else if #available(iOS 10.3, *) {
                    SKStoreReviewController.requestReview()
                } else {
                    assert(false, "ios10.3以下版本不支持")
                };
            case .appStore:
                var url = URL(string: "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=\(appleID)&mt=8")!
                if openWriteAction {
                    url = URL(string: "itms-apps://itunes.apple.com/cn/app/id\(appleID)?mt=8&action=write-review")!
                }
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            case .auto:
                if #available(iOS 10.3, *) {
                    self.openAppStoreReviewPage(openType: .app, appleID: appleID)
                } else {
                    self.openAppStoreReviewPage(openType: .appStore, appleID: appleID)
                }
        }
    }
}

extension ZXKitUtil : SKStoreProductViewControllerDelegate {
    public func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
}
