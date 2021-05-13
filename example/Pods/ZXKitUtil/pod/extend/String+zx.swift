//
//  String+zx.swift
//  ZXKitUtil
//
//  Created by Damon on 2020/7/3.
//  Copyright © 2020 Damon. All rights reserved.
//

import Foundation
import CommonCrypto

public enum ZXKitUtilEncryType {
    case md5
    case sha1
    case sha224
    case sha256
    case sha384
    case sha512
    case base64
}

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
    func unicodeEncode() -> String {
        let dataEncode = object.data(using: String.Encoding.nonLossyASCII)
        let unicodeStr = String(data: dataEncode!, encoding: String.Encoding.utf8)
        return unicodeStr!
    }
    
    ///base64解码
    func base64Decode(lowercase: Bool = true) -> String {
        let decodeData:Data? = Data(base64Encoded: object)
        guard let utf8Data = decodeData else{
            return ""
        }
        var string = String(data: utf8Data, encoding: String.Encoding.utf8) ?? ""
        if !lowercase {
            string = string.uppercased()
        }
        return string
    }
    
    ///aes256解密
    func aes256Decrypt(password: String, ivString: String = "abcdefghijklmnop") -> String {
        guard let data = Data(base64Encoded: object) else { return "" }
        let encryptData = self._crypt(data: data, password: password, ivString: ivString, option: CCOperation(kCCDecrypt))
        return String(data: encryptData, encoding: String.Encoding.utf8) ?? ""
    }
    
    ///aes256加密
    func aes256Encrypt(password: String, ivString: String = "abcdefghijklmnop") -> String {
        guard let data = object.data(using:String.Encoding.utf8) else { return "" }
        let encryptData = self._crypt(data: data, password: password, ivString: ivString, option: CCOperation(kCCEncrypt))
        return encryptData.base64EncodedString()
    }
    
    //MARK: 加密
    func encryptString(encryType: ZXKitUtilEncryType, lowercase: Bool = true) -> String {
        let data: Data = object.data(using: String.Encoding.utf8) ?? Data()
        var output = NSMutableString()
        
        switch encryType {
        case .md5:
            var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
            _ = data.withUnsafeBytes { (messageBytes) -> Bool in
                CC_MD5(messageBytes.baseAddress, CC_LONG(data.count), &digest)
                return true
            }

            output = NSMutableString(capacity: Int(CC_MD5_DIGEST_LENGTH))
            for byte in digest{
                output.appendFormat("%02x", byte)
            }
        case .sha1:
            var digest = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
            _ = data.withUnsafeBytes { (messageBytes) -> Bool in
                CC_SHA1(messageBytes.baseAddress, CC_LONG(data.count), &digest)
                return true
            }

            output = NSMutableString(capacity: Int(CC_SHA1_DIGEST_LENGTH))
            for byte in digest{
                output.appendFormat("%02x", byte)
            }
        case .sha224:
            var digest = [UInt8](repeating: 0, count: Int(CC_SHA224_DIGEST_LENGTH))
            _ = data.withUnsafeBytes { (messageBytes) -> Bool in
                CC_SHA224(messageBytes.baseAddress, CC_LONG(data.count), &digest)
                return true
            }

            output = NSMutableString(capacity: Int(CC_SHA224_DIGEST_LENGTH))
            for byte in digest{
                output.appendFormat("%02x", byte)
            }
        case .sha256:
            var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
            _ = data.withUnsafeBytes { (messageBytes) -> Bool in
                CC_SHA256(messageBytes.baseAddress, CC_LONG(data.count), &digest)
                return true
            }

            output = NSMutableString(capacity: Int(CC_SHA256_DIGEST_LENGTH))
            for byte in digest{
                output.appendFormat("%02x", byte)
            }
        case .sha384:
            var digest = [UInt8](repeating: 0, count: Int(CC_SHA384_DIGEST_LENGTH))
            _ = data.withUnsafeBytes { (messageBytes) -> Bool in
                CC_SHA384(messageBytes.baseAddress, CC_LONG(data.count), &digest)
                return true
            }

            output = NSMutableString(capacity: Int(CC_SHA384_DIGEST_LENGTH))
            for byte in digest{
                output.appendFormat("%02x", byte)
            }
        case .sha512:
            var digest = [UInt8](repeating: 0, count: Int(CC_SHA512_DIGEST_LENGTH))
            _ = data.withUnsafeBytes { (messageBytes) -> Bool in
                CC_SHA512(messageBytes.baseAddress, CC_LONG(data.count), &digest)
                return true
            }

            output = NSMutableString(capacity: Int(CC_SHA512_DIGEST_LENGTH))
            for byte in digest{
                output.appendFormat("%02x", byte)
            }
        case .base64:
            let base64Encoded:String = data.base64EncodedString()
            output = NSMutableString (string: base64Encoded)
        }
        
        if !lowercase {
            return String(output).uppercased()
        }
        return String(output)
    }
}

private extension ZXKitUtilNameSpace where T == String {
    func _crypt(data: Data, password: String, ivString: String, option: CCOperation) -> Data {
        guard let iv = ivString.data(using:String.Encoding.utf8) else { return Data() }
        guard let key = password.data(using:String.Encoding.utf8) else { return Data() }

        let cryptLength = data.count + kCCBlockSizeAES128
        var cryptData   = Data(count: cryptLength)

        let keyLength = kCCKeySizeAES256
        let options   = CCOptions(kCCOptionPKCS7Padding)

        var bytesLength = Int(0)

        let status = cryptData.withUnsafeMutableBytes { cryptBytes in
            data.withUnsafeBytes { dataBytes in
                iv.withUnsafeBytes { ivBytes in
                    key.withUnsafeBytes { keyBytes in
                        CCCrypt(option, CCAlgorithm(kCCAlgorithmAES), options, keyBytes.baseAddress, keyLength, ivBytes.baseAddress, dataBytes.baseAddress, data.count, cryptBytes.baseAddress, cryptLength, &bytesLength)
                    }
                }
            }
        }

        guard UInt32(status) == UInt32(kCCSuccess) else {
            return Data()
        }

        cryptData.removeSubrange(bytesLength..<cryptData.count)
        return cryptData
    }
}
