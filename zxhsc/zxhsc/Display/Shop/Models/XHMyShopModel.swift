//
//  XHMyShopModel.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/9/13.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import ObjectMapper

class XHMyShopModel: Mappable {

    /// 店铺ID
    var shop_id: String?
    
    /// 名称
    var name: String?
    
    /// 让利比例
    var scale: String?
    
    /// logo
    var logo: String?
    
    /// 营业时间
    var busyTime: String?
    
    /// 是否完善店铺 1 - 已完善 否则 - 不完善
    var isPerfect: String?
    
    /// 店铺类型
    var shopType: String?
    
    /// 主营
    var mainBusy: String?
    
    /// 店铺状态 0 - 正在审核 1 - 审核通过 2 - 未通过审核 
    var shop_status: Int?
    
    /// 审核不通过的留言
    var judge_content: String?
    
    init() {}
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        shop_id <- map["shop_id"]
        name <- map["name"]
        scale <- map["bili"]
        logo <- map["logo"]
        busyTime <- map["yysj"]
        isPerfect <- map["status"]
        shopType <- map["dplx"]
        mainBusy <- map["zhuying"]
        shop_status <- map["shstat"]
        judge_content <- map["shcontent"]
    }
}
