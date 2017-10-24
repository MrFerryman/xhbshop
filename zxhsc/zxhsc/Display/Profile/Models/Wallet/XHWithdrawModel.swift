//
//  XHWithdrawModel.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/20.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import ObjectMapper

class XHWithdrawModel: Mappable {

    /// 编号
    var number: String?
    
    /// 金额
    var money: String?
    
    /// 原因
    var reason: String?
    
    /// 时间
    var time: String?
    
    /// 状态码
    var status_count: Int?
    
    /// 状态
    var status: String?
    
    init() {}
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        number <- map["bianhao"]
        money <- map["jine"]
        reason <- map["reason"]
        time <- map["time"]
        status_count <- map["xianshi"]
        status <- map["zhuangtai"]
    }
}
