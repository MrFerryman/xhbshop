//
//  XHHomeNoticeModel.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/28.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import ObjectMapper
let homeNoticePath = (NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask,true).first!) + "/homeNotice.data"


class XHHomeNoticeModel: NSObject, Mappable, NSCoding {

    /// 详细内容
    var detail: XHHelpModel?
    
    /// 更新
    var update: String?
    
    /// 通告
    var notice: String?
    
    required init?(coder aDecoder: NSCoder) {
        detail = aDecoder.decodeObject(forKey: "detail") as? XHHelpModel
        update = aDecoder.decodeObject(forKey: "update") as? String
        notice = aDecoder.decodeObject(forKey: "notice") as? String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(detail, forKey: "detail")
        aCoder.encode(update, forKey: "update")
        aCoder.encode(notice, forKey: "notice")
    }
    
    override init() {}
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        detail <- map["one"]
        update <- map["update"]
        notice <- map["notice"]
    }
}
