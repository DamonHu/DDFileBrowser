//
//  DDFileModel.swift
//  DDFileBrowserDemo
//
//  Created by Damon on 2021/5/12.
//

import UIKit

class DDFileModel: NSObject {
    var name: String
    var filepath: URL
    
    var modificationDate: Date = Date()
    var size: Double = 0
    var fileType: DDFileType = .unknown

    init(name: String , filepath: URL) {
        self.name = name
        self.filepath = filepath
        super.init()
    }
}
