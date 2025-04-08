//
//  PermissionConfig.swift
//  DDUtils
//
//  Created by Damon on 2024/5/27.
//  Copyright © 2024 Damon. All rights reserved.
//

import Foundation

public enum DDUtilsPermissionType {
    case audio          //麦克风权限
    case video          //相机权限
    case photoLibrary   //相册权限
    case GPS            //定位权限
    case notification   //通知权限
}

public enum DDUtilsPermissionStatus {
    case authorized     //用户允许
    case restricted     //被限制修改不了状态,比如家长控制选项等
    case denied         //用户拒绝
    case notDetermined  //用户尚未选择
    case limited        //部分允许，iOS14之后增加的特性
}
