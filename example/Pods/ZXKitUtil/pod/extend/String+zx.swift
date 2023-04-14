//
//  String+zx.swift
//  ZXKitUtil
//
//  Created by Damon on 2020/7/3.
//  Copyright © 2020 Damon. All rights reserved.
//

import Foundation
#if canImport(CryptoKit)
import CryptoKit
#endif

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

    ///Range转换为NSRange
    func nsRange(from range: Range<String.Index>) -> NSRange? {
        guard let from = range.lowerBound.samePosition(in: object.utf16), let to = range.upperBound.samePosition(in: object.utf16) else { return nil }
        return NSRange(location: object.utf16.distance(from: object.utf16.startIndex, to: from), length: object.utf16.distance(from: from, to: to))
    }

    ///NSRange转换为Range
    func range(from nsRange: NSRange) -> Range<String.Index>? {
        guard let from16 = object.utf16.index(object.utf16.startIndex, offsetBy: nsRange.location, limitedBy: object.utf16.endIndex),
              let to16 = object.utf16.index(from16, offsetBy: nsRange.length,limitedBy: object.utf16.endIndex),
              let from = String.Index(from16, within: object),
              let to = String.Index(to16, within: object) else { return nil }
        return from ..< to
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
        return self.encodeString(from: .system(.nonLossyASCII), to: .system(.utf8))
    }

    /// 字符串转格式
    /// - Parameters:
    ///   - originType: 字符串原来的编码格式
    ///   - encodeType: 即将转换的编码格式
    /// - Returns: 转换成功的新字符串
    func encodeString(from originType: ZXKitUtilEncodeType = .system(.utf8), to encodeType: ZXKitUtilEncodeType) -> String? {
        let data = Data.zx.data(from: object, encodeType: originType)
        return data?.zx.encodeString(encodeType: encodeType)
    }
    
    /*
     AES加密
     model: CBC
     padding: PKCS7Padding
     AES block Size: 128
     **/
    func aesCBCEncrypt(password: String, ivString: String = "abcdefghijklmnop", encodeType: ZXKitUtilEncodeType = .base64) -> String? {
        let data = object.data(using:String.Encoding.utf8)
        return data?.zx.aesCBCEncrypt(password: password, ivString: ivString, encodeType: encodeType)
    }
    
    ///aes CBC解密
    func aesCBCDecrypt(password: String, ivString: String = "abcdefghijklmnop", encodeType: ZXKitUtilEncodeType = .base64) -> String? {
        let data = Data.zx.data(from: object, encodeType: encodeType)
        return data?.zx.aesCBCDecrypt(password: password, ivString: ivString)
    }

    //MARK: 加密
    func hashString(hashType: ZXKitUtilHashType, lowercase: Bool = true) -> String? {
        let data = object.data(using: String.Encoding.utf8)
        return data?.zx.hashString(hashType: hashType, lowercase: lowercase)
    }


    @available(*, deprecated, message: "Use hashString(hashType: ZXKitUtilHashType, lowercase: Bool) instead")
    func encryptString(encryType: ZXKitUtilHashType, lowercase: Bool = true) -> String? {
        return self.hashString(hashType: encryType, lowercase: lowercase)
    }
}

#if canImport(CryptoKit)
@available(iOS 13.0, *)
public extension ZXKitUtilNameSpace where T == String {
    /*
     AES加密
     model: GCM
     **/
    func aesGCMEncrypt(password: String, encodeType: ZXKitUtilEncodeType = .base64, nonce: AES.GCM.Nonce? = AES.GCM.Nonce()) -> String? {
        let data = object.data(using:String.Encoding.utf8)
        return data?.zx.aesGCMEncrypt(password: password, encodeType: encodeType, nonce: nonce)
    }

    /*
     AES加密
     model: GCM
     **/
    func aesGCMEncrypt(key: SymmetricKey, encodeType: ZXKitUtilEncodeType = .base64, nonce: AES.GCM.Nonce? = AES.GCM.Nonce()) -> String? {
        let data = object.data(using:String.Encoding.utf8)
        return data?.zx.aesGCMEncrypt(key: key, encodeType: encodeType, nonce: nonce)
    }

    /*
     AES解密
     model: GCM
     **/
    func aesGCMDecrypt(password: String, encodeType: ZXKitUtilEncodeType = .base64) -> String? {
        let data = Data.zx.data(from: object, encodeType: encodeType)
        return data?.zx.aesGCMDecrypt(password: password)
    }

    /*
     AES解密
     model: GCM
     **/
    func aesGCMDecrypt(key: SymmetricKey, encodeType: ZXKitUtilEncodeType = .base64) -> String? {
        let data = Data.zx.data(from: object, encodeType: encodeType)
        return data?.zx.aesGCMDecrypt(key: key)
    }

    ///HMAC计算
    func hmac(hashType: ZXKitUtilHashType, password: String, encodeType: ZXKitUtilEncodeType = .base64) -> String? {
        let data = object.data(using:String.Encoding.utf8)
        return data?.zx.hmac(hashType: hashType, password: password, encodeType: encodeType)
    }

    ///HMAC计算
    func hmac(hashType: ZXKitUtilHashType, key: SymmetricKey, encodeType: ZXKitUtilEncodeType = .base64) -> String? {
        let data = object.data(using:String.Encoding.utf8)
        return data?.zx.hmac(hashType: hashType, key: key, encodeType: encodeType)
    }
}
#endif
