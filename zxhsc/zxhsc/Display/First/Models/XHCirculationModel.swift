//
//  XHCirculationModel.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/28.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import ObjectMapper
let circulationPath = (NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask,true).first!) + "/circulation.data"

class XHCirculationModel: NSObject, Mappable, NSCoding {

    /// 指数
    var index: String?
    
    /// 商家
    var shopNum: String?
    
    /// 循环使者
    var memberCount: String?
    
    required init?(coder aDecoder: NSCoder) {
        index = aDecoder.decodeObject(forKey: "index") as? String
        shopNum = aDecoder.decodeObject(forKey: "shopNum") as? String
        memberCount = aDecoder.decodeObject(forKey: "memberCount") as? String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(index, forKey: "index")
        aCoder.encode(shopNum, forKey: "shopNum")
        aCoder.encode(memberCount, forKey: "memberCount")
    }
    
    override init() {}
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        index <- map["xunhuanzhishu"]
        shopNum <- map["shangjiacount"]
        memberCount <- map["xunhuanshizhe"]
    }
}
