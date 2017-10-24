//
//  XHUserModel.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/16.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import ObjectMapper
import SSKeychain

enum LoginStatus {
    case success  // 登录成功
    case failure  // 登录失败（用户名、手机号或密码错误）
}

let userAccountPath = (NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first!) + "/userAccount.data"

let userTokenName = "ZXHShop_userTokenName"

class XHUserModel: NSObject, Mappable, NSCoding {
    
    /// 用户ID
    var userId: String? {
        didSet {
            SSKeychain.setPassword(userId, forService: userTokenName, account: "USERID")
        }
    }
    
    /// 判断是否是商家 0 - 不是  1 - 个人店 2 - 品牌店
    var shopLevel: Int?
    
    /// 用户账号
    var account: String?
    
    /// token
    var token: String? {
        didSet {
            SSKeychain.setPassword(token, forService: userTokenName, account: "TOKEN")
        }
    }
    
    /// 昵称
    var nickname: String?
    
    /// 头像
    var iconName: String?
    
    /// 用户编号
    var numberStr: String?
    
    /// 商家ID 0 - 不是商家
    var shop_id: String?
    
    /// 用户等级
    var userLevel: String?
    
    /// 钱包余额
    var money: CGFloat = 0
    
    /// 当前可激励循环宝
    var xhb: CGFloat = 0
    
    /// 累计获得循环宝
    var ljxhb: String?
    
    /// 二维码图片
    var qrCodeStr: String?
    
    /// 支付密码是否设置 0 - 未设置 1 - 已设置
    var payPsw: Int?
    
    /// 登录请求是否成功
    var loginStatus: LoginStatus?
    
    required override init() {
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(userId, forKey: "userId")
        aCoder.encode(shopLevel, forKey: "shopLevel")
        aCoder.encode(account, forKey: "account")
        aCoder.encode(token, forKey: "token")
        aCoder.encode(nickname, forKey: "nickname")
        aCoder.encode(iconName, forKey: "iconName")
        aCoder.encode(numberStr, forKey: "numberStr")
        aCoder.encode(shop_id, forKey: "shop_id")
        aCoder.encode(userLevel, forKey: "userLevel")
        aCoder.encode(money, forKey: "money")
        aCoder.encode(xhb, forKey: "xhb")
        aCoder.encode(ljxhb, forKey: "ljxhb")
        aCoder.encode(qrCodeStr, forKey: "qrCodeStr")
        aCoder.encode(payPsw, forKey: "payPsw")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        userId = aDecoder.decodeObject(forKey: "userId") as? String
        shopLevel = aDecoder.decodeObject(forKey: "shopLevel") as? Int
        account = aDecoder.decodeObject(forKey: "account") as? String
        token = aDecoder.decodeObject(forKey: "token") as? String
        nickname = aDecoder.decodeObject(forKey: "nickname") as? String
        iconName = aDecoder.decodeObject(forKey: "iconName") as? String
        numberStr = aDecoder.decodeObject(forKey: "numberStr") as? String
        shop_id = aDecoder.decodeObject(forKey: "shop_id") as? String
        userLevel = aDecoder.decodeObject(forKey: "userLevel") as? String
        money = (aDecoder.decodeObject(forKey: "money") as? CGFloat)!
        xhb = aDecoder.decodeObject(forKey: "xhb") as! CGFloat
        ljxhb = aDecoder.decodeObject(forKey: "ljxhb") as? String
        qrCodeStr = aDecoder.decodeObject(forKey: "qrCodeStr") as? String
        payPsw = aDecoder.decodeObject(forKey: "payPsw") as? Int
    }
    
    required init?(map: Map) {
        SSKeychain.password(forService: userTokenName, account: "TOKEN")
        SSKeychain.password(forService: userTokenName, account: "USERID")        
    }

    func mapping(map: Map) {
        userId <- map["id"]
        shopLevel <- map["ai5"]
        account <- map["user"]
        token <- map["userkey"]
        nickname <- map["nicheng"]
        iconName <- map["tou"]
        numberStr <- map["bianhao"]
        shop_id <- map["shop_id"]
        userLevel <- map["level"]
        money <- map["money"]
        xhb <- map["xhb"]
        ljxhb <- map["ljxhb"]
        qrCodeStr <- map["ewm"]
        payPsw <- map["zhifupass"]
    }
}
