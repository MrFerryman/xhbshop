//
//  XHClassifyChildModel.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/25.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import ObjectMapper

class XHClassifyChildModel: Mappable {

    /// id
    var id: String?
    
    /// 标题
    var title: String?
    
    /// 图片
    var icon: String?
    
    init() {}
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        title <- map["name"]
        icon <- map["pic"]
    }

}
