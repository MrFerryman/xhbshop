//
//  XHNewsModel.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/21.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import ObjectMapper

class XHNewsModel: Mappable {
    
    /// id
    var news_id: String?
    
    /// 标题
    var title: String?
    
    /// 时间
    var time: String?
    
    /// 图片
    var icon: String?
    
    /// 内容
    var content: String?
    
    /// 概要
    var abstract: String?
    
    init() {}
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        news_id <- map["id"]
        title <- map["title"]
        time <- map["time"]
        content <- map["content"]
        icon <- map["pic"]
        abstract <- map["abstract"]
    }

}
