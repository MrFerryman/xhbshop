//
//  XHTempUserModel.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/9/15.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import ObjectMapper

class XHTempUserModel: Mappable {

    /// 用户ID
    var userId: String?
    
    /// 用户账号
    var account: String?
    
    /// 昵称
    var nickname: String?
    
    init() {}
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        userId <- map["id"]
        account <- map["user"]
        nickname <- map["nicheng"]
    }
}
