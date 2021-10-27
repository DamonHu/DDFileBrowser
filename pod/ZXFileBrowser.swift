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

public enum ZXFileType {
    case unknown
    case folder     //文件夹
    case image      //图片
    case video      //视频
    case audio      //音频
    case web        //链接
    case application    //应用和执行文件
    case zip        //压缩包
    case log        //日志
    case excel     //表格
    case word       //word文档
    case ppt        //ppt
    case pdf        //pdf
    case system     //系统文件
    case txt        //文本
    case db         //数据库
}

open class ZXFileBrowser: NSObject {
    private static let instance = ZXFileBrowser()
    open class var shared: ZXFileBrowser {
        return instance
    }

    //MARK: UI
    lazy var mNavigationController: UINavigationController = {
        let rootViewController = ZXFileBrowserVC()
        let navigation = UINavigationController(rootViewController: rootViewController)
        navigation.navigationBar.barTintColor = UIColor.white
        return navigation
    }()
}

public extension ZXFileBrowser {
    func start() {
        #if canImport(ZXKitCore)
        ZXKit.hide()
        #endif
        self.mNavigationController.dismiss(animated: false) { [weak self] in
            guard let self = self else { return }
            ZXKitUtil.shared.getCurrentVC()?.present(self.mNavigationController, animated: true, completion: nil)
        }
    }

    func getFileType(filePath: URL?) -> ZXFileType {
        guard let filePath = filePath else { return .unknown }
        if (filePath.lastPathComponent.hasPrefix(".")) {
            return .system
        } else if let utType = self._getFileUTType(filePath: filePath) {
            if UTTypeConformsTo(utType, kUTTypeDirectory) {
                return .folder
            } else if UTTypeConformsTo(utType, kUTTypeImage) {
                return .image
            } else if (UTTypeConformsTo(utType, kUTTypeVideo) || UTTypeConformsTo(utType, kUTTypeMovie) || UTTypeConformsTo(utType, kUTTypeMPEG4) || UTTypeConformsTo(utType, kUTTypeAVIMovie) || UTTypeConformsTo(utType, kUTTypeQuickTimeMovie)) {
                return .video
            } else if (UTTypeConformsTo(utType, kUTTypeAudio) || UTTypeConformsTo(utType, kUTTypeMP3) || UTTypeConformsTo(utType, kUTTypeMPEG4Audio)) {
                return .audio
            } else if UTTypeConformsTo(utType, kUTTypeApplication) || UTTypeConformsTo(utType, kUTTypeSourceCode) {
                return .application
            } else if (UTTypeConformsTo(utType, kUTTypeZipArchive) || UTTypeConformsTo(utType, kUTTypeGNUZipArchive) || UTTypeConformsTo(utType, kUTTypeBzip2Archive)) {
                return .zip
            } else if (UTTypeConformsTo(utType, kUTTypeHTML) || UTTypeConformsTo(utType, kUTTypeURL) || UTTypeConformsTo(utType, kUTTypeFileURL)) {
                return .web
            } else if UTTypeConformsTo(utType, kUTTypeLog) {
                return .log
            } else if UTTypeConformsTo(utType, kUTTypePDF) {
                return .pdf
            } else if UTTypeConformsTo(utType, kUTTypeText) || UTTypeConformsTo(utType, kUTTypeRTF) {
                return .txt
            } else {
                if UTTypeConformsTo(utType, "org.openxmlformats.wordprocessingml.document" as CFString) || UTTypeConformsTo(utType, "com.microsoft.word.doc" as CFString) {
                    return .word
                } else if UTTypeConformsTo(utType, "org.openxmlformats.presentationml.presentation" as CFString) || UTTypeConformsTo(utType, "com.microsoft.powerpoint.ppt" as CFString) {
                    return .ppt
                } else if UTTypeConformsTo(utType, "org.openxmlformats.spreadsheetml.sheet" as CFString) || UTTypeConformsTo(utType, "com.microsoft.excel.xls" as CFString) {
                    return .excel
                } else if filePath.pathExtension.lowercased() == "db" {
                    //TODO: db格式的utiType暂不确定，根据后缀判断
                    return .db
                } else {
                    return .unknown
                }
            }
        } else {
            return .unknown
        }
    }
}

private extension ZXFileBrowser {
    func _getFileUTType(filePath: URL?) -> CFString? {
        guard let filePath = filePath else { return nil }
        let fileExt = filePath.pathExtension
        if fileExt.isEmpty {
            var isDirectory: ObjCBool = false
            if FileManager.default.fileExists(atPath: filePath.path, isDirectory: &isDirectory) {
                if isDirectory.boolValue {
                    return kUTTypeFolder
                }
            }
        }
        // 把文件转换成 Uniform Type Identifiers 后获取文件的 tag
        let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, fileExt as CFString, nil)
        if let retainedValue = uti?.takeRetainedValue() {
            return retainedValue
        } else {
            return nil
        }
    }
}
