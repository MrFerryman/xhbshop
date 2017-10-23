//
//  XHGoodsDetailModel.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/23.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import ObjectMapper

class XHGoodsDetailModel: Mappable {

    /// 图片数组
    var iconArr: [String] = []
    
    /// 商品详情
    var detailData: XHGoodsListModel?
    
    /// 所属商家
    var supplier: XHBussinessShopModel?
    
    /// 属性数组
    var propertyArr: [XHGoodsPropertyModel] = []
    
    /// 是否有属性 0 - 无属性 1 - 有属性
    var havePro: Int = 0
    
    init() {}
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        iconArr <- map["pic"]
        detailData <- map["detail"]
        supplier <- map["gys"]
        havePro <- map["flag"]
        propertyArr <- map["value"]
    }
}

class XHGoodsPropertyModel: Mappable {
    
    /// id
    var id: String?
    
    /// 属性值
    var value: String?
    
    /// 库存
    var stock: String?
    
    init() {}
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["id"]
        value <- map["zdval"]
        value <- map["zdval1"]
        stock <- map["kc"]
    }
}
