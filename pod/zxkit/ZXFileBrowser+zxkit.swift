//
//  ZXFileBrowser+zxkit.swift
//  ZXFileBrowserDemo
//
//  Created by Damon on 2021/5/11.
//

import Foundation
import ZXKitCore

func UIImageHDBoundle(named: String?) -> UIImage? {
    guard let name = named else { return nil }
    guard let bundlePath = Bundle(for: ZXFileBrowser.self).path(forResource: "ZXFileBrowser", ofType: "bundle") else { return nil }
    let bundle = Bundle(path: bundlePath)
    return UIImage(named: name, in: bundle, compatibleWith: nil)
}

extension ZXFileBrowser: ZXKitPluginProtocol {
    public var pluginIdentifier: String {
        return "com.zxkit.fileBrowser"
    }

    public var pluginIcon: UIImage? {
        return UIImageHDBoundle(named: "zxfilebrowser")
    }

    public var pluginTitle: String {
        return NSLocalizedString("FileBrowser", comment: "")
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
