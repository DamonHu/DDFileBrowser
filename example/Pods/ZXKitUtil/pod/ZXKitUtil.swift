//
//  ZXKitUtil.swift
//  ZXKitUtil
//
//  Created by Damon on 2020/7/2.
//  Copyright © 2020 Damon. All rights reserved.
//

import Foundation
import UIKit

open class ZXKitUtil: NSObject {
    private static let instance = ZXKitUtil()
    open class var shared: ZXKitUtil {
        return instance
    }

    //缓存的数据
    var cacheHomeIndicatorHeight: CGFloat?
    var cacheDefaultNavigationBarHeight: CGFloat?
    var cacheDefaultTabbarHeight: CGFloat?
}

public enum ZXMainThreadType {
    case `default`  //在主线程顺序执行，在其他线程异步回归到主线程（后续操作会优先执行，之后再执行任务，不阻塞界面）
    case async      //不论是否在主线程，都异步操作
    case sync       //在主线程顺序执行，在其他线程同步回归到主线程（后续操作等待当前任务完毕之后继续执行，可能会阻塞界面）
}

public extension ZXKitUtil {
    /// 获取class\struct的所有属性
    /// - Parameters:
    ///   - object: 需要获取的属性
    ///   - debug: 是否输入调试信息
    /// - Returns: 属性
    func getDictionary(object: Any, debug: Bool = false) -> [String: Any] {
        let reflection = Mirror(reflecting: object).children
        var dictionary = [String : Any]()

        if debug {
            print("--- ZXKitUtil.getDictionary(object:debug:) ---")
        }
        for (key, value) in reflection {
            if let key = key {
                if debug {
                    print("--- \(key) --- \(type(of: value)) --- \(value)")
                }
                dictionary[key] = value
            }
        }
        return dictionary
    }

    /// 主线程执行function
    /// - Parameters:
    ///   - type: ZXMainThreadType
    ///     case `default`  //在主线程顺序执行，在其他线程异步回归到主线程（即在function后面的任务会优先执行，之后再执行function任务，不阻塞界面）
    ///     case async      //不论是否在主线程，都异步操作 (即使当前在主线程，在function后面的任务会优先执行，之后再执行function任务，不阻塞界面)
    ///     case sync       //在主线程顺序执行，在其他线程同步回归到主线程（同一个线程中，function后面的任务会等待function任务完毕之后继续执行，可能会阻塞界面）
    ///   - function: 执行的函数
    func runInMainThread(type: ZXMainThreadType = .default, function: @escaping ()->Void) {
        switch type {
        case .default:
            if Thread.isMainThread {
                function()
            } else {
                DispatchQueue.main.async {
                    function()
                }
            }
        case .async:
            DispatchQueue.main.async {
                function()
            }
        case .sync:
            if Thread.isMainThread {
                function()
            } else {
                DispatchQueue.main.sync {
                    function()
                }
            }
        }
    }
}
