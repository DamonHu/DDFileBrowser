//
//  HDHUDTask.swift
//  HDHUD
//
//  Created by Damon on 2021/7/12.
//

import Foundation
import UIKit

open class HDHUDTask: NSObject {
    public var didAppear: (()->Void)? = nil
    public var completion: (()->Void)? = nil
    public var isVisible: Bool = false
    
    var duration: TimeInterval = 3.5
    var contentView: UIView = UIView()
    var closeButtonDelay: TimeInterval = -1
    var closeButton: UIButton?

    init(duration: TimeInterval = 3.5, closeButtonDelay: TimeInterval = -1, didAppear: (()->Void)? = nil, completion: (()->Void)? = nil) {
        self.duration = duration
        self.closeButtonDelay = closeButtonDelay
        self.didAppear = didAppear
        self.completion = completion
        super.init()
    }
}

open class HDHUDLoadingTask: HDHUDTask {
    
}

open class HDHUDProgressTask: HDHUDTask {
    public var progress: Float = 0 {
        didSet {
            if let contentView = self.contentView as? HDHUDProgressContentView {
                contentView.progress = self.progress
            }
        }
    }
    
    public var text: String? = nil {
        didSet {
            if let contentView = self.contentView as? HDHUDProgressContentView {
                contentView.text = self.text
            }
        }
    }
}
