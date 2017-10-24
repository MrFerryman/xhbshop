//
//  XHMyBankModel.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/20.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import ObjectMapper

class XHMyBankModel: Mappable {

    /// 用户ID
    var userId: String?
    
    /// 姓名
    var name: String?
    
    /// 身份证号码
    var idCardNum: String?
    
    /// 电话号码
    var phoneNum: String?
    
    /// 卡号
    var cardNum: String?
    
    /// 支行
    var branchName: String?
    
    /// 银行卡详细信息编码
    var bank_Code: String?
    
    var bankDetal: XHBankDetailModel?
    
    /// 是否能够更改身份信息 0 - 未提现过 都可以更改 1 - 提现过 不可更改身份信息
    var canBeModified: String?
    
    init() {}
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        userId <- map["hyid"]
        phoneNum <- map["mobile"]
        cardNum <- map["cardid"]
        branchName <- map["yinhang"]
        name <- map["name"]
        idCardNum <- map["zhengid"]
        bank_Code <- map["cnaps"]
        canBeModified <- map["stat"]
    }
}

class XHBankDetailModel: Mappable {
    
    /// 银行名称
    var bank_name: String?
    
    /// 银行卡详细信息编码
    var bank_numb: String?
    
    /// 支行名
    var branch_bank_name: String?
    
    /// 省
    var province: String?
    
    /// 市
    var city: String?
    
    init() {}
    
     required init?(map: Map) {}
    
    func mapping(map: Map) {
        bank_name <- map["bank_name"]
        bank_numb <- map["cnaps"]
        branch_bank_name <- map["branch_bank_name"]
        province <- map["province"]
        city <- map["city"]
    }
}
