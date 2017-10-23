//
//  XHMyOrderModel.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/31.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import ObjectMapper

class XHMyOrderModel: Mappable {

    /// id
    var id: String?
    
    /// 标题
    var title: String?
    
    /// 状态
    var status: String?
    
    /// 订单号
    var orderNum: String?
    
    /// 时间
    var time: String?
    
    /// 数量
    var number: String?
    
    /// 图片
    var icon: String?
    
    /// 价格
    var price: String?
    
    /// 循环宝
    var xhb: CGFloat = 0
    
    /// 总计循环宝
    var totalXhb: CGFloat = 0
    
    /// 订单类型
    var orderType: String?
    
    /// 积分兑换
    var gift: String?
    
    /// 是否可以退货 0 -    1 - 商家订单中 可以退货
    var isSalesReturn: String?
    
    /// 属性一
    var property: String?
    
    /// 属性二
    var property2: String?
    
    // ----------------- 收件人信息 ------------------
    /// 收件人
    var addressee: String?
    
    /// 联系电话
    var phoneNum: String?
    
    /// 收货地址
    var address_city: String?
    
    /// 详细收货地址
    var address_detail: String?
    
    /// 买家账号
    var userAccount: String?
    
    /// 买家昵称
    var userName: String?
    
    /// 发货时间
    var sendTime: String?
    
    /// 收货时间
    var getTime: String?
    
    // ------------------ 店铺信息 -------------------------------
    /// 店铺电话
    var shop_phone: String?
    
    /// 店铺名称
    var shop_name: String?
    
    /// 商品总价
    var totalPrice: String?
    // ---------------- 退货信息 --------------
    /// 退货状态 0 - 可以退货 默认   1 - 退货申请中
    var salesReturnStatus: String = "0"
    
    /// 退货原因
    var salesReturn_reason: String?
    
    /// 原因详情
    var salesReturn_ReaDetail: String?
    
    /// 退货申请时间
    var salesReturn_time: String?
    
    init() {}
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        status <- map["zhuangtai"]
        status <- map["fh"]
        orderNum <- map["dingdanhao"]
        time <- map["time"]
        number <- map["shuliang"]
        icon <- map["pic"]
        price <- map["price"]
        xhb <- map["xhd"]
        totalXhb <- map["totalxhb"]
        orderType <- map["lx"]
        gift <- map["jifenduihuan"]
        isSalesReturn <- map["thstat"]
        property <- map["property"]
        property <- map["zdval"]
        property2 <- map["property2"]
        property2 <- map["zdval1"]
        // ---------------------------
        addressee <- map["shoujianren"]
        phoneNum <- map["lianxidianhua"]
        address_city <- map["shouhuodizhi"]
        address_detail <- map["xiangxidizhi"]
        userAccount <- map["buy_tel"]
        userName <- map["nicheng"]
        sendTime <- map["fhtime"]
        getTime <- map["fptime"]
        // -----------------------------
        shop_phone <- map["dmd_tel"]
        shop_name <- map["dmd_name"]
        totalPrice <- map["total"]
        
        // -------------------------------
        salesReturnStatus <- map["thstat"]
        salesReturn_reason <- map["threason"]
        salesReturn_ReaDetail <- map["content"]
        salesReturn_time <- map["th_time"]
    }
}
