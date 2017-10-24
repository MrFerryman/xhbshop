//
//  XHNetworkTools+Encrypt.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/1.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

extension XHNetworkTools {
    
    /// MD5加密字符串后转为字母大写
    ///
    /// - Parameter str: 需要加密的str
    /// - Returns: MD5字母大写的字符串
    fileprivate func uppercasedMD5String(str:String) -> String {
        
        if #available(iOS 9.0, *) {
            return md5String(str: str).localizedUppercase
        } else {
            return md5String(str: str).uppercased()
        }
    }
    
    /// MD5加密字符串
    ///
    /// - Parameter str: 需要加密的str
    /// - Returns: MD5字符串
    func md5String(str:String) -> String {
        
        let cStr = str.cString(using: String.Encoding.utf8);
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
        CC_MD5(cStr!,(CC_LONG)(strlen(cStr!)), buffer)
        let md5String = NSMutableString();
        for i in 0 ..< 16{
            md5String.appendFormat("%02x", buffer[i])
        }
        free(buffer)
        return md5String as String
    }

}

extension XHNetworkTools {
    /// 对字符串进行UrlEncode转译
    ///
    /// - Parameter str: String
    /// - Returns: UrlEncode转译后的字符串
    func encodeUrlString(str:String) -> String {
        
        let customAllowedSet =  NSCharacterSet(charactersIn:"=\"#+%/<>?@\\^`{| }").inverted
        
        let encodeStr = str.addingPercentEncoding(withAllowedCharacters: customAllowedSet)!
        
        return encodeStr
    }
}
