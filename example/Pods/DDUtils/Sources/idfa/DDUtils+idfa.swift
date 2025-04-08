//
//  DDUtils+idfa.swift
//  DDUtils
//
//  Created by Damon on 2021/2/19.
//  Copyright © 2021 Damon. All rights reserved.
//

import Foundation
import UIKit
#if canImport(AppTrackingTransparency)
import AppTrackingTransparency
#endif
#if canImport(AdSupport)
import AdSupport
#endif
#if canImport(DDUtils)
import DDUtils
#else
//
#endif

public extension DDUtils {
    ///请求IDFA权限
    func requestIDFAPermission(complete: @escaping ((DDUtilsPermissionStatus) -> Void)) -> Void {
        if #available(iOS 14.0, *) {
            ATTrackingManager.requestTrackingAuthorization { (status) in
                self.runInMainThread {
                    switch status {
                        case .notDetermined:
                            complete(.notDetermined)
                        case .restricted:
                            complete(.restricted)
                        case .denied:
                            complete(.denied)
                        case .authorized:
                            complete(.authorized)
                        default:
                            complete(.authorized)
                    }
                }
            }
        } else {
            self.runInMainThread {
                if ASIdentifierManager.shared().isAdvertisingTrackingEnabled {
                    complete(.authorized)
                } else {
                    complete(.denied)
                }
            }
        }
    }

    ///检测IDFA权限
    func checkIDFAPermission(complete: @escaping ((DDUtilsPermissionStatus) -> Void)) -> Void {
        if #available(iOS 14.0, *) {
            let status = ATTrackingManager.trackingAuthorizationStatus
            switch status {
                case .notDetermined:
                    complete(.notDetermined)
                case .restricted:
                    complete(.restricted)
                case .denied:
                    complete(.denied)
                case .authorized:
                    complete(.authorized)
                default:
                    complete(.authorized)
            }
        } else {
            if ASIdentifierManager.shared().isAdvertisingTrackingEnabled {
                complete(.authorized)
            } else {
                complete(.denied)
            }
        }
    }

    /// 模拟软件唯一标示，需要在Info.plist添加Privacy - Tracking Usage Description，说明使用用途
    /// - Parameter idfvIfFailed: 没有获取idfa的权限时，是否使用idfv
    /// - Returns: 返回的idfa或者idfv
    func getIDFAString(idfvIfFailed: Bool = false) -> String {
        if #available(iOS 14.0, *) {
            let status = ATTrackingManager.trackingAuthorizationStatus
            if status == .authorized || idfvIfFailed == false {
                return ASIdentifierManager.shared().advertisingIdentifier.uuidString
            } else {
                return UIDevice.current.identifierForVendor?.uuidString ?? ""
            }
        } else {
            if ASIdentifierManager.shared().isAdvertisingTrackingEnabled || idfvIfFailed == false {
                return ASIdentifierManager.shared().advertisingIdentifier.uuidString
            } else {
                return UIDevice.current.identifierForVendor?.uuidString ?? ""
            }
        }
    }
}
