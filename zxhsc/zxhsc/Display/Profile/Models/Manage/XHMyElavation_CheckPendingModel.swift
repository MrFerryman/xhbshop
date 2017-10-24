//
//  XHMyElavation_CheckPendingModel.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/10/9.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import ObjectMapper

class XHMyElavation_CheckPendingModel: Mappable {

    /// 订单id
    var order_id: String?
    
    /// 标题
    var title: String?
    
    /// 用户ID
    var user_id: String?
    
    /// 商品ID
    var goods_id: String?
    
    /// 商品图片
    var pro_icon: String?
    
    /// 评论内容
    var content: String?
    
    /// 评论等级 1 - 好评 2 - 中评 3 - 差评
    var level: String?
    
    /// 评论图片
    var pictures: String?
    
    /// 评论ID
    var id: String?
    
    init() {}
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        order_id <- map["o_id"]
        title <- map["title"]
        user_id <- map["hyid"]
        goods_id <- map["spid"]
        pro_icon <- map["pic_sp"]
        content <- map["content"]
        level <- map["state"]
        pictures <- map["pic"]
        id <- map["c_id"]
    }
}
