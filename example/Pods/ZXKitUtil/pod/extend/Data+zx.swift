//
//  Data+zx.swift
//  ZXKitUtil
//
//  Created by Damon on 2021/5/31.
//  Copyright © 2021 Damon. All rights reserved.
//

import Foundation
import CommonCrypto
#if canImport(CryptoKit)
import CryptoKit
#endif

public enum ZXKitUtilHashType {
    case md5
    case sha1
    case sha224
    case sha256
    case sha384
    case sha512
}

public enum ZXKitUtilEncodeType {
    case hex
    case base64
    case system(String.Encoding)
}

extension Data: ZXKitUtilNameSpaceWrappable {
    
}

public extension ZXKitUtilNameSpace where T == Data {
    //string生成Data，兼容hex和base64
    static func data(from string: String, encodeType: ZXKitUtilEncodeType) -> Data? {
        switch encodeType {
            case .hex:
                let len = string.count / 2
                var data = Data(capacity: len)
                var i = string.startIndex
                for _ in 0..<len {
                    let j = string.index(i, offsetBy: 2)
                    let bytes = string[i..<j]
                    if var num = UInt8(bytes, radix: 16) {
                        data.append(&num, count: 1)
                    } else {
                        return nil
                    }
                    i = j
                }
                return data
            case .base64:
                return Data(base64Encoded: string)
            case .system(let encode):
                return string.data(using: encode)
        }
    }

    //编码
    func encodeString(encodeType: ZXKitUtilEncodeType) -> String? {
        switch encodeType {
            case .hex:
                return object.map { String(format: "%02hhx", $0) }.joined()
            case .base64:
                return object.base64EncodedString()
            case .system(let encode):
                return String(data: object, encoding: encode)
        }
    }

    ///hash计算
    func hashString(hashType: ZXKitUtilHashType, lowercase: Bool = true) -> String {
        var output = NSMutableString()
        switch hashType {
            case .md5:
                var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
                _ = object.withUnsafeBytes { (messageBytes) -> Bool in
                    CC_MD5(messageBytes.baseAddress, CC_LONG(object.count), &digest)
                    return true
                }

                output = NSMutableString(capacity: Int(CC_MD5_DIGEST_LENGTH))
                for byte in digest{
                    output.appendFormat("%02x", byte)
                }
            case .sha1:
                var digest = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
                _ = object.withUnsafeBytes { (messageBytes) -> Bool in
                    CC_SHA1(messageBytes.baseAddress, CC_LONG(object.count), &digest)
                    return true
                }

                output = NSMutableString(capacity: Int(CC_SHA1_DIGEST_LENGTH))
                for byte in digest{
                    output.appendFormat("%02x", byte)
                }
            case .sha224:
                var digest = [UInt8](repeating: 0, count: Int(CC_SHA224_DIGEST_LENGTH))
                _ = object.withUnsafeBytes { (messageBytes) -> Bool in
                    CC_SHA224(messageBytes.baseAddress, CC_LONG(object.count), &digest)
                    return true
                }

                output = NSMutableString(capacity: Int(CC_SHA224_DIGEST_LENGTH))
                for byte in digest{
                    output.appendFormat("%02x", byte)
                }
            case .sha256:
                var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
                _ = object.withUnsafeBytes { (messageBytes) -> Bool in
                    CC_SHA256(messageBytes.baseAddress, CC_LONG(object.count), &digest)
                    return true
                }

                output = NSMutableString(capacity: Int(CC_SHA256_DIGEST_LENGTH))
                for byte in digest{
                    output.appendFormat("%02x", byte)
                }
            case .sha384:
                var digest = [UInt8](repeating: 0, count: Int(CC_SHA384_DIGEST_LENGTH))
                _ = object.withUnsafeBytes { (messageBytes) -> Bool in
                    CC_SHA384(messageBytes.baseAddress, CC_LONG(object.count), &digest)
                    return true
                }

                output = NSMutableString(capacity: Int(CC_SHA384_DIGEST_LENGTH))
                for byte in digest{
                    output.appendFormat("%02x", byte)
                }
            case .sha512:
                var digest = [UInt8](repeating: 0, count: Int(CC_SHA512_DIGEST_LENGTH))
                _ = object.withUnsafeBytes { (messageBytes) -> Bool in
                    CC_SHA512(messageBytes.baseAddress, CC_LONG(object.count), &digest)
                    return true
                }

                output = NSMutableString(capacity: Int(CC_SHA512_DIGEST_LENGTH))
                for byte in digest{
                    output.appendFormat("%02x", byte)
                }
        }

        if !lowercase {
            return String(output).uppercased()
        }
        return String(output)
    }

    /*
     AES CBC加密
     model: CBC
     padding: PKCS7Padding
     AES block Size: 128
     **/
    func aesCBCEncrypt(password: String, ivString: String = "abcdefghijklmnop", encodeType: ZXKitUtilEncodeType = .base64) -> String? {
        assert(ivString.count == kCCKeySizeAES128, "iv should be \(kCCKeySizeAES128) bytes")
        assert(password.count == kCCKeySizeAES128 || password.count == kCCKeySizeAES192 || password.count == kCCKeySizeAES256, "Invalid key length. Available length is \(kCCKeySizeAES128) \(kCCKeySizeAES192) \(kCCKeySizeAES256)")
        let encryptData = self._crypt(data: object, password: password, ivString: ivString, option: CCOperation(kCCEncrypt))
        return encryptData?.zx.encodeString(encodeType: encodeType)
    }
    
    ///AES CBC解密
    func aesCBCDecrypt(password: String, ivString: String = "abcdefghijklmnop") -> String? {
        assert(ivString.count == kCCKeySizeAES128, "iv should be \(kCCKeySizeAES128) bytes")
        assert(password.count == kCCKeySizeAES128 || password.count == kCCKeySizeAES192 || password.count == kCCKeySizeAES256, "Invalid key length. Available length is \(kCCKeySizeAES128) \(kCCKeySizeAES192) \(kCCKeySizeAES256)")
        guard let encryptData = self._crypt(data: object, password: password, ivString: ivString, option: CCOperation(kCCDecrypt)) else {
            return nil
        }
        return String(data: encryptData, encoding: String.Encoding.utf8)
    }

    /**deprecated*/
    @available(*, deprecated, message: "Use hashString(hashType: ZXKitUtilHashType, lowercase: Bool) instead")
    func encryptString(encryType: ZXKitUtilHashType, lowercase: Bool = true) -> String {
        return self.hashString(hashType: encryType, lowercase: lowercase)
    }
}

#if canImport(CryptoKit)
@available(iOS 13.0, *)
public extension ZXKitUtilNameSpace where T == Data {
    //AES GCM加密
    func aesGCMEncrypt(password: String, encodeType: ZXKitUtilEncodeType = .base64, nonce: AES.GCM.Nonce? = AES.GCM.Nonce()) -> String? {
        assert(password.count == kCCKeySizeAES128 || password.count == kCCKeySizeAES192 || password.count == kCCKeySizeAES256, "Invalid key length. Available length is \(kCCKeySizeAES128) \(kCCKeySizeAES192) \(kCCKeySizeAES256)")
        return self.aesGCMEncrypt(key: SymmetricKey.init(data: password.data(using:String.Encoding.utf8)!), encodeType: encodeType, nonce: nonce)
    }

    ///AES GCM加密
    func aesGCMEncrypt(key: SymmetricKey, encodeType: ZXKitUtilEncodeType = .base64, nonce: AES.GCM.Nonce? = AES.GCM.Nonce()) -> String? {
        assert(key.bitCount / 8 == kCCKeySizeAES128 || key.bitCount / 8 == kCCKeySizeAES192 || key.bitCount / 8 == kCCKeySizeAES256, "Invalid key length. Available length is \(kCCKeySizeAES128) \(kCCKeySizeAES192) \(kCCKeySizeAES256)")
        guard let sealedBox = try? AES.GCM.seal(object, using: key, nonce:  nonce) else { return nil }
        guard let encode = sealedBox.combined else { return nil }
        return encode.zx.encodeString(encodeType: encodeType)
    }
    //AES GCM解密
    func aesGCMDecrypt(password: String) -> String? {
        assert(password.count == kCCKeySizeAES128 || password.count == kCCKeySizeAES192 || password.count == kCCKeySizeAES256, "Invalid key length. Available length is \(kCCKeySizeAES128) \(kCCKeySizeAES192) \(kCCKeySizeAES256)")
        let key = SymmetricKey.init(data: password.data(using:String.Encoding.utf8)!)
        return self.aesGCMDecrypt(key: key)
    }

    //AES GCM解密
    func aesGCMDecrypt(key: SymmetricKey) -> String? {
        assert(key.bitCount / 8 == kCCKeySizeAES128 || key.bitCount / 8 == kCCKeySizeAES192 || key.bitCount / 8 == kCCKeySizeAES256, "Invalid key length. Available length is \(kCCKeySizeAES128) \(kCCKeySizeAES192) \(kCCKeySizeAES256)")
        guard let sealedBox = try? AES.GCM.SealedBox.init(combined: object) else { return nil }
        guard let decry = try? AES.GCM.open(sealedBox, using: key) else { return nil }
        return String(decoding: decry, as: UTF8.self)
    }

    ///HMAC计算
    func hmac(hashType: ZXKitUtilHashType, password: String, encodeType: ZXKitUtilEncodeType = .base64) -> String? {
        let key = SymmetricKey.init(data: password.data(using:String.Encoding.utf8)!)
        return self.hmac(hashType: hashType, key: key, encodeType: encodeType)
    }

    ///HMAC计算
    func hmac(hashType: ZXKitUtilHashType, key: SymmetricKey, encodeType: ZXKitUtilEncodeType = .base64) -> String? {
        switch hashType {
            case .md5:
                let sign = HMAC<Insecure.MD5>.authenticationCode(for: object, using: key)
                return Data(sign).zx.encodeString(encodeType: encodeType)
            case .sha1:
                let sign = HMAC<Insecure.SHA1>.authenticationCode(for: object, using: key)
                return Data(sign).zx.encodeString(encodeType: encodeType)
            case .sha224:
                assert(false, "unsupported hash type")
                return nil
            case .sha256:
                let sign = HMAC<SHA256>.authenticationCode(for: object, using: key)
                return Data(sign).zx.encodeString(encodeType: encodeType)
            case .sha384:
                let sign = HMAC<SHA384>.authenticationCode(for: object, using: key)
                return Data(sign).zx.encodeString(encodeType: encodeType)
            case .sha512:
                let sign = HMAC<SHA512>.authenticationCode(for: object, using: key)
                return Data(sign).zx.encodeString(encodeType: encodeType)
        }
    }
}
#endif

private extension ZXKitUtilNameSpace where T == Data {
    func _crypt(data: Data, password: String, ivString: String, option: CCOperation) -> Data? {
        guard let iv = ivString.data(using:String.Encoding.utf8) else { return nil }
        guard let key = password.data(using:String.Encoding.utf8) else { return nil }
        
        let cryptLength = data.count + kCCBlockSizeAES128
        var cryptData   = Data(count: cryptLength)

        let keyLength = key.count
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
            return nil
        }

        cryptData.removeSubrange(bytesLength..<cryptData.count)
        return cryptData
    }
}


