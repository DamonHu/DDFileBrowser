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
    static func getImage(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return ZXKitUtil.shared.getImage(color: color, size: size)
    }
    
    ///线性渐变
    static func getLinearGradientImage(colors: [UIColor], directionType: ZXKitUtilGradientDirection, size: CGSize = CGSize(width: 100, height: 100)) -> UIImage {
        return ZXKitUtil.shared.getLinearGradientImage(colors: colors, directionType: directionType, size: size)
    }
    
    ///角度渐变
    static func getRadialGradientImage(colors: [UIColor], raduis: CGFloat, size: CGSize = CGSize(width: 100, height: 100)) -> UIImage {
        return ZXKitUtil.shared.getRadialGradientImage(colors: colors, raduis: raduis, size: size)
    }
    
    ///通过view专为图片
    static func getImage(view: UIView) -> UIImage? {
        if view is UIScrollView {
            return self._getImage(scrollView: view as! UIScrollView)
        } else {
            return self._getImage(view: view)
        }
    }
    
    ///合成两张图片合成
    static func combineImage(bgImage: UIImage, frontImage: UIImage?, frontPosition: CGPoint = CGPoint(x: 0, y: 0), frontSize: CGSize = CGSize.zero, bounderWidth: CGFloat = 0, bounderColor: UIColor = UIColor.clear) -> UIImage? {
        //生成图片大小，如果为0，就根据图片判断
        let frontImageWidth = frontSize.width == 0 ? frontImage?.size.width ?? 0 : frontSize.width
        let frontImageHeight = frontSize.height == 0 ? frontImage?.size.height ?? 0 : frontSize.height
        
        let imageSize = CGSize(width: max(bgImage.size.width, frontImageWidth) + bounderWidth * 2, height: max(bgImage.size.height, frontImageHeight) + bounderWidth * 2)
        
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0);
        let context = UIGraphicsGetCurrentContext();
        if let imageContext = context {
            //画背景色
            imageContext.addRect(CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height));
            bounderColor.set()
            imageContext.fillPath()
            //背景图片
            bgImage.draw(in: CGRect(x: bounderWidth, y: bounderWidth, width: bgImage.size.width, height: bgImage.size.height))
            //前面的图
            if let frontImg = frontImage {
                let drwqF =  CGRect(x: frontPosition.x + bounderWidth, y: frontPosition.y + bounderWidth, width: frontImageWidth, height:  frontImageHeight)
                frontImg.draw(in: drwqF)
            }
            let image = UIGraphicsGetImageFromCurrentImageContext();//返回一个基于当前图形上下文的图片
            UIGraphicsEndImageContext();
            return image;
        } else {
            return nil
        }
    }
    
}

private extension ZXKitUtilNameSpace where T : UIImage {
    static func _getImage(view: UIView) -> UIImage? {
        view.layoutIfNeeded()
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0)
        let context = UIGraphicsGetCurrentContext();
        if let imageContext = context {
            view.layer.render(in: imageContext)
            let image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            view.layer.contents = nil;
            return image;
        } else {
            return nil
        }
    }
    
    static func _getImage(scrollView: UIScrollView) -> UIImage? {
        scrollView.layoutIfNeeded()
        //备份位置和父类
        let backupFrame = scrollView.frame
        let backupContentOffset = scrollView.contentOffset
        let backupSuperView = scrollView.superview
        
        scrollView.contentOffset = CGPoint.zero
        
        scrollView.frame = CGRect(x: 0, y:0, width:  max(scrollView.contentSize.width, backupFrame.size.width), height: max(scrollView.contentSize.height, backupFrame.size.height))
        
        let tempSuperView = UIView(frame: CGRect(origin: CGPoint.zero, size:  scrollView.frame.size))
        scrollView.removeFromSuperview()
        tempSuperView.addSubview(scrollView)
        
        let image = self.getImage(view: tempSuperView)
        
        scrollView.removeFromSuperview()
        backupSuperView?.addSubview(scrollView)
        scrollView.contentOffset = backupContentOffset
        
        return image
    }
}
