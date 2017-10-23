//
//  XHUnfreezedDetailModel.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/9/21.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import ObjectMapper

class XHUnfreezedDetailModel: Mappable {

    /// 用户
    var account: String?
    
    /// 循环宝
    var xhb: CGFloat = 0
    
    /// 时间
    var time: String?
    
    /// 内容
    var content: String?
    
    init() {}
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        account <- map["user"]
        xhb <- map["xhb"]
        time <- map["time"]
        content <- map["content"]
    }
}
