//
//  HDHUDWindow.swift
//  HDHUD
//
//  Created by Damon on 2025/10/10.
//

import UIKit

class HDHUDWindow: UIWindow {
    static let shared = HDHUDWindow()
    
    private override init(frame: CGRect = UIScreen.main.bounds) {
        super.init(frame: frame)
        self.windowLevel = .alert + 1  // 高于普通界面
        self.backgroundColor = .clear
        self.rootViewController = HDHUDTaskViewController()
        self.isHidden = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let hitView = super.hitTest(point, with: event) else { return nil }
        //截取页面获取的所有点击
        if HDHUD.isMask {
            if let vc = self.rootViewController as? HDHUDTaskViewController, vc.isVisible {
                return hitView
            }
            return nil
        }
        //点击背景不拦截，只拦截hud内容的点击
        if let vc = self.rootViewController as? HDHUDTaskViewController, vc.isVisible, hitView.isDescendant(of: vc.mStackView) {
            return hitView
        }
        return nil
    }
}
