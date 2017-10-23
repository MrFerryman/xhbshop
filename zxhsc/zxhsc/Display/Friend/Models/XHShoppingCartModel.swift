//
//  XHShoppingCartModel.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/9.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import ObjectMapper

class XHShoppingCartModel: Mappable {

    /// id
    var id: String?
    
    /// 名称
    var name: String?
    
    /// 价格
    var price: String?
    
    /// 获得循环宝
    var xhb: CGFloat = 0
    
    /// 库存
    var stock: String?
    
    /// 图片
    var icon: String?
    
    /// 标签ID
    var tab_Id: String?
    
    /// 商品ID
    var goods_id: String?
    
    /// 购买数量
    var buyCount: String? = "1"
    
    /// 属性1
    var property1: String?
    
    /// 属性2
    var property2: String?
    
    /// 积分兑换
    var integral: String?
    
    /// 是否被选中
    var isSelected: Bool = false
    
    init() {}
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["sp_name"]
        price <- map["price"]
        xhb <- map["xhd"]
        tab_Id <- map["bqid"]
        stock <- map["kc"]
        icon <- map["pic"]
        goods_id <- map["spid"]
        buyCount <- map["shuliang"]
        property1 <- map["zdval"]
        property2 <- map["zdval1"]
    }
    
}
