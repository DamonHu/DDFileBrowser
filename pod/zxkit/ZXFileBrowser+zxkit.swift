//
//  ZXFileBrowser+zxkit.swift
//  ZXFileBrowserDemo
//
//  Created by Damon on 2021/5/11.
//

import Foundation
import ZXKitCore

extension ZXFileBrowser: ZXKitPluginProtocol {
    public var pluginIdentifier: String {
        return "com.zxkit.fileBrowser"
    }

    public var pluginIcon: UIImage? {
        return UIImageHDBoundle(named: "zxfilebrowser")
    }

    public var pluginTitle: String {
        return "FileBrowser".ZXLocaleString
    }

    public var pluginType: ZXKitPluginType {
        return .other
    }

    public var isRunning: Bool {
        return false
    }

    public func stop() {
        
    }


}
