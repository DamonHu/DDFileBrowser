//
//  DDUtils+permission.swift
//  DDUtils
//
//  Created by Damon on 2020/7/3.
//  Copyright © 2020 Damon. All rights reserved.
//

import Foundation
import AVFoundation
import Photos
import UserNotifications

private var mLocationManager: CLLocationManager?   //定位管理
private var locationComplete: ((DDUtilsPermissionStatus) -> Void)?    //定位结束

public extension DDUtils {
    ///请求权限
    func requestPermission(type: DDUtilsPermissionType, complete: @escaping ((DDUtilsPermissionStatus) -> Void)) -> Void {
        switch type {
        case .audio:
            AVCaptureDevice.requestAccess(for: .audio) { (granted) in
                self.runInMainThread {
                    if granted {
                        complete(.authorized)
                    } else {
                        complete(.denied)
                    }
                }
            }
        case .video:
            AVCaptureDevice.requestAccess(for: .video) { (granted) in
                self.runInMainThread {
                    if granted {
                        complete(.authorized)
                    } else {
                        complete(.denied)
                    }
                }
            }
        case .photoLibrary:
            PHPhotoLibrary.requestAuthorization { (status) in
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
                        case .limited:
                            complete(.limited)
                        default:
                            complete(.authorized)
                    }
                }
            }
        case .GPS:
            mLocationManager = CLLocationManager()
            mLocationManager?.delegate = self
            mLocationManager?.requestWhenInUseAuthorization()
            mLocationManager?.requestAlwaysAuthorization()
            locationComplete = complete
        case .notification:
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
                self.runInMainThread {
                    if granted {
                        complete(.authorized)
                    } else {
                        complete(.denied)
                    }
                }
            }
        }
    }
    
    ///检测权限
    func checkPermission(type: DDUtilsPermissionType, complete: @escaping ((DDUtilsPermissionStatus) -> Void)) -> Void {
        switch type {
        case .audio:
            let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.audio)
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
        case .video:
            let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
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
        case .photoLibrary:
            let status = PHPhotoLibrary.authorizationStatus()
            switch status {
            case .notDetermined:
                complete(.notDetermined)
            case .restricted:
                complete(.restricted)
            case .denied:
                complete(.denied)
            case .authorized:
                complete(.authorized)
            case .limited:
                complete(.limited)
            default:
                complete(.authorized)
            }
        case .GPS:
            if CLLocationManager.locationServicesEnabled() && CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
                complete(.authorized)
            } else if CLLocationManager.authorizationStatus() == .notDetermined {
                complete(.notDetermined)
            } else if CLLocationManager.authorizationStatus() == .restricted {
                complete(.restricted)
            } else if CLLocationManager.authorizationStatus() == .denied {
                complete(.denied)
            }
        case .notification:
            UNUserNotificationCenter.current().getNotificationSettings { (notificationSettings) in
                switch notificationSettings.authorizationStatus {
                case .notDetermined:
                    complete(.notDetermined)
                case .denied:
                    complete(.denied)
                case .authorized:
                    complete(.authorized)
                case .provisional:
                    complete (.authorized)
                default:
                    complete(.authorized)
                }
            }
        }
    }
}

extension DDUtils: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard let locationComplete = locationComplete  else { return }
        switch status {
            case .notDetermined:
                locationComplete(.notDetermined)
            case .restricted:
                locationComplete(.restricted)
            case .denied:
                locationComplete(.denied)
            case .authorizedAlways:
                locationComplete(.authorized)
            case .authorizedWhenInUse:
                locationComplete(.authorized)
            default:
                locationComplete(.authorized)
        }
    }

    @available(iOS 14.0, *)
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard let locationComplete = locationComplete  else { return }
        switch manager.authorizationStatus {
            case .notDetermined:
                locationComplete(.notDetermined)
            case .restricted:
                locationComplete(.restricted)
            case .denied:
                locationComplete(.denied)
            case .authorizedAlways:
                locationComplete(.authorized)
            case .authorizedWhenInUse:
                locationComplete(.authorized)
            default:
                locationComplete(.authorized)
        }
    }
}
