//
//  XHUserEarningModel.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/18.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import ObjectMapper
let userEarningPath = (NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask,true).first!) + "/userEarning.data"

class XHUserEarningModel: NSObject, Mappable, NSCoding {
    
    /// 钱包余额
    var balance: CGFloat = 0
    
    /// 累计收益
    var accu_earning: CGFloat = 0
    
    /// 累计提现
    var accu_withdraw: String?
    
    /// 正在激励
    var xhb_now: CGFloat? = 0
    
    /// 今日新增
    var today_add: CGFloat? = 0
    
    /// 累计获得
    var accu_xhb: String?
    
    /// 冻结循环宝
    var xhb_freezed: CGFloat = 0.0
    
    /// 可提现余额
    var balance_activity: String?
    
    /// 不可体现余额
    var balance_unactivuty: String?
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(balance, forKey: "balance")
        aCoder.encode(accu_earning, forKey: "accu_earning")
        aCoder.encode(accu_withdraw, forKey: "accu_withdraw")
        aCoder.encode(xhb_now, forKey: "xhb_now")
        aCoder.encode(today_add, forKey: "today_add")
        aCoder.encode(accu_xhb, forKey: "accu_xhb")
        aCoder.encode(balance_activity, forKey: "balance_activity")
        aCoder.encode(balance_unactivuty, forKey: "balance_unactivuty")
    }
    
    required init?(coder aDecoder: NSCoder) {
        balance = aDecoder.decodeObject(forKey: "balance") as! CGFloat
        accu_earning = aDecoder.decodeObject(forKey: "accu_earning") as! CGFloat
        accu_withdraw = aDecoder.decodeObject(forKey: "accu_withdraw") as? String
        xhb_now = aDecoder.decodeObject(forKey: "xhb_now") as? CGFloat
        today_add = aDecoder.decodeObject(forKey: "today_add") as? CGFloat
        accu_xhb = aDecoder.decodeObject(forKey: "accu_xhb") as? String
        balance_activity = aDecoder.decodeObject(forKey: "balance_activity") as? String
        balance_unactivuty = aDecoder.decodeObject(forKey: "balance_unactivuty") as? String
    }
    
    override init() {}
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        balance <- map["all_money"]
        accu_earning <- map["ljsy"]
        accu_withdraw <- map["xj_ljtx"]
        xhb_now <- map["xhb"]
        today_add <- map["today"]
        accu_xhb <- map["ljxhb"]
        xhb_freezed <- map["ai10"]
        balance_activity <- map["money"]
        balance_unactivuty <- map["cost_money"]
    }
}
