//
//  XHClassifyHotModel.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/24.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import ObjectMapper
let cl_hotPath = (NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask,true).first!) + "/cl_hotPath.data"

class XHClassifyHotModel: NSObject, Mappable, NSCoding {
    
    /// id 
    var id: String?
    
    /// 标题
    var title: String?
    
    /// 图片
    var icon: String?
    
    override init() {}
    
    required init?(map: Map) {}
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(icon, forKey: "icon")
        aCoder.encode(title, forKey: "title")
    }
    
    required init?(coder aDecoder: NSCoder) {
        title = aDecoder.decodeObject(forKey: "title") as? String
        id = aDecoder.decodeObject(forKey: "id") as? String
        icon = aDecoder.decodeObject(forKey: "icon") as? String
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        title <- map["name"]
        icon <- map["pic"]
    }

}
