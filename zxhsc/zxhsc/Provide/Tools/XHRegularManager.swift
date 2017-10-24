//
//  XHRegularManager.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/7/14.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit


class XHRegularManager: NSObject {
    //MARK:验证手机号码是否正确
    class func isCalidateMobileNumber(num:String) -> Bool {
        
        do {
            let pattern: String = "^1[0-9]{10}$"
            let regex: NSRegularExpression = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
            let matches = regex.matches(in: num, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, num.characters.count))
            return matches.count > 0
        }
        catch {
            return false
        }
//        let mobile = "^1(3[0-9]|5[0-35-9]|8[025-9]|7[0-9]|4[0-9])\\d{8}$"
//        let  CM = "^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$"
//        let  CU = "^1(3[0-2]|5[256]|8[56])\\d{8}$"
//        let  CT = "^1((33|53|8[09])[0-9]|349)\\d{7}$"
//        let regextestmobile = NSPredicate(format: "SELF MATCHES %@",mobile)
//        let regextestcm = NSPredicate(format: "SELF MATCHES %@",CM )
//        let regextestcu = NSPredicate(format: "SELF MATCHES %@" ,CU)
//        let regextestct = NSPredicate(format: "SELF MATCHES %@" ,CT)
//        if ((regextestmobile.evaluate(with: num) == true)
//            || (regextestcm.evaluate(with: num)  == true)
//            || (regextestct.evaluate(with: num) == true)
//            || (regextestcu.evaluate(with: num) == true))
//        {
//            return true
//        }
//        else
//        {
//            return false
//        }
        
    }
    
    // MARK:- 验证昵称
    class func validateNickname(nickname: String) -> Bool {
        let nicknameRegex = "^[\u{4e00}-\u{9fa5}]{4,8}$"
        let passWordPredicate = NSPredicate(format: "SELF MATCHES%@", nicknameRegex)
        return passWordPredicate.evaluate(with: nickname)
    }
    
    // MARK:- 判断是否是邮箱
    class func isEmail(str: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailText = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailText.evaluate(with: str)
    }
    
    // MARK:- 判断是否是身份证
    class func isIdentifer(str: String) -> Bool {
        
        let idenRegex = "^(\\d{14}|\\d{17})(\\d|[xX])$"
        let iedenText = NSPredicate(format: "SELF MATCHES %@", idenRegex)
        return iedenText.evaluate(with: str)
    }
    
    // MARK:- 判断是否是银行卡
    class func isBankCardNumber(str: String) -> Bool {
        
        return XHJudgeBankCardNumber.judgeBankCardNumber(with:  str)
//        let idenRegex = "^(998801|998802|622525|622526|435744|435745|483536|528020|526855|622156|622155|356869|531659|622157|627066|627067|627068|627069)\\d{10}$"
////        "^\\d{16}|\\d{19}$"
//        let iedenText = NSPredicate(format: "SELF MATCHES %@", idenRegex)
//        return iedenText.evaluate(with: str)
    }
    
    // MARK:- 判断密码是否有效
    class func isValidPassword(psw: String) -> Bool {
        // 以字母开头，只能包含“字母”，“数字”，“下划线”，长度6~12
        let regex = "^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,18}"
        return XHRegularManager().isValidateByRegex(regex: regex, password: psw)
    }
    
    // MARK:- 判断是否是网址
    class func isValidationURL(str: String) -> Bool {
        let regexStr = "\\bhttps?://[a-zA-Z0-9\\-.]+(?::(\\d+))?(?:(?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?"
//        let regexStr = "((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)"
        let urlText = NSPredicate(format: "SELF MATCHES %@", regexStr)
        return urlText.evaluate(with: str)
    }
    
    private func isValidateByRegex(regex: String, password: String) -> Bool {
        let pre = NSPredicate(format: "SELF MATCHES %@", regex)
        return pre.evaluate(with: password)
    }
}
