//
//  XHClassifyModel.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/24.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import ObjectMapper


let classifyListPath = (NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask,true).first!) + "/classifyListPath.data"

class XHClassifyModel: NSObject, Mappable, NSCoding {

    /// 标题
    var title: String?
    
    /// id
    var id: String?
    
    override init() {}
    
    required init?(map: Map) {}
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: "title")
        aCoder.encode(id, forKey: "id")
    }
    
    required init?(coder aDecoder: NSCoder) {
        title = aDecoder.decodeObject(forKey: "title") as? String
        id = aDecoder.decodeObject(forKey: "id") as? String
    }
    
    func mapping(map: Map) {
        title <- map["name"]
        id <- map["id"]
    }
}
