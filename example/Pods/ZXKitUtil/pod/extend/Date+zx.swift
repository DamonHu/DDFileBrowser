//
//  Date+zx.swift
//  ZXKitUtil
//
//  Created by Damon on 2020/7/3.
//  Copyright © 2020 Damon. All rights reserved.
//

import Foundation

extension Date: ZXKitUtilNameSpaceWrappable {

}

public extension ZXKitUtilNameSpace where T == Date {
    ///比较日期，设置是否忽略时间
    func compare(anotherDate: Date, ignoreTime: Bool = false) -> ComparisonResult {
        if !ignoreTime {
            return object.compare(anotherDate)
        } else {
            let calendar = Calendar.current
            if calendar.compare(object, to: anotherDate, toGranularity: Calendar.Component.year) != .orderedSame {
                return calendar.compare(object, to: anotherDate, toGranularity: Calendar.Component.year)
            }
            if calendar.compare(object, to: anotherDate, toGranularity: Calendar.Component.month) != .orderedSame {
                return calendar.compare(object, to: anotherDate, toGranularity: Calendar.Component.month)
            }
            return calendar.compare(object, to: anotherDate, toGranularity: Calendar.Component.day)
        }
    }
}
