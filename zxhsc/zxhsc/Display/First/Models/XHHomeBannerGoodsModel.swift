//
//  XHHomeBannerGoodsModel.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/28.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import ObjectMapper
let homeBannerGoodsPath = (NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask,true).first!) + "/homeBannerGoods.data"

class XHHomeBannerGoodsModel:  NSObject, Mappable, NSCoding {

    /// id
    var id: String?
    
    /// 图片
    var icon: String?
    
    /// 横屏图片
    var icon_horizontal: String?
    
    /// 价格底图
    var sub_img: String?
    
    /// 标题
    var title: String?
    
    /// 类型 1 - 横屏 0 - 竖屏
    var style: String? = "0"
    
    /// 商品数组
    var goodsArr: [XHSpecialFavModel] = []
    
    
    required init?(coder aDecoder: NSCoder) {
        id = aDecoder.decodeObject(forKey: "id") as? String
        icon = aDecoder.decodeObject(forKey: "icon") as? String
        icon_horizontal = aDecoder.decodeObject(forKey: "icon_horizontal") as? String
        sub_img = aDecoder.decodeObject(forKey: "sub_img") as? String
        title = aDecoder.decodeObject(forKey: "title") as? String
        style = aDecoder.decodeObject(forKey: "style") as? String
        goodsArr = aDecoder.decodeObject(forKey: "goodsArr") as! [XHSpecialFavModel]
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(icon, forKey: "icon")
        aCoder.encode(icon_horizontal, forKey: "icon")
        aCoder.encode(sub_img, forKey: "sub_img")
        aCoder.encode(title, forKey: "title")
        aCoder.encode(style, forKey: "style")
        aCoder.encode(goodsArr, forKey: "goodsArr")
    }
    
    override init() {}
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["s_id"]
        icon <- map["s_banner"]
        icon_horizontal <- map["t_banner"]
        sub_img <- map["s_img"]
        title <- map["s_title"]
        style <- map["s_display"]
        goodsArr <- map["goods_info"]
    }
}
