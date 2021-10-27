//
//  ZXKitUtilNameSpace.swift
//  ZXKitUtil
//
//  Created by Damon on 2020/7/3.
//  Copyright © 2020 Damon. All rights reserved.
//

import Foundation

//实现命名空间需遵守的协议
public protocol ZXKitUtilNameSpaceWrappable {
    associatedtype WrapperType
    var zx: WrapperType { get }
    static var zx: WrapperType.Type { get }
}

public struct ZXKitUtilNameSpace <T> {
    let object: T       //存储的实例对象
    static var classObject: T.Type {
        return T.self
    }
    internal init(object: T) {
        self.object = object
    }
}

//协议默认的实现方式
public extension ZXKitUtilNameSpaceWrappable {
    var zx: ZXKitUtilNameSpace<Self> {
        return ZXKitUtilNameSpace(object: self)
    }

    static var zx: ZXKitUtilNameSpace<Self>.Type {
        return ZXKitUtilNameSpace.self
    }
}
