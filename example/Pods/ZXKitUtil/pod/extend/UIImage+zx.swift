//
//  UIImage+zx.swift
//  ZXKitUtil
//
//  Created by Damon on 2020/7/11.
//  Copyright © 2020 Damon. All rights reserved.
//

import UIKit

extension UIImage: ZXKitUtilNameSpaceWrappable {

}

public extension ZXKitUtilNameSpace where T : UIImage {
    ///通过颜色获取纯色图片
    static func getImage(color: UIColor) -> UIImage {
        return ZXKitUtil.shared.getImage(color: color)
    }
    
    ///线性渐变
    static func getLinearGradientImage(colors: [UIColor], directionType: ZXKitUtilGradientDirection, size: CGSize = CGSize(width: 100, height: 100)) -> UIImage {
        return ZXKitUtil.shared.getLinearGradientImage(colors: colors, directionType: directionType, size: size)
    }
    
    ///角度渐变
    static func getRadialGradientImage(colors: [UIColor], raduis: CGFloat, size: CGSize = CGSize(width: 100, height: 100)) -> UIImage {
        return ZXKitUtil.shared.getRadialGradientImage(colors: colors, raduis: raduis, size: size)
    }
}
