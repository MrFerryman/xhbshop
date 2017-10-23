//
//  XHBussinessShopModel.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/22.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import ObjectMapper

let friendCalssesPath = (NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask,true).first!) + "friendCalssesPath.data"
let friendRecommendPath = (NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask,true).first!) + "friendRecommendPath.data"


class XHBussinessShopModel: NSObject, Mappable, NSCoding  {

    /// 店铺名称
    var name: String?
    
    /// 店铺id
    var shopId: String?
    
    /// 地址
    var address: String?
    
    /// 电话
    var phoneNum: String?
    
    /// 店铺图标
    var icon: String?
    
    /// 店铺分类ID
    var classify_id: String?
    
    /// 主营
    var mainBusy: String?
    
    /// 资质照片
    var idPicture: String?
    
    /// 是否是品牌店 0 - 个人店 1- 品牌店
    var shopType: String?
    
    /// 营业时间
    var busyTime: String?
    
    /// 商品数量
    var productNum: Int = 0
    
    /// 联系方式
    var telephone: String?
    
    /// 是否是品牌店 0 - 不是 1 - 是
    var isBranch: String?
    
    override init() {}
    
    required init?(map: Map) {    }
    
    func mapping(map: Map) {
        name <- map["name"]
        address <- map["address"]
        shopId <- map["id"]
        phoneNum <-  map["tel"]
        icon <- map["pic"]
        classify_id <- map["flid"]
        mainBusy <- map["zhuying"]
        idPicture <- map["zhizhi"]
        shopType <- map["dplx"]
        isBranch <- map["dplx"]
        busyTime <- map["yysj"]
        productNum <- map["num"]
        telephone <- map["phone"]
        isBranch <- map["is_branch"]
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(address, forKey: "address")
        aCoder.encode(shopId, forKey: "shopId")
        aCoder.encode(phoneNum, forKey: "phoneNum")
        aCoder.encode(icon, forKey: "icon")
        aCoder.encode(classify_id, forKey: "classify_id")
        aCoder.encode(mainBusy, forKey: "mainBusy")
        aCoder.encode(idPicture, forKey: "idPicture")
        aCoder.encode(shopType, forKey: "shopType")
        aCoder.encode(busyTime, forKey: "busyTime")
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as? String
        address = aDecoder.decodeObject(forKey: "address") as? String
        shopId = aDecoder.decodeObject(forKey: "shopId") as? String
        phoneNum = aDecoder.decodeObject(forKey: "phoneNum") as? String
        icon = aDecoder.decodeObject(forKey: "icon") as? String
        classify_id = aDecoder.decodeObject(forKey: "classify_id") as? String
        mainBusy = aDecoder.decodeObject(forKey: "mainBusy") as? String
        idPicture = aDecoder.decodeObject(forKey: "idPicture") as? String
        shopType = aDecoder.decodeObject(forKey: "shopType") as? String
        busyTime = aDecoder.decodeObject(forKey: "busyTime") as? String
    }
}
