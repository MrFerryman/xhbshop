//
//  XHHelpModel.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/21.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import ObjectMapper

class XHHelpModel: NSObject, Mappable, NSCoding {

    /// id
    var help_id: String?
    
    /// 标题
    var title: String?
    
    /// 时间
    var time: String?
    
    /// 内容
    var content: String?
    
    required init?(coder aDecoder: NSCoder) {
        help_id = aDecoder.decodeObject(forKey: "help_id") as? String
        title = aDecoder.decodeObject(forKey: "title") as? String
        time = aDecoder.decodeObject(forKey: "time") as? String
        content = aDecoder.decodeObject(forKey: "content") as? String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(help_id, forKey: "help_id")
        aCoder.encode(title, forKey: "title")
        aCoder.encode(time, forKey: "time")
        aCoder.encode(time, forKey: "content")
    }
    
    override init() {}
    
    required init?(map: Map) {}

    func mapping(map: Map) {
        help_id <- map["id"]
        title <- map["title"]
        time <- map["time"]
        content <- map["content"]
    }
}
