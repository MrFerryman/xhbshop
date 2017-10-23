//
//  XHHTMLModel.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/17.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import ObjectMapper

class XHHTMLModel: NSObject, Mappable, NSCoding {

    /// html字符串
    var htmlStr: String?
    
    /// id
    var textId: Int = -1
    
    /// 标题
    var title: String?
    
    /// 具体内容
    var alternate_fields1: String?
    
    required init?(coder aDecoder: NSCoder) {
        title = aDecoder.decodeObject(forKey: "title") as? String
        alternate_fields1 = aDecoder.decodeObject(forKey: "alternate_fields1") as? String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: "title")
        aCoder.encode(alternate_fields1, forKey: "alternate_fields1")
    }
    
    override init() {}
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        textId <- map["id"]
        title <- map["title"]
        alternate_fields1 <- map["alternate_fields1"]
        htmlStr <- map["text"]
    }
}
