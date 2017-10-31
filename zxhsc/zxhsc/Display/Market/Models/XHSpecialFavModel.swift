//
//  XHSpecialFavModel.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/24.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import ObjectMapper
let homeRecommend_GoodsListPath = (NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask,true).first!) + "/homeRecommend_GoodsList.data"

class XHSpecialFavModel: NSObject, Mappable, NSCoding {

    /// id
    var id: String?
    
    /// 标题
    var title: String?
    
    /// 图片
    var icon: String?
    
    /// 价格
    var price: String?
    
    /// 循环宝
    var xhb: CGFloat = 0
    var xhbStr: String?
    
    /// 倍数
    var times: CGFloat = 0
    var timesStr: String?
    
    /// 积分
    var integral: String?
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(icon, forKey: "icon")
        aCoder.encode(title, forKey: "title")
        aCoder.encode(price, forKey: "price")
        aCoder.encode(xhb, forKey: "xhb")
        aCoder.encode(integral, forKey: "integral")
    }
    
    required init?(coder aDecoder: NSCoder) {
        title = aDecoder.decodeObject(forKey: "title") as? String
        id = aDecoder.decodeObject(forKey: "id") as? String
        icon = aDecoder.decodeObject(forKey: "icon") as? String
        price = aDecoder.decodeObject(forKey: "price") as? String
        xhb = aDecoder.decodeObject(forKey: "xhb") as! CGFloat
        integral = aDecoder.decodeObject(forKey: "integral") as? String
    }
    
    override init() {}
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["id"]
        id <- map["spid"]
        title <- map["title"]
        title <- map["sp_title"]
        icon <- map["pic"]
        icon <- map["sp_pic"]
        price <- map["price"]
        price <- map["sp_price"]
        xhb <- map["xhd"]
        xhb <- map["xhb"]
        xhbStr <- map["xhd"]
        times <- map["times"]
        timesStr <- map["times"]
        integral <- map["jifen"]
    }
}
