//
//  XHWalletModel.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/20.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import ObjectMapper

class XHWalletModel: Mappable {

    /// 符号
    var fuhao: String?
    
    /// 
    var jylx: String?
    
    /// 总计
    var sum: String?
    
    /// 时间
    var time: String?
    
    /// 
    var zffs: String?
    
    init() {}
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        fuhao <- map["fuhao"]
        jylx <- map["jylx"]
        sum <- map["sum"]
        time <- map["time"]
        zffs <- map["zffs"]
    }
}
