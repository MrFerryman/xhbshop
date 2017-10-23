//
//  XHScaleRankModel.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/29.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import ObjectMapper

class XHScaleRankModel: Mappable {

    /// id
    var id: String?
    
    /// 区域名称
    var title: String?
    
    /// 指数
    var scale: String?
    
    init() {}
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["id"]
        title <- map["area"]
        scale <- map["assignzs"]
    }
}
