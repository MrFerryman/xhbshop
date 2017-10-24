//
//  XHSalesReturnModel.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/9/5.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import ObjectMapper

class XHSalesReturnModel: Mappable {

    /// id
    var id: String?
    
    /// 名称
    var title: String?
    
    /// 是否被选中
    var isSele: Bool = false
    
    init() {}
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        isSele <- map["isSelected"]
    }
}
