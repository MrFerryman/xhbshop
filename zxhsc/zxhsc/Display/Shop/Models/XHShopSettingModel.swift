//
//  XHShopSettingModel.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/10.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import ObjectMapper

class XHShopSettingModel: Mappable {
    
    /// 组标题
    var headerTitle: String?
    /// 组内详情数组
    var content: Array<XHShopSettingDetailModel>?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        headerTitle <- map["headerTitle"]
        content <- map["content"]
    }
    
}

class XHShopSettingDetailModel: Mappable {
    /// 标题
    var title: String?
    
    /// 子标题
    var subTitle: String?
    
    /// 类型
    var  style: Int = 0
    
    /// 图片地址
    var iconUrlStr: String?
    
    /// 图片
    var icon: UIImage?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        title <- map["title"]
        subTitle <- map["subTitle"]
        style <- map["style"]
    }
}
