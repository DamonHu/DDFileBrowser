//
//  HDTaskCloseButton.swift
//  HDHUD
//
//  Created by Damon on 2025/10/13.
//

import UIKit

class HDTaskCloseButton: UIButton {
    weak var task: HDHUDTask?   // 弱引用，避免循环引用

    init(task: HDHUDTask? = nil) {
        self.task = task
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isHidden = true
        self.backgroundColor = UIColor.clear
        self.setImage(UIImageHDBoundle(named: "icon_close"), for: .normal)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HDTaskCloseButton {
    
}
