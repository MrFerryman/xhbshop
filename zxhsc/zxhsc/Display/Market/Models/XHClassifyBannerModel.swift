//
//  XHClassifyBannerModel.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/24.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import ObjectMapper
let cl_bannerPath = (NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask,true).first!) + "/cl_bannerPath.data"
let home_bannerPath = (NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask,true).first!) + "/home_bannerPath.data"

class XHClassifyBannerModel: NSObject, Mappable, NSCoding {

    /// id
    var id: String?
    
    /// 图片
    var icon: String?
    
    /// 标题
    var title: String?
    
    /// 类型 1 - 专场  2 - 商品详情 3 - 店铺
    var type: Int?
    
    /// 网址
    var httpUrl: String?
    
    override init() {}
    
    required init?(map: Map) {}
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(icon, forKey: "icon")
        aCoder.encode(title, forKey: "title")
        aCoder.encode(type, forKey: "type")
        aCoder.encode(type, forKey: "httpUrl")
    }
    
    required init?(coder aDecoder: NSCoder) {
        title = aDecoder.decodeObject(forKey: "title") as? String
        id = aDecoder.decodeObject(forKey: "id") as? String
        icon = aDecoder.decodeObject(forKey: "icon") as? String
        type = aDecoder.decodeObject(forKey: "type") as? Int
        httpUrl = aDecoder.decodeObject(forKey: "httpUrl") as? String
    }

    func mapping(map: Map) {
        id <- map["id"]
        icon <- map["banner"]
        title <- map["title"]
        type <- map["type"]
        httpUrl <- map["desc"]
    }
}
