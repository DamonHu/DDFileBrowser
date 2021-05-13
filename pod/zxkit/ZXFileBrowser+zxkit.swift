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
        return UIImage(named: "HDPingTool")
    }

    public var pluginTitle: String {
        return "FileBrowser"
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
