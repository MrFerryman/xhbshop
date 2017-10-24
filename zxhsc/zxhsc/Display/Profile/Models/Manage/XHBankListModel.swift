//
//  XHBankListModel.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/22.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import ObjectMapper

class XHBankListModel: Mappable {

    /// id
    var id: String?
    
    /// 名称
    var bank_name: String?
    
    /// 编码
    var bank_code: String?
    
    /// 分行
    var branch_bank_name: String?
    
    /// 省
    var province: String?
    
    /// 市
    var city: String?
    
    /// 银行卡详细地址代码
    var cnaps: String?
    
    init() {}
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["id"]
        bank_name <- map["bank_name"]
        bank_code <- map["bank_code"]
        branch_bank_name <- map["branch_bank_name"]
        province <- map["province"]
        city <- map["city"]
        cnaps <- map["cnaps"]
    }
}

