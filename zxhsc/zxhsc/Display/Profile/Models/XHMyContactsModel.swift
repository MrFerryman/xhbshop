//
//  XHMyContactsModel.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/20.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import ObjectMapper

class XHMyContactsModel: Mappable {

    // 级别
    var level: String?
    
    // 用户
    var user: String?
    
    // 头像
    var iconStr: String?
    
    // 时间
    var time: String?
    
    init() {}
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        level <- map["jibie"]
        user <- map["user"]
        time <- map["time"]
        iconStr <- map["tou"]
    }
}
