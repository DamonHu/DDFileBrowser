//
//  ZXKitPluginProtocol.swift
//  ZXKit
//
//  Created by Damon on 2021/4/23.
//

import UIKit

public enum ZXKitPluginType {
    case ui
    case data
    case other
}

public protocol ZXKitPluginProtocol {
    var pluginIdentifier: String { get }
    var pluginIcon: UIImage? { get }
    var pluginTitle: String { get }
    var pluginType: ZXKitPluginType { get }
    var isRunning: Bool { get }

    func start()
    func stop()
}
