//
//  XHXHB_UnfreezedModel.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/9/21.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import ObjectMapper

let unfreezedXHBPath = (NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask,true).first!) + "/unfreezedXHBPath.data"

class XHXHB_UnfreezedModel: NSObject, Mappable, NSCoding {

    /// 今日解冻
    var today_freezed: CGFloat = 0
    
    /// 累计解冻
    var total_freezed: CGFloat = 0
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(today_freezed, forKey: "today_freezed")
        aCoder.encode(total_freezed, forKey: "total_freezed")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        today_freezed = aDecoder.decodeObject(forKey: "today_freezed") as! CGFloat
        total_freezed = aDecoder.decodeObject(forKey: "total_freezed") as! CGFloat
    }
    
    override init() {}
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        today_freezed <- map["xhbrelease_today"]
        total_freezed <- map["xhbrelease_total"]
    }
}
