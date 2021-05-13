//
//  ZXFileModel.swift
//  ZXFileBrowserDemo
//
//  Created by Damon on 2021/5/12.
//

import UIKit

class ZXFileModel: NSObject {
    var name: String
    var modificationDate: Date
    var size: Double
    var isDirectory: Bool

    init(name: String = "", modificationDate: Date = Date(), size: Double = 0, isDirectory: Bool = false) {
        self.name = name
        self.modificationDate = modificationDate
        self.size = size
        self.isDirectory = isDirectory
        super.init()
    }
}
