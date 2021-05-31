//
//  ZXKitUtil.swift
//  ZXKitUtil
//
//  Created by Damon on 2020/7/2.
//  Copyright © 2020 Damon. All rights reserved.
//

import Foundation

open class ZXKitUtil: NSObject {
    private static let instance = ZXKitUtil()
    open class var shared: ZXKitUtil {
        return instance
    }
}
