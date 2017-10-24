//
//  XHFriendClassModel.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/7/27.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import ObjectMapper

class XHFriendClassModel: NSObject, Mappable, NSCoding {
    /// 名称
    var cl_title: String?
    /// 图标
    var cl_icon: String?
    /// id
    var cl_id: String?
    /// 时间
    var cl_time: String?
    
    override init() {}
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        cl_title <- map["name"]
        cl_icon <- map["pic"]
        cl_id <- map["id"]
        cl_time <- map["time"]
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(cl_title, forKey: "cl_title")
        aCoder.encode(cl_icon, forKey: "cl_icon")
        aCoder.encode(cl_id, forKey: "cl_id")
        aCoder.encode(cl_time, forKey: "cl_time")
    }
    
    required init?(coder aDecoder: NSCoder) {
        cl_title = aDecoder.decodeObject(forKey: "cl_title") as? String
        cl_icon = aDecoder.decodeObject(forKey: "cl_icon") as? String
        cl_id = aDecoder.decodeObject(forKey: "cl_id") as? String
        cl_time = aDecoder.decodeObject(forKey: "cl_time") as? String
    }
    
}
