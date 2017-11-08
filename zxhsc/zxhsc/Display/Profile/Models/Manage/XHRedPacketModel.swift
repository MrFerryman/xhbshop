//
//  XHRedPacketModel.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/11/6.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import ObjectMapper

class XHRedPacketModel: Mappable {

    /// id
    var id: String?
    
    /// 总金额
    var total_m: String?
    
    /// 剩余金额
    var left_m: String?
    
    /// 剩余个数
    var left_count: String?
    
    /// 时间
    var time: String?
    
    /// 类型 1 - 个人红包 2 - 个人红包
    var type: String?
    
    /// xhb
    var xhb: CGFloat = 0.0
    
    /// 红包领取信息
    var red_draw_info: Array<XHRedPacketInfoModel> = []
    
    init() {}
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["id"]
        total_m <- map["money"]
        left_m <- map["money_yu"]
        left_count <- map["times"]
        time <- map["date"]
        type <- map["type"]
        xhb <- map["xhb"]
        red_draw_info <- map["packe_info"]
    }
}

class XHRedPacketInfoModel: Mappable {
    
    /// info ID
    var info_id: String?
    
    /// 红包ID
    var redP_id: String?
    
    /// 电话
    var phone: String?
    
    /// 金额
    var money: String?
    
    /// 时间
    var time: String?
    
    /// 订单号
    var order_Num: String?
    
    /// 红包 用户ID
    var red_user_id: String?
    
    /// xhb
    var xhb: CGFloat = 0.0
    
    init() {}
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        info_id <- map["id"]
        redP_id <- map["r_id"]
        phone <- map["phone"]
        money <- map["money"]
        time <- map["time"]
        order_Num <- map["dingdanhao"]
        red_user_id <- map["r_hyid"]
        xhb <- map["xhb"]
    }
}
