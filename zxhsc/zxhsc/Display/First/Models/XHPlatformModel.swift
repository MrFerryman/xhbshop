//
//  XHPlatformModel.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/7/17.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import ObjectMapper

class XHPlatformModel: Mappable {

    /// id
    var id: String?
    /// 图片
    var icon: String?
    /// 标题
    var title: String?
    /// 子标题
    var subtitle: String?
    /// 是否开通
    var status_name: String?
    var status: String?
    
    init() {}
    
    required init?(map: Map) {}
   
    func mapping(map: Map) {
        id <- map["id"]
        icon <- map["pic"]
        title <- map["name"]
        subtitle <- map["description"]
        status_name <- map["sta_name"]
        status <- map["status"]
    }
    
}
