//
//  XHTabbarIconModel.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/10/18.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import ObjectMapper

class XHTabbarIconModel: Mappable {

    /// 首页 选中
    var home_selected: String?
    
    /// 首页 未选中
    var home_unselected: String?
    
    /// 类目 选中
    var class_selected: String?
    
    /// 类目 未选中
    var class_unselected: String?
    
    /// 店铺 选中
    var shop_selected: String?
    
    /// 店铺 未选中
    var shop_unselected: String?
    
    /// 发现 选中
    var discovery_selected: String?
    
    /// 发现 未选中
    var discovery_unselected: String?
    
    /// 我的 选中
    var profile_selected: String?
    
    /// 我的 未选中
    var profile_unselected: String?
    
    
    /// ---------------------
    /// 指数排行
    var scale_icon: String?
    
    /// 特惠专区
    var fav_icon: String?
    
    /// 汽车
    var car_icon: String?
    
    /// 房产
    var house_icon: String?
    
    init() {}
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        home_selected <- map["pic1"]
        home_unselected <- map["pic11"]
        class_selected <- map["pic2"]
        class_unselected <- map["pic22"]
        shop_selected <- map["pic3"]
        shop_unselected <- map["pic33"]
        discovery_selected <- map["pic4"]
        discovery_unselected <- map["pic44"]
        profile_selected <- map["pic5"]
        profile_unselected <- map["pic55"]
        /// ---------------------------------
        scale_icon <- map["pic6"]
        fav_icon <- map["pic7"]
        car_icon <- map["pic8"]
        house_icon <- map["pic9"]
    }
}
