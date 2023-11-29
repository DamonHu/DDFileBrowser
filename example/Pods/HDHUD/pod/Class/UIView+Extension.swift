//
//  UIView+Extension.swift
//  HDHUD
//
//  Created by Damon on 2021/9/18.
//

import UIKit

extension UIView {
    func addPopAnimation() {
        
        //动态弹出
        let scaleAnimation = CABasicAnimation(keyPath: "transform")
        scaleAnimation.fromValue = NSValue(caTransform3D: CATransform3DMakeScale(0, 0, 1))
        scaleAnimation.toValue = NSValue(caTransform3D: CATransform3DMakeScale(1, 1, 1))
        scaleAnimation.isCumulative = false
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.default)

        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = 0
        opacityAnimation.toValue = 1
        opacityAnimation.isCumulative = false
        opacityAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)

        let group = CAAnimationGroup()
        group.duration = 0.5
        group.isRemovedOnCompletion = false
        group.repeatCount = 1
        group.fillMode = CAMediaTimingFillMode.forwards
        group.animations = [scaleAnimation, opacityAnimation]
        self.layer.add(group, forKey: "scale")
    }
}
