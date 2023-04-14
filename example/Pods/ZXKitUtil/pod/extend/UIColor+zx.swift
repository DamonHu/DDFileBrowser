//
//  UIColor+zx.swift
//  ZXKitUtil
//
//  Created by Damon on 2020/7/9.
//  Copyright © 2020 Damon. All rights reserved.
//

import UIKit

extension UIColor: ZXKitUtilNameSpaceWrappable {

}

public extension ZXKitUtilNameSpace where T : UIColor {

    /// 16进制颜色转为UIColor
    /// - Parameters:
    ///   - hexValue: 颜色 0xffffff
    ///   - darkHexValue: 仅当支持暗黑模式且设置该参数，暗黑模式下才会显示该颜色。否则依旧显示hexValue
    ///   - alpha: 透明度
    ///   - darkAlpha: 仅当支持暗黑模式且设置该参数，暗黑模式下才会使用该透明度.否则依旧显示alpha
    /// - Returns: 颜色对象
    static func color(hexValue: Int, darkHexValue: Int? = nil, alpha: Float = 1.0, darkAlpha: Float? = nil) -> UIColor {
        if #available(iOS 10.0, *) {
            if #available(iOS 13.0, *) {
                let dyColor = UIColor { (traitCollection) -> UIColor in
                    if traitCollection.userInterfaceStyle == .light {
                        return UIColor(displayP3Red: CGFloat(((Float)((hexValue & 0xFF0000) >> 16))/255.0), green: CGFloat(((Float)((hexValue & 0xFF00) >> 8))/255.0), blue: CGFloat(((Float)(hexValue & 0xFF))/255.0), alpha: CGFloat(alpha))
                    } else {
                        let displayHex = darkHexValue ?? hexValue
                        let displayAlpha = darkAlpha ?? alpha
                        return UIColor(displayP3Red: CGFloat(((Float)((displayHex & 0xFF0000) >> 16))/255.0), green: CGFloat(((Float)((displayHex & 0xFF00) >> 8))/255.0), blue: CGFloat(((Float)(displayHex & 0xFF))/255.0), alpha: CGFloat(displayAlpha))
                    }
                }
                return dyColor
            } else {
                return UIColor(displayP3Red: CGFloat(((Float)((hexValue & 0xFF0000) >> 16))/255.0), green: CGFloat(((Float)((hexValue & 0xFF00) >> 8))/255.0), blue: CGFloat(((Float)(hexValue & 0xFF))/255.0), alpha: CGFloat(alpha))
            }
        } else {
            return UIColor(red: CGFloat(((Float)((hexValue & 0xFF0000) >> 16))/255.0), green: CGFloat(((Float)((hexValue & 0xFF00) >> 8))/255.0), blue: CGFloat(((Float)(hexValue & 0xFF))/255.0), alpha: CGFloat(alpha))
        };
    }
    
    /// 16进制字符串转为UIColor
    /// - Parameters:
    ///   - hexValue: 颜色 #ffffff
    ///   - darkHexValue: 仅当支持暗黑模式且设置该参数，暗黑模式下才会显示该颜色。否则依旧显示hexValue
    ///   - alpha: 透明度
    ///   - darkAlpha: 仅当支持暗黑模式且设置该参数，暗黑模式下才会使用该透明度.否则依旧显示alpha
    /// - Returns: 颜色对象
    static func color(hexString: String, darkHexString: String? = nil, alpha: CGFloat = 1.0, darkAlpha: CGFloat? = nil) -> UIColor {
        if #available(iOS 13.0, *) {
            let dyColor = UIColor { (traitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .light {
                    return self._getColor(hexString: hexString, alpha: alpha)
                } else {
                    let displayHex = darkHexString ?? hexString
                    let displayAlpha = darkAlpha ?? alpha
                    return self._getColor(hexString: displayHex, alpha: displayAlpha)
                }
            }
            return dyColor
        } else {
            return self._getColor(hexString: hexString, alpha: alpha)
        }
    }
}

private extension ZXKitUtilNameSpace where T : UIColor {
    ///通过十六进制字符串获取颜色
    static func _getColor(hexString: String, alpha: CGFloat = 1.0) -> UIColor {
        var hex = ""
        if hexString.hasPrefix("#") {
            hex = String(hexString.suffix(hexString.count - 1))
        } else if (hexString.hasPrefix("0x") || hexString.hasPrefix("0X")) {
            hex = String(hexString.suffix(hexString.count - 2))
        }
        assert(hex.count == 6, "hex value invalid")
        guard hex.count == 6 else {
            //不足6位不符合
            return UIColor.clear
        }

        var red: UInt32 = 0
        var green: UInt32 = 0
        var blue: UInt32 = 0

        var startIndex = hex.startIndex
        var endIndex = hex.index(hex.startIndex, offsetBy: 2)

        Scanner(string: String(hex[startIndex..<endIndex])).scanHexInt32(&red)

        startIndex = hex.index(hex.startIndex, offsetBy: 2)
        endIndex = hex.index(hex.startIndex, offsetBy: 4)
        Scanner(string: String(hex[startIndex..<endIndex])).scanHexInt32(&green)

        startIndex = hex.index(hex.startIndex, offsetBy: 4)
        endIndex = hex.index(hex.startIndex, offsetBy: 6)
        Scanner(string: String(hex[startIndex..<endIndex])).scanHexInt32(&blue)

        return UIColor(displayP3Red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: alpha)
    }
}
