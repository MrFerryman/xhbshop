//
//  XHMyAdressModel.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/20.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import ObjectMapper

class XHMyAdressModel: Mappable {

    /// 用户ID
    var userId: String?
    
    /// 地址ID
    var address_id: String?
    
    /// 街道
    var street: String?
    
    /// 联系电话
    var phoneNum: String?
    
    /// 是否默认 1 - 是 0 - 不是
    var isDefault: String = "0"
    
    /// 市区
    var city: String?
    
    /// 收件人
    var addressee: String?
    
    /// 时间
    var time: String?
    
    init() {}
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        userId <- map["hyid"]
        address_id <- map["id"]
        street <- map["jiedao"]
        phoneNum <- map["lianxidianhua"]
        isDefault <- map["moren"]
        city <- map["shiqu"]
        addressee <- map["shoujianren"]
        time <- map["time"]
    }
}
