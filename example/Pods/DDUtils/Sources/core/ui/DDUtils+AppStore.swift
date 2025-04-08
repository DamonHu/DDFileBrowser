//
//  DDUtils+AppStore.swift
//  DDUtils
//
//  Created by Damon on 2024/5/27.
//  Copyright © 2024 Damon. All rights reserved.
//

import Foundation
#if canImport(StoreKit)
import StoreKit
#endif

public enum DDUtilsOpenAppStoreType {
    case app        //应用内打开，ios10.3以下无反应
    case appStore   //跳转到App Store
    case auto       //ios10.3以上应用内打开，以下跳转到App Store打开
}

public extension DDUtils {
    ///打开软件对应的App Store页面
    func openAppStorePage(openType: DDUtilsOpenAppStoreType, appleID: String, completion: ((Bool, Error?) -> Void)? = nil) -> Void {
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
    func openAppStoreReviewPage(openType: DDUtilsOpenAppStoreType, appleID: String = "", openWriteAction: Bool = true) -> Void {
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


extension DDUtils : SKStoreProductViewControllerDelegate {
    public func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
}
