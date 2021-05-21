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
import MobileCoreServices

enum ZXFileType {
    case unknown
}

open class ZXFileBrowser: NSObject {
    private static let instance = ZXFileBrowser()
    open class var shared: ZXFileBrowser {
        return instance
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
    func getFileType(filePath: URL?) -> CFString? {
        guard let filePath = filePath else { return nil }
        let fileExt = filePath.pathExtension
        // 把文件转换成 Uniform Type Identifiers 后获取文件的 tag
        let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, fileExt as CFString, nil)
        if let retainedValue = uti?.takeRetainedValue() {
            // 通过UTTypeConformsTo 方法来判断文件类型是否为图片，kUTTypeImage 是需要比较的文件类型
//            if UTTypeConformsTo((uti?.takeRetainedValue())!, kUTTypeImage){
//                print("这是一个图片")
//                // 接下来的操作
//            }
            print(retainedValue)
            return retainedValue
        } else {
            return nil
        }

    }
}
