//
//  ZXKitUtil+UI.swift
//  ZXKitUtil
//
//  Created by Damon on 2020/7/2.
//  Copyright © 2020 Damon. All rights reserved.
//

import UIKit

//      A         B
//       _________
//      |         |
//      |         |
//       ---------
//      C         D
public enum ZXKitUtilGradientDirection {
    case minXToMaxX         //AC - BD
    case minYToMaxY         //AB - CD
    case minXMinYToMaxXMaxY //A - D
    case minXMaxYToMaxXminY //C - B
    
    
    @available(*, deprecated, message: "user minXToMaxX")
    case leftToRight            //AC - BD
    @available(*, deprecated, message: "user minYToMaxY")
    case topToBottom            //AB - CD
    @available(*, deprecated, message: "user minXMinYToMaxXMaxY")
    case leftTopToRightBottom   //A - D
    @available(*, deprecated, message: "user minXMaxYToMaxXminY")
    case leftBottomToRightTop   //C - B
}


public extension ZXKitUtil {
    ///获取当前的normalwindow
    func getCurrentNormalWindow() -> UIWindow? {
        var window:UIWindow? = UIApplication.shared.keyWindow
        if #available(iOS 13.0, *) {
            for windowScene:UIWindowScene in ((UIApplication.shared.connectedScenes as? Set<UIWindowScene>)!) {
                if windowScene.activationState == .foregroundActive {
                    window = windowScene.windows.first
                    for tmpWin in windowScene.windows {
                        if tmpWin.windowLevel == .normal {
                            window = tmpWin
                            break
                        }
                    }
                    break
                }
            }
        }
        if window == nil || window?.windowLevel != UIWindow.Level.normal {
            for tmpWin in UIApplication.shared.windows {
                if tmpWin.windowLevel == UIWindow.Level.normal {
                    window = tmpWin
                    break
                }
            }
        }
        return window
    }
    
    ///获取当前显示的vc
    func getCurrentVC(ignoreChildren: Bool = true) -> UIViewController? {
        let currentWindow = self.getCurrentNormalWindow()
        guard let window = currentWindow else { return nil }
        var vc: UIViewController?
        let frontView = window.subviews.first
        if let nextResponder = frontView?.next {
            if nextResponder is UIViewController {
                vc = nextResponder as? UIViewController
            } else {
                vc = window.rootViewController
            }
        } else {
            vc = window.rootViewController
        }
        
        while (vc is UINavigationController) || (vc is UITabBarController) {
            if vc is UITabBarController {
                let tabBarController = vc as! UITabBarController
                vc = tabBarController.selectedViewController
            } else if vc is UINavigationController {
                let navigationController = vc as! UINavigationController
                vc = navigationController.visibleViewController
            }
        }

        if !ignoreChildren, let children = vc?.children, children.count > 0 {
            return children.last
        }
        return vc
    }
    
    ///通过颜色获取纯色图片
    func getImage(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        var image: UIImage?
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        let context: CGContext? = UIGraphicsGetCurrentContext()
        if let context = context {
            context.setFillColor(color.cgColor)
            context.fill(rect)
            image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        return image ?? UIImage()
    }
    
    ///线性渐变
    func getLinearGradientImage(colors: [UIColor], directionType: ZXKitUtilGradientDirection, size: CGSize = CGSize(width: 100, height: 100)) -> UIImage {
        if (colors.count == 0) {
            return UIImage()
        } else if (colors.count == 1) {
            return self.getImage(color: colors.first!)
        }
        let gradientLayer = CAGradientLayer()
        var cgColors = [CGColor]()
        var locations = [NSNumber]()
        for i in 0..<colors.count {
            let color = colors[i]
            cgColors.append(color.cgColor)
            let location = Float(i)/Float(colors.count - 1)
            locations.append(NSNumber(value: location))
        }
        
        gradientLayer.colors = cgColors
        gradientLayer.locations = locations
        
        if (directionType == .leftToRight || directionType == .minXToMaxX) {
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        } else if (directionType == .topToBottom || directionType == .minYToMaxY){
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        } else if (directionType == .leftTopToRightBottom || directionType == .minXMinYToMaxXMaxY){
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        } else if (directionType == .leftBottomToRightTop || directionType == .minXMaxYToMaxXminY){
            gradientLayer.startPoint = CGPoint(x: 0, y: 1)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        }
        
        gradientLayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(gradientLayer.frame.size, false, 0)
        var gradientImage: UIImage?
        
        let context: CGContext? = UIGraphicsGetCurrentContext()
        if let context = context {
            gradientLayer.render(in: context)
            gradientImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        return gradientImage ?? UIImage()
    }
    
    ///角度渐变
    func getRadialGradientImage(colors: [UIColor], raduis: CGFloat, size: CGSize = CGSize(width: 100, height: 100)) -> UIImage {
        if (colors.count == 0) {
            return UIImage()
        } else if (colors.count == 1) {
            return self.getImage(color: colors.first!)
        }
        
        UIGraphicsBeginImageContext(size);
        let path = CGMutablePath()
        path.addArc(center: CGPoint(x: size.width/2.0, y: size.height / 2.0), radius: raduis, startAngle: 0, endAngle: CGFloat(Double.pi) * 2, clockwise: false)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        var cgColors = [CGColor]()
        var locations = [CGFloat]()
        for i in 0..<colors.count {
            let color = colors[i]
            cgColors.append(color.cgColor)
            let location = Float(i)/Float(colors.count - 1)
            locations.append(CGFloat(location))
        }
        
        let colorGradient = CGGradient(colorsSpace: colorSpace, colors: cgColors as CFArray, locations: locations)
        guard let gradient = colorGradient else { return UIImage() }
        
        let pathRect = path.boundingBox;
        let center = CGPoint(x: pathRect.midX, y: pathRect.midY)
        
        let currentContext: CGContext? = UIGraphicsGetCurrentContext()
        guard let context = currentContext else {
            return UIImage()
        }
        context.saveGState();
        context.addPath(path);
        context.clip()
        context.drawRadialGradient(gradient, startCenter: center, startRadius: 0, endCenter: center, endRadius: raduis, options: .drawsBeforeStartLocation);
        context.restoreGState();
        
        //        CGGradientRelease(gradient);
        //        CGColorSpaceRelease(colorSpace);
        //
        //        CGPathRelease(path);
        
        let img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return img ?? UIImage()
    }
}

///屏幕宽度
public var UIScreenWidth: CGFloat {
    return UIScreen.main.bounds.size.width
}

///屏幕高度
public var UIScreenHeight: CGFloat {
    return UIScreen.main.bounds.size.height
}

///状态栏高度
public var ZXKitUtil_StatusBar_Height: CGFloat {
    return UIApplication.shared.statusBarFrame.size.height
}

///底部Home Indicator高度
public var ZXKitUtil_HomeIndicator_Height: CGFloat {
    if #available(iOS 11.0, *) {
        if let cacheHomeIndicatorHeight = ZXKitUtil.shared.cacheHomeIndicatorHeight {
            return cacheHomeIndicatorHeight
        } else if let window = ZXKitUtil.shared.getCurrentNormalWindow() {
            let bottom = window.safeAreaInsets.bottom
            ZXKitUtil.shared.cacheHomeIndicatorHeight = bottom
            return bottom
        }
    }
    return 0
}

///导航栏高度
public func ZXKitUtil_Default_NavigationBar_Height(vc: UIViewController? = nil, cachePrior: Bool = true) -> CGFloat {
    if cachePrior, let cacheDefaultNavigationBarHeight = ZXKitUtil.shared.cacheDefaultNavigationBarHeight {
        return cacheDefaultNavigationBarHeight
    } else {
        var height: CGFloat = 0
        if let navigationController = vc?.navigationController {
            height = navigationController.navigationBar.frame.size.height
        } else {
            height = UINavigationController(nibName: nil, bundle: nil).navigationBar.frame.size.height
        }
        ZXKitUtil.shared.cacheDefaultNavigationBarHeight = height
        return height
    }
}

///tabbar高度
public func ZXKitUtil_Default_Tabbar_Height(vc: UIViewController? = nil, cachePrior: Bool = true) -> CGFloat {
    if cachePrior, let cacheDefaultTabbarHeight = ZXKitUtil.shared.cacheDefaultTabbarHeight {
        return cacheDefaultTabbarHeight
    } else {
        var height: CGFloat = 0
        if let tabbarViewController = vc?.tabBarController {
            height = tabbarViewController.tabBar.frame.size.height
        } else {
            height = UITabBarController(nibName: nil, bundle: nil).tabBar.frame.size.height
        }
        ZXKitUtil.shared.cacheDefaultTabbarHeight = height
        return height
    }
}

///状态栏和导航栏总高度
public func ZXKitUtil_Default_Nav_And_Status_Height(vc: UIViewController? = nil) -> CGFloat {
    return ZXKitUtil_Default_NavigationBar_Height(vc: vc) + ZXKitUtil_StatusBar_Height
}
