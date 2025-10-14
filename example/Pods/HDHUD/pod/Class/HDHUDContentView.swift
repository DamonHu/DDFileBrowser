//
//  HDHUDContentView.swift
//  HDHUD
//
//  Created by Damon on 2020/10/15.
//

import UIKit

class HDHUDContentView: UIView {
    init() {
        super.init(frame: .zero)
        self.backgroundColor = HDHUD.contentBackgroundColor
        self.layer.cornerRadius = 8
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
