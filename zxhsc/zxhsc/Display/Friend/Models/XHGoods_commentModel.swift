//
//  XHGoods_commentModel.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/9/29.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import ObjectMapper

class XHGoods_commentModel: Mappable {

    /// 名称
    var name: String?
    
    /// 时间
    var time: String?
    
    /// 内容
    var content: String?
    
    /// 图片
    var imgArr: [String] = []
    
    /// 评论等级
    var star: String?
    
    /// 图片个数
    var picNum: Int = 0
    
    init() {}
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        name <- map["name"]
        time <- map["time"]
        content <- map["content"]
        imgArr <- map["pic"]
        star <- map["star"]
        picNum <- map["picnum"]
    }
}
