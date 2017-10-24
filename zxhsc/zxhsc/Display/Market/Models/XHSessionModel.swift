//
//  XHSessionModel.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/25.
//  Copyright © 2017年 zxhsc. All rights reserved.
//  专场模型

import UIKit
import ObjectMapper

class XHSessionModel: Mappable {

    /// id
    var id: String?
    
    /// banner
    var banner: String?
    
    /// 标题
    var title: String?
    
    var goodsArr: [XHSpecialFavModel] = []
    
    init() {}
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["s_id"]
        banner <- map["s_banner"]
        title <- map["s_title"]
        goodsArr <- map["goods_info"]
    }
}
