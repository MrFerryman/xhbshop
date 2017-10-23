//
//  XHCollection_shopModel.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/21.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import ObjectMapper

class XHCollection_shopModel: Mappable {

    /// 收藏ID
    var coll_id: String?
    
    /// 店铺ID
    var shop_id: String?
    
    /// 店铺名称
    var name: String?
    
    /// 图片
    var icon: String?
    
    /// 电话
    var phoneNum: String?
    
    /// 主营
    var main_buss: String?
    
    /// 营业时间
    var busy_time: String?
    
    init() {}
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        coll_id <- map["id"]
        shop_id <- map["shopid"]
        name <- map["name"]
        icon <- map["pic"]
        phoneNum <- map["tel"]
        main_buss <- map["zhuying"]
        busy_time <- map["yysj"]
    }
}
