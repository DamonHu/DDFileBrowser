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
    var fileType: ZXFileType

    init(name: String = "", modificationDate: Date = Date(), size: Double = 0, fileType: ZXFileType = .unknown) {
        self.name = name
        self.modificationDate = modificationDate
        self.size = size
        self.fileType = fileType
        super.init()
    }
}
