//
//  ZXFileBrowser.swift
//  ZXFileBrowserDemo
//
//  Created by Damon on 2021/5/11.
//

import UIKit
import ZXKitUtil
#if canImport(ZXKitCore)
import ZXKitCore
#endif

open class ZXFileBrowser: NSObject {
    public required override init() {

    }
    
    public static func shared() -> Self {
        return Self()
    }

    public func start() {
        #if canImport(ZXKitCore)
        ZXKit.hide()
        #endif
        let rootViewController = ZXFileBrowserVC()
        let navigation = UINavigationController(rootViewController: rootViewController)
        navigation.navigationBar.barTintColor = UIColor.white
        ZXKitUtil.shared().getCurrentVC()?.present(navigation, animated: true, completion: nil)
    }
}

extension ZXFileBrowser {
    
}
