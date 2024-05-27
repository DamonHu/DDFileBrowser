//
//  UIView+dd.swift
//  DDUtils
//
//  Created by Damon on 2020/7/5.
//  Copyright © 2020 Damon. All rights reserved.
//

import UIKit

extension UIView: DDUtilsNameSpaceWrappable {

}

public extension DDUtilsNameSpace where T : UIView {
    ///添加阴影
    func addLayerShadow(color: UIColor, offset: CGSize, radius: CGFloat, cornerRadius: CGFloat? = nil) -> Void {
        object.layer.shadowColor = color.cgColor
        object.layer.shadowOffset = offset
        object.layer.shadowRadius = radius
        object.layer.shadowOpacity = 1
        object.layer.shouldRasterize = true
        object.layer.rasterizationScale = UIScreen.main.scale
        if let cornerRadius = cornerRadius {
            object.layer.cornerRadius = cornerRadius
        }
    }
    
    ///设置Frame
    func setFrame(x: CGFloat? = nil, y: CGFloat? = nil, width: CGFloat? = nil, height: CGFloat? = nil) -> Void {
        var frame = object.frame
        if let x = x {
            object.frame = CGRect(x: x, y: frame.origin.y, width: frame.size.width, height: frame.size.height)
        }
        frame = object.frame
        if let y = y {
            object.frame = CGRect(x: frame.origin.x, y: y, width: frame.size.width, height: frame.size.height)
        }
        frame = object.frame
        if let width = width {
            object.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: width, height: frame.size.height)
        }
        frame = object.frame
        if let height = height {
            object.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: height)
        }
    }

    func className() -> String {
        return String("\(type(of: object))")
    }

    static func className() -> String {
        return String("\(classObject.self)")
    }
}
