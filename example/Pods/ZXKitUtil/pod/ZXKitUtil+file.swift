//
//  ZXKitUtil+file.swift
//  ZXKitUtil
//
//  Created by Damon on 2020/7/4.
//  Copyright © 2020 Damon. All rights reserved.
//

import Foundation
import CommonCrypto

public enum ZXKitUtilFileDirectoryType {
    case home       //程序主目录
    case documents  //应用中用户数据可以放在这里，iTunes备份和恢复的时候会包括此目录
    case tmp        //存放临时文件，iTunes不会备份和恢复此目录，此目录下文件可能会在应用退出后删除
    case caches     //存放缓存文件，iTunes不会备份此目录，此目录下文件不会在应用退出删除，硬盘资源紧张时会被删除
}

public extension ZXKitUtil {
    ///获取文件夹路径
    func getFileDirectory(type: ZXKitUtilFileDirectoryType) -> URL {
        let homePath = NSHomeDirectory()
        switch type {
        case .home:
            return URL(fileURLWithPath: homePath)
        case .documents:
            return URL(fileURLWithPath: homePath.appending("/Documents"))
        case .tmp:
            return URL(fileURLWithPath: homePath.appending("/tmp"))
        case .caches:
            return URL(fileURLWithPath: homePath.appending("/Library/Caches"))
        }
    }
    
    /// 在指定文件夹中创建文件夹
    /// - Parameters:
    ///   - type: 浮层文件夹类型
    ///   - directoryName: 文件夹名称
    /// - Returns: 创建的文件夹路径
    func createFileDirectory(in type: ZXKitUtilFileDirectoryType, directoryName: String) -> URL {
        let manager = FileManager.default
        let superDirectory = self.getFileDirectory(type: type)
    
        let newFolder = superDirectory.appendingPathComponent(directoryName, isDirectory: true)

        var isDirectory: ObjCBool = false
        let isDirExist = manager.fileExists(atPath: newFolder.path, isDirectory: &isDirectory)
        if !isDirectory.boolValue || !isDirExist {
            do {
                try manager.createDirectory(at: newFolder, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("创建目录失败\(error)")
                return newFolder
            }
        }
        return newFolder
    }
    
    ///获取指定文件的大小
    func getFileSize(filePath: URL) -> Double {
        let manager = FileManager.default
        if manager.fileExists(atPath: filePath.path) {
            let fileSize = try? manager.attributesOfItem(atPath: filePath.path)
            return fileSize?[FileAttributeKey.size] as? Double ?? 0
        }
        return 0
    }
    
    ///获取文件夹大小
    func getFileDirectorySize(fileDirectoryPth: URL) -> Double {
        let manager = FileManager.default
        var size: Double = 0

        if manager.fileExists(atPath: fileDirectoryPth.path), let subPath = manager.subpaths(atPath: fileDirectoryPth.path) {
            for fileName in subPath {
                let filePath = fileDirectoryPth.path.appending("/\(fileName)")
                size = size + self.getFileSize(filePath: URL(fileURLWithPath: filePath))
            }
        }
        return size
    }
}
