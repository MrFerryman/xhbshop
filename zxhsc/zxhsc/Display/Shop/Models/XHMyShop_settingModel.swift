//
//  XHMyShop_settingModel.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/9/15.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import ObjectMapper

class XHMyShop_settingModel: Mappable {

    /// id
    var id: String?
    
    /// 图片
    var logo: String?
    
    /// 名称
    var name: String?
    
    /// 主营业务
    var mainBusy: String?
    
    /// 省市
    var city: String?
    
    /// 详细地址
    var detailAddress: String?
    
    /// 营业时间
    var busyTime: String?
    
    /// 电话
    var phoneNum: String?
    
    /// 比例
    var scale: String?
    
    /// 店铺描述
    var description: String?
    
    /// 分类ID
    var class_id: String?
    
    /// 营业执照
    var license: String?
    
    /// 店内详情图片数组
    var shop_icons_Arr: Array<String> = []
    
    /// 店铺状态 0 - 个人 1 - 待审核 2 - 审核通过 3 - 审核拒绝
    var shop_status: String?
    
    init() {}
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        mainBusy <- map["zhuying"]
        city <- map["quyuid"]
        busyTime <- map["yysj"]
        phoneNum <- map["tel"]
        scale <- map["bili"]
        description <- map["jianjie"]
        detailAddress <- map["address"]
        class_id <- map["flid"]
        license <- map["zhizhi"]
        shop_icons_Arr <- map["picall"]
        logo <- map["pic"]
        shop_status <- map["shstat"]
    }
}
