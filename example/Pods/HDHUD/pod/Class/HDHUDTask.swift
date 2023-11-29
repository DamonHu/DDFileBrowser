//
//  HDHUDTask.swift
//  HDHUD
//
//  Created by Damon on 2021/7/12.
//

import Foundation
import UIKit

public enum HDHUDTaskType {
    case text
    case progress
    case custom
}

open class HDHUDTask: NSObject {
    public var didAppear: (()->Void)? = nil
    public var completion: (()->Void)? = nil

    var mask = false
    var priority = HDHUDPriority.high
    var taskType = HDHUDTaskType.text
    var duration: TimeInterval = 2.5
    var contentView: UIView?
    var closeButton: UIButton?
    var superView: UIView?

    init(taskType: HDHUDTaskType = .text, duration: TimeInterval = 2.5, superView: UIView? = nil, mask: Bool = false, priority: HDHUDPriority = .high, didAppear: (()->Void)? = nil, completion: (()->Void)? = nil) {
        self.taskType = taskType
        self.duration = duration
        self.superView = superView
        self.mask = mask
        self.priority = priority
        self.didAppear = didAppear
        self.completion = completion
        super.init()
    }
}

open class HDHUDProgressTask: HDHUDTask {
    public var progress: Float = 0 {
        willSet {
            if let contentView = self.contentView as? HDHUDProgressContentView {
                contentView.progress = newValue
            }
        }
    }
}
