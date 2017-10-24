//
//  XHShopDetailModel.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/23.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import ObjectMapper

class XHShopDetailModel: Mappable {

    /// id
    var id: String?
    
    /// 名称
    var name: String?
    
    /// 电话
    var phoneNum: String?
    
    /// 图片
    var icon: String?
    
    /// 主营
    var mainBusy: String?
    
    /// 地址
    var address: String?
    
    /// 营业时间
    var busyTime: String?
    
    /// 让利比例
    var scale: CGFloat = 1
    
    /// 是否被收藏 0 - 未收藏  1 - 被收藏
    var isCollected: Int = 0
    
    /// 分类名称
    var className: String?
    
    /// 店铺类型
    var shopStyle: String?
    
    /// 所属用户
    var user: String?
    
    init() {}
    
    required init?(map: Map) {}

    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        phoneNum <- map["tel"]
        icon <- map["pic"]
        isCollected <- map["is_sc"]
        mainBusy <- map["zhuying"]
        address <- map["address"]
        busyTime <- map["yysj"]
        scale <- map["bili"]
        className <- map["flname"]
        shopStyle <- map["dplx"]
        user <- map["user"]
    }
}
