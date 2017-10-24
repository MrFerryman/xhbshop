//
//  XHProfileManageModel.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/7/13.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import ObjectMapper

class XHProfileManageModel: Mappable {

    // 名称
    var mg_title: String?
    // 图标
    var mg_icon: String?
    // 对应控制器
    var mg_targetVc: String?
    
    init() {}
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        mg_title <- map["mg_title"]
        mg_icon <- map["mg_icon"]
        mg_targetVc <- map["mg_targetVc"]
    }
    
}
