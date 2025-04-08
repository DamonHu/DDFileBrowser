//
//  DDUtilsNameSpace.swift
//  DDUtils
//
//  Created by Damon on 2020/7/3.
//  Copyright © 2020 Damon. All rights reserved.
//

import Foundation

//实现命名空间需遵守的协议
public protocol DDUtilsNameSpaceWrappable {
    associatedtype WrapperType
    var dd: WrapperType { get }
    static var dd: WrapperType.Type { get }
}

public struct DDUtilsNameSpace <T> {
    let object: T       //存储的实例对象
    static var classObject: T.Type {
        return T.self
    }
    internal init(object: T) {
        self.object = object
    }
}

//协议默认的实现方式
public extension DDUtilsNameSpaceWrappable {
    var dd: DDUtilsNameSpace<Self> {
        return DDUtilsNameSpace(object: self)
    }

    static var dd: DDUtilsNameSpace<Self>.Type {
        return DDUtilsNameSpace.self
    }
}
