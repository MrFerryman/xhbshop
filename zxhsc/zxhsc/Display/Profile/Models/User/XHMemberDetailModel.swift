//
//  XHMemberDetailModel.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/18.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import ObjectMapper

class XHMemberDetailModel: Mappable {

    /// 用户编号
    var numberStr: String = ""
    
    /// 姓名
    var name: String = ""
    
    /// 昵称
    var nickname: String = ""
    
    /// 身份证号
    var idCardNum: String = ""
    
    /// 头像
    var iconName: String = ""
    
    /// 用户账号(手机号)
    var account: String = ""
    
    init() {}
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        numberStr <- map["bianhao"]
        name <- map["name"]
        nickname <- map["nicheng"]
        idCardNum <- map["shenfenzhenghao"]
        iconName <- map["tou"]
        account <- map["user"]
    }
}
