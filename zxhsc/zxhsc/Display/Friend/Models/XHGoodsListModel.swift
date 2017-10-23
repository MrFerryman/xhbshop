//
//  XHGoodsListModel.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/23.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import ObjectMapper

class XHGoodsListModel: Mappable {

    /// 商品ID
    var goods_id: String?
    
    /// 标题
    var title: String?
    
    /// 图片
    var icon: String?
    
    /// 价格
    var price: String?
    
    /// 循环宝
    var xhb: CGFloat = 0
    
    /// 积分兑换
    var integral: CGFloat = 0.0
    
    /// 库存
    var stock: String?
    
    /// 描述
    var content: String?
    
    /// 是否被收藏 0 - 未收藏 1 - 已收藏
    var isCollected: Int = 0
    
    /// 收藏id
    var collected_id: String?
    
    /// 属性标识 0 - 无规格  1 - 有规格
    var propertyId: Int = 0
    
    init() {}
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        goods_id <- map["id"]
        title <- map["title"]
        icon <- map["pic"]
        price <- map["price"]
        integral <- map["jifenduihuan"]
        content <- map["content"]
        xhb <- map["xhd"]
        xhb <- map["xhb"]
        stock <- map["kucuen"]
        isCollected <- map["is_sc"]
        collected_id <- map["is_sc_id"]
        propertyId <- map["shuxing"]
    }
}
