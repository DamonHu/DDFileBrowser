//
//  String+zx.swift
//  ZXKitUtil
//
//  Created by Damon on 2020/7/3.
//  Copyright © 2020 Damon. All rights reserved.
//

import Foundation

extension String: ZXKitUtilNameSpaceWrappable {
    
}

public extension ZXKitUtilNameSpace where T == String {
    ///截取字符串
    func subString(rang: NSRange) -> String {
        var string = String()
        var subRange = rang
        if rang.location < 0 {
            subRange = NSRange(location: 0, length: rang.length)
        }
        if object.count < subRange.location + subRange.length {
            //直接返回完整的
            subRange = NSRange(location: subRange.location, length: object.count - subRange.location)
        }
        let startIndex = object.index(object.startIndex,offsetBy: subRange.location)
        let endIndex = object.index(object.startIndex,offsetBy: (subRange.location + subRange.length))
        let subString = object[startIndex..<endIndex]
        string = String(subString)
        return string
    }
    
    ///unicode转中文
    func unicodeDecode() -> String {
        let tempStr1 = object.replacingOccurrences(of: "\\u", with: "\\U")
        let tempStr2 = tempStr1.replacingOccurrences(of: "\"", with: "\\\"")
        let tempStr3 = "\"".appending(tempStr2).appending("\"")
        let tempData = tempStr3.data(using: String.Encoding.utf8)
        var returnStr:String = ""
        do {
            returnStr = try PropertyListSerialization.propertyList(from: tempData!, options: [.mutableContainers], format: nil) as! String
        } catch {
            print("unicodeDecode转义失败\(error)")
            return object
        }
        return returnStr.replacingOccurrences(of: "\\r\\n", with: "\n")
    }
    
    ///字符串转unicode
    func unicodeEncode() -> String? {
        guard let dataEncode = object.data(using: String.Encoding.nonLossyASCII) else { return nil }
        let unicodeStr = String(data: dataEncode, encoding: String.Encoding.utf8)
        return unicodeStr
    }
    
    ///base64解码
    func base64Decode(lowercase: Bool = true) -> String? {
        let decodeData = Data(base64Encoded: object)
        return decodeData?.zx.base64Decode(lowercase: lowercase)
    }
    
    ///aes256解密
    func aes256Decrypt(password: String, ivString: String = "abcdefghijklmnop") -> String? {
        let data = Data(base64Encoded: object)
        return data?.zx.aes256Decrypt(password: password, ivString: ivString)
    }
    
    ///aes256加密
    func aes256Encrypt(password: String, ivString: String = "abcdefghijklmnop") -> String? {
        let data = object.data(using:String.Encoding.utf8)
        return data?.zx.aes256Encrypt(password: password, ivString: ivString)
    }
    
    //MARK: 加密
    func encryptString(encryType: ZXKitUtilEncryType, lowercase: Bool = true) -> String? {
        let data = object.data(using: String.Encoding.utf8)
        return data?.zx.encryptString(encryType: encryType, lowercase: lowercase)
    }
}
