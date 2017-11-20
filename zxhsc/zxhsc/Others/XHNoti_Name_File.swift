//
//  XHNoti_Name_File.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/7/13.
//  Copyright © 2017年 zxhsc. All rights reserved.
//
import SSKeychain

let profile_manage_perRowHeight: CGFloat = 78

/// 首页 热卖单品 单个item的高度
let home_hotSell_perRowHeight: CGFloat = (kUIScreenWidth == 320 ? 172 : 250)
/// 商城 热卖商城 单个item的高度
let market_hotsell_perItemHeight: CGFloat = (kUIScreenWidth == 320 ? 172 : 217)
/// 商城 热卖商城 各item之间的间距
let market_hotSell_margin: CGFloat = 13

/// 支付成功通知
let NOTI_PAYMENT_SUCCESS: String = "ZXHSHOP_NOTI_PAYMENT_SUCCESS"
/// 支付失败通知
let NOTI_PAYMENT_FAILURE: String = "ZXHSHOP_NOTI_PAYMENT_FAILURE"
/// 导航栏高度
let nav_height: CGFloat = (KUIScreenHeight == 812 ? 84 : 64)

func judgeIfLogin() -> Bool {
    let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
    let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
    if token == nil || userid == nil {
        let login = XHLoginController()
        let nav = UINavigationController(rootViewController: login)
        UIApplication.shared.keyWindow?.rootViewController?.present(nav, animated: true, completion: nil)
        return false
    }
    return true
}
