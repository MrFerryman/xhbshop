//
//  XHMyCityModel.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/21.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import ObjectMapper

class XHMyCityModel: Mappable {

    /// 城市列表id
    var cityId: String?
    
    /// 省
    var province: String?
    
    /// 省代码
    var province_code: String?
    
    /// 市
    var city: String?
    
    /// 市代码
    var city_code: String?
    
    init() {}
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        cityId <- map["id"]
        province <- map["province"]
        province_code <- map["province_code"]
        city <- map["city"]
        city_code <- map["city_code"]
    }
}
