//
//  XHMyValuationModel.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/9/29.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import ObjectMapper

class XHMyValuationModel: Mappable {

    /// ------- 待评价 ------
    /// 订单ID
    var order_id: String?
    
    /// 商品名称
    var pro_name: String?
    
    /// 用户ID
    var userId: String?
    
    /// 商品数量
    var pro_num: String?
    
    /// 商品价格
    var pro_price: String?
    
    /// 商品ID
    var pro_id: String?
    
    /// 商品图片
    var pro_icon: String?
    
    /// 评论的状态
    var val_status: String?
    
    init() {}
    
    required init?(map: Map) {    }
    
    func mapping(map: Map) {
        order_id <- map["o_id"]
        pro_name <- map["title"]
        userId <- map["hyid"]
        pro_num <- map["shuliang"]
        pro_price <- map["price"]
        pro_id <- map["spid"]
        pro_icon <- map["pic"]
        val_status <- map["state"]
    }
}
