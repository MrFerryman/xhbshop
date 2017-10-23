//
//  XHLottoryModel.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/9/18.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import ObjectMapper

let lottoryListPath = (NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask,true).first!) + "/lottoryList.data"

class XHLottoryModel:NSObject, Mappable, NSCoding {

    /// 类型
    var type: String?
    
    /// 等级
    var level: String?
    
    /// 标题
    var title: String?
    
    /// 内容
    var content: String?
    
    /// 图片
    var icon: String?
    
    /// 奖品价值
    var value: String?
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(type, forKey: "type")
        aCoder.encode(level, forKey: "level")
        aCoder.encode(title, forKey: "title")
        aCoder.encode(content, forKey: "content")
        aCoder.encode(icon, forKey: "icon")
        aCoder.encode(value, forKey: "value")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        type = aDecoder.decodeObject(forKey: "type") as? String
        level = aDecoder.decodeObject(forKey: "level") as? String
        title = aDecoder.decodeObject(forKey: "title") as? String
        content = aDecoder.decodeObject(forKey: "content") as? String
        icon = aDecoder.decodeObject(forKey: "icon") as? String
        value = aDecoder.decodeObject(forKey: "value") as? String
    }
    
    override init() {}
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        type <- map["type"]
        level <- map["level"]
        title <- map["sp_name"]
        content <- map["content"]
        icon <- map["img"]
        value <- map["bonusvalue"]
    }
}
