//
//  XHIntegralGoodsModel.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/9/6.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import ObjectMapper

class XHIntegralGoodsModel: Mappable {

    /// id
    var id: String?
    
    /// 标题
    var title: String?
    
    /// 图片
    var icon: String?
    
    /// 时间
    var time: String?
    
    /// 积分
    var integral: String?
    
    /// 价格
    var price: String?
    
    init() {}
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        icon <- map["pic"]
        integral <- map["jifenduihuan"]
        time <- map["time"]
        price <- map["price"]
    }
}
