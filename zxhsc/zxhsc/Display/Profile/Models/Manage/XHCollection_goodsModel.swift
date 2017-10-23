//
//  XHCollection_goodsModel.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/21.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import ObjectMapper

class XHCollection_goodsModel: Mappable {

    /// 收藏ID
    var coll_id: String?
    
    /// 商品ID
    var goods_id: String?
    
    /// 图片
    var icon: String?
    
    /// 标题
    var title: String?
    
    /// 价格
    var price: String?
    
    /// 循环宝
    var xhb: CGFloat = 0
    
    init() {}
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        coll_id <- map["id"]
        goods_id <- map["spid"]
        icon <- map["pic"]
        price <- map["price"]
        title <- map["title"]
        xhb <- map["xhb"]
    }
}
