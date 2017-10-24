//
//  XHDiscoveryGoodsModel.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/9/18.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import ObjectMapper
let discoveryGoodsPath = (NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask,true).first!) + "/discoveryGoods.data"

class XHDiscoveryGoodsModel:NSObject, Mappable, NSCoding {

    /// ID
    var id: String?
    
    /// 标题
    var title: String?
    
    /// 图片
    var icon: String?
    
    /// 积分兑换
    var gift: String?
    
    /// 时间
    var time: String?
    
    /// 价格
    var price: String?
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(title, forKey: "title")
        aCoder.encode(icon, forKey: "icon")
        aCoder.encode(gift, forKey: "gift")
        aCoder.encode(time, forKey: "time")
        aCoder.encode(price, forKey: "price")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        id = aDecoder.decodeObject(forKey: "id") as? String
        title = aDecoder.decodeObject(forKey: "title") as? String
        icon = aDecoder.decodeObject(forKey: "icon") as? String
        gift = aDecoder.decodeObject(forKey: "gift") as? String
        time = aDecoder.decodeObject(forKey: "time") as? String
        price = aDecoder.decodeObject(forKey: "price") as? String
    }
    
    override init() {}
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        icon <- map["pic"]
        gift <- map["jifenduihuan"]
        time <- map["time"]
        price <- map["price"]
    }
}
