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
    private static let instance = ZXFileBrowser()
    open class var shared: ZXFileBrowser {
        return instance
    }
    private override init() {
        
    }

    public func start() {
        #if canImport(ZXKitCore)
        ZXKit.hide()
        #endif
        self.mNavigationController.dismiss(animated: false) { [weak self] in
            guard let self = self else { return }
            ZXKitUtil.shared.getCurrentVC()?.present(self.mNavigationController, animated: true, completion: nil)
        }
    }

    //MARK: UI
    lazy var mNavigationController: UINavigationController = {
        let rootViewController = ZXFileBrowserVC()
        let navigation = UINavigationController(rootViewController: rootViewController)
        navigation.navigationBar.barTintColor = UIColor.white
        return navigation
    }()
}

extension ZXFileBrowser {
    
}
