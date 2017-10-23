 //
//  XHRequest.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/1.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import ObjectMapper
import SSKeychain
 import Alamofire

/// 商家是否开店
var isOpenShop: Bool = false
 /// baseURL
 var XHBaseURL: String {
    return "http://118.190.142.233/app.php?do="
 }

enum XHNetDataType {
    case getShopStatus     // 判断用户是否开店
    // MARK:- 个人中心
    case login                   // 登录
    case acquireVerCode_register    // 注册中 获取验证码
    case register               // 注册
    case register_imageCode // 注册中的图片校验
    case acquireVerCode_forgetPsw // 忘记密码中的重置密码
    case forgetPsw            // 忘记密码
    case helpDetail            // 协议
    case judgeSetedPayPsw // 判断是否设置支付密码
    case setPayPsw            // 设置支付密码
    case get_memberDetail  // 获取用户详细资料
    case modifyUserDetail   // 修改用户信息
//    case uploadPicture       // 上传用户头像
    case getUserEarning     // 获取用户收益信息
    case getUserUnfreezed_XHB // 获取用户解冻循环宝
    case getQRCodeImage   // 获取二维码图片
    case getWalletDetailAll  // 获取钱包明细 - 全部
    case getWithdrawList    // 获取提现明细
    case cycle_all              // 循环宝 全部明细
    case cycle_agent          // 循环宝  代理明细
    case cycle_unfreezed    // 循环宝  解冻明细
    case getWithdraw_Balance // 获取提现余额
    case applyForWithdraw  // 提现申请
    case myContactList       // 我的人脉
    case getMyAdressList    // 获取地址列表
    case setMyAddress       // 添加收货地址
    case setAddress_default // 设置默认收货地址
    case deleteAddress        // 删除地址
    case getMyBankCards    // 获取银行卡
    case getMyCollectionList_goods // 获取商品收藏列表
    case getMyCollectionList_shop   // 获取店铺收藏列表
    case cancelCollection_shop        // 取消店铺收藏
    case cancelCollection_goods      // 取消商品收藏
    case modifyPassword_login        // 修改登录密码
    case modifyPassword_pay          // 修改支付密码
    case forgetPassword_pay           // 忘记支付密码
    case getHelpList                       // 获取帮助中心数据列表
    case getAnnouncementList         // 获取平台公告列表
    case getNewsList                      // 获取新闻动态列表
    case getBankList                       // 获取开户银行列表
    case getBankBranchList             // 获取开户网点列表
    case saveBankData                   // 保存银行卡信息
    case getMyOrderList                 // 我的订单列表
    case cancelMyOrder                 // 取消订单
    case removeMyOrder                // 删除订单
    case getMyOrderDetail              // 获取订单详情
    case getMyOrder_offlineOrdersList // 获取我的订单 线下消费列表
    case applyForSalesReturn          // 退货申请
    case checkLogisticsDetail          // 查看物流详情
    case confirmGotSales               // 确认收货
    case getMyValuationList          // 获取我的评价列表
    case commitMyValuation         // 提交我的评价
    
    // MARK:- 商盟
    case getFriendClassesList          // 获取商盟 分类列表
    case getRecommandShopList      // 获取推荐商铺列表
    case getShopDetail                   // 获取店铺详情
    case getShopDetail_goodsList     // 获取店铺详情中的商品列表
    case getSearchShopList             // 获取店铺搜索列表数据
    case addShopCollection             // 添加店铺收藏
    case getGoodsDetail                 // 获取商品详情
    case getGoods_commentList    // 获取商品详情中的评论列表
    case checkGoodsStock              // 检查商品库存 >>>> 重新获取商品属性
    case getIntegral_goodsDetail      // 获取积分兑换商品详情
    case addProductCollection         // 添加商品收藏
    case addToShoppingCart           // 添加至购物车
    case getShoppingCartList          // 获取购物车列表
    case modifyShoppingCart          // 修改购物车商品
    case getDefaultAddresseeInfo    // 获取默认收货人信息
    case getEffectiveBanlance         // 获取可用余额
    case getPaymentStyleList          // 获取支付方式
    case commitOrder_common     // 提交订单 ---- 普通订单
    case commitOrder_integral       // 提交订单 ---- 积分订单
    case payment_getOrderDetail       // 订单付款中 查看订单详情
    case payment_getMyQRCoderImg  // 订单付款 获取二维码图片
    case testPaydayLimitMoney           // 测试当日限额
    case payment_banlance                // 余额支付
    case getUserCurrentIntegral       // 获取用户当前可用积分
    case postPayment_integral         // 积分支付
    
    
    // MARK:- 类目
    case getClassifyList                         // 获取类目列表
    case getRecommend_banner             // 获取推荐专区 头部banner
    case getRecommend_recommendData // 获取推荐专区 推荐数据
    case getRecommend_hotClass           // 获取推荐专区  热门分类
    case getSpecialFavData                    // 获取特惠专区
    case getClassifyChildData                 // 获取类目子类数据
    case getSessionData                        // 获取专场数据
    case search_goods                          // 搜索商品
    
    /// MARK:- 首页
    case getCirculation           // 获取循环指数
    case getHomeNotice         // 获取首页通知
    case getHomeRecommend_goodsList // 获取精品推荐商品列表
    case getHomeRecommend_bannersList // 获取推荐部分 banner列表
    case getHomeRecommend_banner_goods_list // 获取首页推荐部分 banner商品部分
    case getHomeUserPlatformList  // 获取首页用户角色数据
    case getScaleRankList     // 获取指数排行数组
    case getIntegralShopList    // 请求积分商城数据
    case getHomePlaneData    // 获取首页飞机报喜数据
    case getTabbarIconList      // 获取tabbar图标列表
    
    // MARK:- 店铺
    case openAmbassador  // 开通循环大使
    case getMyShop          // 获取我的店铺信息
    case getMyShopOrderList  // 获取商家订单
    case myShopOrder_Cancel // 商家订单 取消订单
    case myShopOrder_detail   // 商家订单 查看详情
    case payment_getCustomerNickname // 获取消费者昵称
    case shop_payment_commitOrder      // 商家付款  提交订单
    case getMyShop_setting_data           // 请求店铺设置信息
    case getShop_classList                    // 获取店铺分类列表
    case openShopSettingInfo                // 开通店铺设置信息
    case saveShopSettingInfo                 // 保存店铺设置信息
    case getShopCustomerOrdersList      // 获取商铺用户订单列表
    case getShopCustomerOrdersDetail   // 获取商铺订单详情
    case myShop_postGoods_confirmReturnSales // 商家 发货或确认退货
    case innerCustomOrder                      // 店内消费生成订单
    case getShop_offlineOrdersList          // 获取店铺 线下消费订单列表
    
    // MARK:- 发现
    case getLottoryList            // 获取抽奖列表
    case getIntegralGoodsList   // 获取积分商品列表
    case getLottoryRegular       // 获取抽奖规则
    case getMyWinningMsg       // 获取我的中奖信息
    case getWinningList            // 获取所有中奖纪录
}

/// 图片baseURL
let XHImageBaseURL = "http://118.190.142.233/"  + "Public/upload/"
let XHPlaceholdImage = "loding_icon"
let XHPlaceholdImage_LONG = "loadingIMG"

class XHRequest {
    static let shareInstance = XHRequest()
    private init() { }
    
    /// baseURL
    fileprivate var xhbaseURL: String {
        return XHBaseURL
    }
}

extension XHRequest {
    // MARK: - 网络数据请求接口
    func requestNetData (dataType: XHNetDataType, parameters: [String: String]? = nil, failure:@escaping (ErrorType) -> Void, success:@escaping (Any) -> Void) -> XHCancelRequest? {
        switch dataType {
        case .getShopStatus:               // 判断用户是否开店
            return judgeShopStatus(failure: failure, success: success)
            // MARK:- 个人中心
        case .login:                             // 登录
            return loginAccount(parameters: parameters, failure: failure, success: success)
        case .acquireVerCode_register:   // 注册 获取验证码
            return getVerificationCode(parameters: parameters, failure: failure, success: success)
        case .register_imageCode:      // 注册中的图片校验
            return register_imageCode(parameters: parameters, failure: failure, success: success)
        case .register:                          // 注册
            return register(parameters: parameters, failure: failure, success: success)
        case .forgetPsw:                       // 忘记密码
            return forgetPsw(parameters: parameters, failure: failure, success: success)
        case .acquireVerCode_forgetPsw: // 忘记密码 中的 获取验证码
            return forgetPsw_getVerificationCode(parameters: parameters, failure: failure, success: success)
        case .judgeSetedPayPsw:            // 判断是否设置过支付密码
            return judgeIfSettedPayPsw(parameters: parameters, failure: failure, success: success)
        case .setPayPsw:                       // 设置支付密码
            return settingPayPsw(parameters: parameters, failure: failure, success: success)
        case .get_memberDetail:             // 获取用户详细资料
            return getPersonalSomething(failure: failure, success: success)
        case .modifyUserDetail:               // 修改用户信息
            return modifyUserDetail(parameters: parameters, failure: failure, success: success)
        case .helpDetail:                         // 帮助详情
            return helpHTML(parameters: parameters, failure: failure, success: success)
//        case .uploadPicture:                    // 上传头像
//            return uploadHeaderIameg(parameters: parameters, failure: failure, success: success)
        case .getUserEarning:                 // 获取用户收益
            return getUserEarning(failure: failure, success: success)
        case .getUserUnfreezed_XHB:       // 获取用户解冻循环宝
            return getUserUnfreezed_XHB(failure: failure, success: success)
        case .getQRCodeImage:               // 获取二维码图片
            return getQrcodeImage(failure: failure, success: success)
        case .getWalletDetailAll:               // 获取钱包明细
            return getWalletDetailList(failure: failure, success: success)
        case .getWithdrawList:                 // 获取提现明细
            return getWithdrawList(failure: failure, success: success)
        case .cycle_all:                           // 获取循环宝 全部明细
            return getCycleAllList(failure: failure, success: success)
        case .cycle_agent:                      // 获取循环宝  代理明细
            return getCycleAgentList(failure: failure, success: success)
        case .cycle_unfreezed:                // 获取循环宝  解冻明细
            return getCycleUnfreezedList(failure: failure, success: success)
        case .getWithdraw_Balance:         // 获取提现余额
            return getWithdraw_Balance(failure: failure, success: success)
        case .applyForWithdraw:              // 提现申请
            return applyForWithdraw(parameters: parameters, failure: failure, success: success)
        case .myContactList:                   // 我的人脉
            return getMyContactList(failure: failure, success: success)
        case .getMyAdressList:                // 获取地址列表
            return getMyAddressList(failure: failure, success: success)
        case .setMyAddress:                    // 添加/修改收货地址
            return modifyMyAddress(parameters: parameters, failure: failure, success: success)
        case .setAddress_default:             // 设置默认收货地址
            return setDefaulMyAddress(parameters: parameters, failure: failure, success: success)
        case .deleteAddress:                    // 删除订单
            return deleteMyAddress(parameters: parameters, failure: failure, success: success)
        case .getMyBankCards:                // 获取银行卡信息
            return getMyBankCardList(failure: failure, success: success)
        case .getMyCollectionList_goods:    // 获取商品收藏列表
            return getMyCollection_goods_List(failure: failure, success: success)
        case .getMyCollectionList_shop:      // 获取店铺收藏列表
            return getMyCollection_shop_List(failure: failure, success: success)
        case .cancelCollection_shop:          // 取消店铺收藏
            return cancelCollection_shop(parameters: parameters, failure: failure, success: success)
        case .cancelCollection_goods:        // 取消商品收藏
            return cancelCollection_goods(parameters: parameters, failure: failure, success: success)
        case .modifyPassword_login:          // 修改登录密码
            return modifyLoginPassword(parameters: parameters, failure: failure, success: success)
        case .modifyPassword_pay:            // 修改支付密码
            return modifyPayPassword(parameters: parameters, failure: failure, success: success)
        case .forgetPassword_pay:             // 忘记支付密码
            return forgetPayPassword(parameters: parameters, failure: failure, success: success)
        case .getHelpList:                // 帮助中心列表获取
            return getHelpCenterList(failure: failure, success: success)
        case .getAnnouncementList:  // 获取平台公告列表
            return getAnnouncementList(failure: failure, success: success)
        case .getNewsList:               // 获取新闻动态列表
            return getNewsList(failure: failure, success: success)
        case .getBankList:               // 获取开户银行列表
            return getBankList(parameters: parameters, failure: failure, success: success)
        case .getBankBranchList:      // 获取银行分支机构列表
            return getBankBranchList(parameters: parameters, failure: failure, success: success)
        case .saveBankData:            // 保存银行卡信息
            return saveBankData(parameters: parameters, failure: failure, success: success)
        case .getMyOrderList:          // 获取我的订单列表
            return getMyOrdersList(parameters: parameters, failure: failure, success: success)
        case .cancelMyOrder:          // 取消订单
            return cancelMyOrder(parameters: parameters, failure: failure, success: success)
        case .removeMyOrder:         // 删除订单
            return removeMyOrder(parameters: parameters, failure: failure, success: success)
        case .getMyOrderDetail:       // 获取订单详情
            return getMyOrderDetail(parameters: parameters, failure: failure, success: success)
        case .getMyOrder_offlineOrdersList: // 获取个人中心 线下消费订单列表
            return getMyOrder_offlineOrdersList(parameters: parameters, failure: failure, success: success)
        case .applyForSalesReturn:   // 退货申请
            return applyForSalesReturn(parameters: parameters, failure: failure, success: success)
        case .checkLogisticsDetail:   // 查看物流详情
            return checkLogisticsDetail(parameters: parameters, failure: failure, success: success)
        case .confirmGotSales:        // 确认收货
            return confirmGotSales(parameters: parameters, failure: failure, success: success)
        case .getMyValuationList:   // 获取我的评价列表
            return getMyValuationList(parameters: parameters, failure: failure, success: success)
        case .commitMyValuation:  // 提交我的评价
            return commitMyValuation(parameters: parameters, failure: failure, success: success)
        case .postPayment_integral:  // 积分支付
            return postPayment_integral(parameters: parameters, failure: failure, success: success)
            
            
            // MARK:- 商盟
        case .getFriendClassesList:    // 获取商盟 分类列表
            return getFriendClassifyList(failure: failure, success: success)
        case .getRecommandShopList: // 获取推荐商铺列表
            return getRecommendShopsList(parameters: parameters, failure: failure, success: success)
        case .getShopDetail:              // 获取店铺详情
            return getShopDetail(parameters: parameters, failure: failure, success: success)
        case .getShopDetail_goodsList: // 获取店铺详情 中的 商品列表
            return getShopDetail_goodsList(parameters: parameters, failure: failure, success: success)
        case .getSearchShopList:        // 获取搜索店铺列表数据
            return getSearchShopList(parameters: parameters, failure: failure, success: success)
        case .addShopCollection:         // 添加店铺收藏
            return addShopCollection(parameters: parameters, failure: failure, success: success)
        case .getGoodsDetail:             // 获取商品详情
            return getGoodsDetail(parameters: parameters, failure: failure, success: success)
        case .getGoods_commentList:  // 获取商品详情中的评论列表
            return getGoods_commentList(parameters: parameters, failure: failure, success: success)
        case .checkGoodsStock:          // 检查商品库存
            return checkGoodsStock(parameters: parameters, failure: failure, success: success)
        case .getIntegral_goodsDetail: // 获取积分兑换商品详情
            return getIntegral_GoodsDetail(parameters: parameters, failure: failure, success: success)
        case .addProductCollection:    // 添加商品收藏
            return addProductCollection_goodsDetail(parameters: parameters, failure: failure, success: success)
        case .addToShoppingCart:       // 添加到购物车
            return addGoodsToShoppingCart(parameters: parameters, failure: failure, success: success)
        case .getShoppingCartList:       // 获取购物车列表
            return getShoppingCartList(failure: failure, success: success)
        case .modifyShoppingCart:       // 修改购物车商品
            return modifyShoppingCartGoods(parameters: parameters, failure: failure, success: success)
        case .getDefaultAddresseeInfo: // 获取默认收货人信息
            return getDefaultAddresseeInfo(failure: failure, success: success)
        case .getEffectiveBanlance:      // 获取可用余额
            return getEffectiveBanlance(failure: failure, success: success)
        case .getPaymentStyleList:        // 获取支付方式列表
            return getPaymentList(failure: failure, success: success)
        case .commitOrder_common:     // 提交普通订单
            return commitOrder_common(parameters: parameters, failure: failure, success: success)
        case .commitOrder_integral:      // 提交积分订单
            return commitOrder_integral(parameters: parameters, failure: failure, success: success)
        case .payment_getOrderDetail:      // 付款界面 查看订单详情
            return getPayment_orderDetail(parameters: parameters, failure: failure, success: success)
        case .payment_getMyQRCoderImg: // 付款 获取二维码支付
            return getQRCoderPaymentImage(parameters: parameters, failure: failure, success: success)
        case .testPaydayLimitMoney:         // 测试当日限额
            return testPeydayLimitMoney(parameters: parameters, failure: failure, success: success)
        case .payment_banlance:             // 余额支付
            return payment_banlance(parameters: parameters, failure: failure, success: success)
        case .getUserCurrentIntegral:     // 获取当前用户可用积分
            return getUserCurrentIntegral(failure: failure, success: success)
            
            // MARK:- ❤️类目
        case .getClassifyList:  // 获取类目列表
            return getClassifyList(failure: failure, success: success)
        case .getRecommend_banner: // 获取推荐专区 头部banner
            return getClassify_recommend_banner(failure: failure, success: success)
        case .getRecommend_recommendData: // 获取推荐专区  推荐数据
            return getClassify_recommend_recommend(failure: failure, success: success)
        case .getRecommend_hotClass: // 获取推荐专区 热门分类
            return getClassify_recommend_hotClassify(failure: failure, success: success)
        case .getSpecialFavData:          // 获取特惠专区数据
            return getClassify_SpecialZoneData(parameters: parameters, failure: failure, success: success)
        case .getClassifyChildData:       // 获取类目子类数据
            return getClassify_childClassesData(parameters: parameters, failure: failure, success: success)
        case .getSessionData:              // 获取专场数据
            return getSessionData(parameters: parameters, failure: failure, success: success)
        case .search_goods:    // 搜索商品
            return getSearchGoodsList(parameters: parameters, failure: failure, success: success)
            
            // MARK:- 首⃣页⃣数⃣据⃣
        case .getCirculation:     // 获取循环指数
            return getCirculation(failure: failure, success: success)
        case .getHomeNotice:   // 获取首页通知
            return getHomeNotice(failure: failure, success: success)
        case .getHomeRecommend_goodsList: // 获取精品推荐列表
            return getHomeRecommendGoodsList(failure: failure, success: success)
        case .getHomeRecommend_bannersList: // 获取推荐部分 bennner
            return getHomeRecommend_bannersList(failure: failure, success: success)
        case .getHomeRecommend_banner_goods_list: // 获取推荐部分 banner商品
            return getHomeRecommend_banners_GoodsList(failure: failure, success: success)
        case .getHomeUserPlatformList: // 获取首页用户角色数据
            return getHomeUserPlatformList(failure: failure, success: success)
        case .getScaleRankList:  // 获取指数排行数组
            return getScaleRankList(failure: failure, success: success)
        case .getIntegralShopList: // 请求积分商城数据
            return getIntegralShopList(parameters: parameters, failure: failure, success: success)
        case .getHomePlaneData:  // 获取首页飞机报喜数据
            return getHomePlaneData(failure: failure, success: success)
            
            
        // MARK:- 店铺
        case .openAmbassador: // 开通店铺
            return openAmbassador(failure: failure, success: success)
        case .getMyShop:         // 获取我的店铺信息
            return getMyShopInfo(failure: failure, success: success)
        case .getMyShopOrderList: // 获取商家订单列表
            return getMyShopOrdersList(parameters: parameters, failure: failure, success: success)
        case .myShopOrder_Cancel: // 商家订单 取消订单
            return cancelMyShopOrder(parameters: parameters, failure: failure, success: success)
        case .myShopOrder_detail:   // 商家订单 订单订单详情
            return getMyShopOrder_detail(parameters: parameters, failure: failure, success: success)
        case .payment_getCustomerNickname: // 获取消费者昵称
            return getCustomerNickname(parameters: parameters, failure: failure, success: success)
        case .shop_payment_commitOrder:      // 商家付款 提交订单
            return shop_payment_commitOrder(parameters: parameters, failure: failure, success: success)
        case .getMyShop_setting_data:           // 请求店铺设置信息
            return getMyShop_setting_info(failure: failure, success: success)
        case .getShop_classList:                    // 获取店铺类别列表
            return getMyShop_setting_classList(failure: failure, success: success)
        case .openShopSettingInfo:                // 开通店铺设置信息
            return openShopSettingInfo(parameters: parameters, failure: failure, success: success)
        case .saveShopSettingInfo:                // 保存店铺设置信息
            return saveShopSettingInfo(parameters: parameters, failure: failure, success: success)
        case .getShopCustomerOrdersList:     // 获取商铺用户订单列表
            return getShopCustomerOrdersList(parameters: parameters, failure: failure, success: success)
        case .getShopCustomerOrdersDetail:  // 获取商铺用户订单详情
            return getShopCustomer_Ordersdetail(parameters: parameters, failure: failure, success: success)
        case .myShop_postGoods_confirmReturnSales: // 商家 发货 / 确认退货
            return myShop_postGoods_confirmReturnSales(parameters: parameters, failure: failure, success: success)
        case .innerCustomOrder:                     // 店内消费生成订单
            return innerCustomOrder(parameters: parameters, failure: failure, success: success)
        case .getShop_offlineOrdersList:          // 获取店铺 线下消费订单列表
            return getShop_offlineOrdersList(parameters: parameters, failure: failure, success: success)
        case .getTabbarIconList:                      // 获取tabbar图标
            return getTabbarIconList(failure: failure, success: success)
            
            // MARK:- 发现
        case .getLottoryList: // 获取抽奖列表
            return getLottoryList(failure: failure, success: success)
        case .getIntegralGoodsList: // 获取积分商品列表
            return getIntegralGoodsList(failure: failure, success: success)
        case .getLottoryRegular:     // 获取抽奖规则
            return getLottoryRegular(failure: failure, success: success)
        case .getMyWinningMsg:     // 获取我的中奖信息
            return getMyWinningMessage(parameters: parameters, failure: failure, success: success)
        case .getWinningList:          // 获取所有的中奖纪录
            return getWinningMessageList(parameters: parameters, failure: failure, success: success)
        }
    }
}

extension XHRequest {
    
    // MARK:- 判断用户是否开店
    fileprivate func judgeShopStatus(failure:@escaping (ErrorType) -> Void, success:@escaping (Any) -> Void) -> XHCancelRequest? {
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        var paramDict = ["userid": userid ?? "", "userkey": token ?? ""]
        
        let url = xhbaseURL + "get_merchants_status" + "&c=" + "Dmd"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version = (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            
            if let text = (response as! [String: Any])["text"],  let user = Mapper<XHShopDetailModel>().map(JSONObject: text) {
                success(user)
            }else {
                success((response as! [String: Any])["text"]!)
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }

    // MARK:- 登录接口
    fileprivate func loginAccount(parameters: [String: String]?, failure:@escaping (ErrorType) -> Void, success:@escaping (Any) -> Void) -> XHCancelRequest? {
        
//        let url = xhbaseURL + "login_new"
        let url = xhbaseURL + "login" + "&c=" + "Login"
        
        guard let phone = parameters?["user"], let psw = parameters?["pwd"] else {
            failure(ErrorType.networkError)
            return nil
        }
        
        let psw1 = XHNetworkTools.instance.md5String(str: psw)
        let newPsw = XHNetworkTools.instance.md5String(str: psw1)
        
        var paramDict = ["user" : phone, "pwd": newPsw]
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version = (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: parameters, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["text"],  let user = Mapper<XHUserModel>().map(JSONObject: text) {
                user.loginStatus = .success
                success(user)
                NSKeyedArchiver.archiveRootObject(user, toFile: userAccountPath)
            }else {
                success((response as! [String: Any])["text"]!)
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }
    
    // MARK:- 注册界面 获取验证码接口
    fileprivate func getVerificationCode(parameters: [String: String]?, failure:@escaping (ErrorType) -> Void, success:@escaping (String) -> Void) -> XHCancelRequest? {
        
        guard var paramDict = parameters else {
            failure(ErrorType.networkError)
            return nil
        }
        
        let url = xhbaseURL + "get_codes_new" + "&c=" + "Login"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version = (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["status"] {
                if (text as! NSNumber) == 1 {
                    success("验证码发送成功,请注意查收短信")
                }else {
                    success((response as! [String: Any])["text"] as! String)
                }
            }else {
                success("未知错误~")
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }
    
    // MARK:- 注册界面 校验图片验证码接口
    fileprivate func register_imageCode(parameters: [String: String]?, failure:@escaping (ErrorType) -> Void, success:@escaping (String) -> Void) -> XHCancelRequest? {
        
        guard var paramDict = parameters else {
            failure(ErrorType.networkError)
            return nil
        }
        
        let url = xhbaseURL + "check_code" + "&c=" + "Login"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version = (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["status"] {
                if (text as! NSNumber) == 1 {
                    success(String(describing: ((response as! [String: Any])["text"])!))
                }else {
                    success((response as! [String: Any])["text"] as! String)
                }
            }else {
                success("\((response as! [String: Any])["text"])")
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }
    
    // MARK:- 注册接口
    fileprivate func register(parameters: [String: String]?, failure:@escaping (ErrorType) -> Void, success:@escaping (String) -> Void) -> XHCancelRequest? {
        
        guard var paramDict = parameters else {
            failure(ErrorType.networkError)
            return nil
        }
        
        let url = xhbaseURL + "register" + "&c=" + "Login"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version =  (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let headers: HTTPHeaders = [
            "Authorization": "Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==",
            "Accept": "application/json"
        ]
        let manager = XHNetworkTools.instance.requestPOSTURL(url, headers: headers, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["text"] {
                success(text as! String)
            }else {
                success("未知错误~")
            }
        }
//        requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
//            failure(errorType)
//        }) { (response) in
//            if let text = (response as! [String: Any])["text"] {
//                success(text as! String)
//            }else {
//                success("未知错误~")
//            }
//        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }
    
    // MARK:- 忘记密码
    fileprivate func forgetPsw(parameters: [String: String]?, failure:@escaping (ErrorType) -> Void, success:@escaping (String) -> Void) -> XHCancelRequest? {
        
        guard var paramDict = parameters else {
            failure(ErrorType.networkError)
            return nil
        }
        
        let url = xhbaseURL +  "forget_loginpwd" + "&c=" + "Login"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version =  (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["text"] {
                success(text as! String)
            }else {
                success("未知错误~")
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }
    
    // MARK:- 忘记密码 获取验证号码
    fileprivate func forgetPsw_getVerificationCode(parameters: [String: String]?, failure:@escaping (ErrorType) -> Void, success:@escaping (String) -> Void) -> XHCancelRequest? {
        guard var paramDict = parameters else {
            failure(ErrorType.networkError)
            return nil
        }
        
        let url = xhbaseURL + "get_codes1" + "&c=" + "Login"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version =  (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["text"] {
                success(text as! String)
            }else {
                success("未知错误~")
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }
    
    // MARK:- 判断是否设置过支付密码
    fileprivate func judgeIfSettedPayPsw(parameters: [String: String]?, failure:@escaping (ErrorType) -> Void, success:@escaping (String) -> Void) -> XHCancelRequest? {
        
        guard var paramDict = parameters else {
            failure(ErrorType.networkError)
            return nil
        }
        
        let url = xhbaseURL + "get_zhifu_stat" + "&c=" + "Myinfo"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version =  (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["text"] {
                success("\(text)")
            }else {
                success("0")
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }
    
    // MARK:- 设置支付密码
    fileprivate func settingPayPsw(parameters: [String: String]?, failure:@escaping (ErrorType) -> Void, success:@escaping (String) -> Void) -> XHCancelRequest? {
        
        guard let payPsw = parameters?["zhifupass"] else {
            failure(ErrorType.networkError)
            return nil
        }
        
        let url = xhbaseURL + "zhifupass" + "&c=" + "Myinfo"
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        var paramDict = ["zhifupass": payPsw, "userid": userid ?? "", "userkey": token ?? ""]
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version =  (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["text"] {
                success(text as! String)
            }else {
                success("设置失败...")
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }
    
    // MARK:- 获取 个人资料
    fileprivate func getPersonalSomething(failure:@escaping (ErrorType) -> Void, success:@escaping (Any) -> Void) -> XHCancelRequest? {
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        var paramDict = ["userid": userid ?? "", "userkey": token ?? ""]
        
        let url = xhbaseURL + "member_detail" + "&c=" + "Myinfo"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version =  (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            
            if let text = (response as! [String: Any])["text"],  let user = Mapper<XHMemberDetailModel>().map(JSONObject: text) {
                success(user)
            }else {
                success((response as! [String: Any])["text"]!)
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }
    
    // MARK:- 修改用户信息
    fileprivate func modifyUserDetail(parameters: [String: String]?, failure:@escaping (ErrorType) -> Void, success:@escaping (String) -> Void) -> XHCancelRequest?  {
        guard var paramDict = parameters else {
            failure(ErrorType.networkError)
            return nil
        }
        
        let url = xhbaseURL + "member_modify" + "&c=" + "Myinfo"
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        paramDict["userid"] = userid
        paramDict["userkey"] = token
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version =  (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["text"] {
                success(text as! String)
            }else {
                success("设置失败...")
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }
    
    // MARK:- 获取用户收益 getUserUnfreezed_XHB
    fileprivate func getUserEarning(failure:@escaping (ErrorType) -> Void, success:@escaping (Any) -> Void) -> XHCancelRequest? {
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        var paramDict = ["userid": userid ?? "", "userkey": token ?? ""]
        
//        let url = xhbaseURL + "&c=" + "Myinfo"  "get_user_money"
        let url =  xhbaseURL + "get_user_money&c=Myinfo"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version =  (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["text"],  let user = Mapper<XHUserEarningModel>().map(JSONObject: text) {
                success(user)
                NSKeyedArchiver.archiveRootObject(user, toFile: userEarningPath)
            }else {
                success((response as! [String: Any])["text"]!)
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }
    
    // MARK:- 获取用户解冻循环宝
    fileprivate func getUserUnfreezed_XHB(failure:@escaping (ErrorType) -> Void, success:@escaping (Any) -> Void) -> XHCancelRequest? {
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        var paramDict = ["userid": userid ?? "", "userkey": token ?? ""]
        
        let url = xhbaseURL + "xhbrelease" + "&c=" + "Xhbdetail"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version =  (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["text"],  let user = Mapper<XHXHB_UnfreezedModel>().map(JSONObject: text) {
                success(user)
                NSKeyedArchiver.archiveRootObject(user, toFile: unfreezedXHBPath)
            }else {
                success((response as! [String: Any])["text"]!)
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }
    
    // MARK:- 获取二维码图片
    fileprivate func getQrcodeImage(failure:@escaping (ErrorType) -> Void, success:@escaping (Any) -> Void) -> XHCancelRequest? {
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        var paramDict = ["userid": userid ?? "", "userkey": token ?? ""]
        
        let url = xhbaseURL +  "get_share_ewm" + "&c=" + "Myinfo"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version =  (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            success((response as! [String: Any])["text"]!)
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }
    
    // MARK:- 获取帮助HTML
    fileprivate func helpHTML(parameters: [String: String]?, failure:@escaping (ErrorType) -> Void, success:@escaping (Any) -> Void) -> XHCancelRequest? {
        
        guard var paramDict = parameters else {
            failure(ErrorType.networkError)
            return nil
        }
        
        let url = xhbaseURL +  "get_help_detail" + "&c=" + "Balance"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version =  (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            
            if let text = (response as! [String: Any])["text"] , let htmlModel = Mapper<XHHTMLModel>().map(JSONObject: text) {
                success(htmlModel)
            }else {
                success((response as! [String: Any])["text"]!)
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }
    
    // MARK:- 获取钱包明细
    fileprivate func getWalletDetailList(failure:@escaping (ErrorType) -> Void, success:@escaping ([XHWalletModel]) -> Void) -> XHCancelRequest? {
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        var paramDict = ["userid": userid ?? "", "userkey": token ?? ""]
        
        let url = xhbaseURL +  "get_wallet_list" + "&c=" + "Wallet"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version =  (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["text"], let modelArr = Mapper<XHWalletModel>().mapArray(JSONObject: text)  {
                success(modelArr)
            }else {
                let modelArr = Array<XHWalletModel>()
                success(modelArr)
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }
    
    // MARK:- 获取提现明细
    fileprivate func getWithdrawList(failure:@escaping (ErrorType) -> Void, success:@escaping ([XHWithdrawModel]) -> Void) -> XHCancelRequest? {
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        var paramDict = ["userid": userid ?? "", "userkey": token ?? ""]
        
        let url = xhbaseURL +  "get_withdraw_list" + "&c=" + "Myinfo"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version =  (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["text"], let modelArr = Mapper<XHWithdrawModel>().mapArray(JSONObject: text)  {
                success(modelArr)
            }else {
                let modelArr = Array<XHWithdrawModel>()
                success(modelArr)
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }
    
    // MARK:- 获取循环宝   -   全部明细
    fileprivate func getCycleAllList(failure:@escaping (ErrorType) -> Void, success:@escaping ([XHCycleModel]) -> Void) -> XHCancelRequest? {
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        var paramDict = ["userid": userid ?? "", "userkey": token ?? ""]
        
        let url = xhbaseURL +  "get_xhb_list" + "&c=" + "Xhbdetail"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version =  (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["text"], let modelArr = Mapper<XHCycleModel>().mapArray(JSONObject: text)  {
                success(modelArr)
            }else {
                let modelArr = Array<XHCycleModel>()
                success(modelArr)
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }
    
    // MARK:- 获取循环宝   -    代理明细  getCycleUnfreezedList
    fileprivate func getCycleAgentList(failure:@escaping (ErrorType) -> Void, success:@escaping ([XHCycleModel]) -> Void) -> XHCancelRequest? {
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        var paramDict = ["userid": userid ?? "", "userkey": token ?? ""]
        
        let url = xhbaseURL + "get_agent_xhb_list" + "&c=" + "Xhbdetail"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version =  (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["text"], let modelArr = Mapper<XHCycleModel>().mapArray(JSONObject: text)  {
                success(modelArr)
            }else {
                let modelArr = Array<XHCycleModel>()
                success(modelArr)
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }
    
    // MARK:- 获取循环宝   -    代理明细
    fileprivate func getCycleUnfreezedList(failure:@escaping (ErrorType) -> Void, success:@escaping (Any) -> Void) -> XHCancelRequest? {
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        var paramDict = ["userid": userid ?? "", "userkey": token ?? ""]
        
        let url = xhbaseURL + "xhbrelease_list" + "&c=" + "Xhbdetail"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version =  (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["text"], let modelArr = Mapper<XHUnfreezedDetailModel>().mapArray(JSONObject: text)  {
                success(modelArr)
            }else {
                let modelArr = Array<XHUnfreezedDetailModel>()
                success(modelArr)
            }
        }
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }
    
    // MARK:- 获取提现余额
    fileprivate func getWithdraw_Balance(failure:@escaping (ErrorType) -> Void, success:@escaping (String) -> Void) -> XHCancelRequest? {
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        var paramDict = ["userid": userid ?? "", "userkey": token ?? ""]
        
        let url = xhbaseURL + "get_balance_1" + "&c=" + "Balance"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version =  (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            let balanceStr = ((response as! [String: Any])["text"] as! Array<Any>)[1]
            success("\(balanceStr)")
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }

    // MARK:- 提现申请
    fileprivate func applyForWithdraw(parameters: [String: String]?, failure:@escaping (ErrorType) -> Void, success:@escaping (Any) -> Void) -> XHCancelRequest? {
        guard var paramDict = parameters else {
            failure(ErrorType.networkError)
            return nil
        }
        
        let url = xhbaseURL + "withdraw_append" + "&c=" + "Balance"
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        paramDict["userid"] = userid
        paramDict["userkey"] = token
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version =  (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["text"] {
                success(text as! String)
            }else {
                success("操作有误，请重新操作...")
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }
    
    // MARK:- 获取我的人脉
    fileprivate func getMyContactList(failure:@escaping (ErrorType) -> Void, success:@escaping ([XHMyContactsModel]) -> Void) -> XHCancelRequest? {
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        var paramDict = ["userid": userid ?? "", "userkey": token ?? ""]
        
        let url = xhbaseURL + "get_circle_list" + "&c=" + "Contacts"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version =  (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            
            if let text = (response as! [String: Any])["text"], let firstList = (text as? Array<Any>)?[0], let modelArr = Mapper<XHMyContactsModel>().mapArray(JSONObject: firstList)  {
                success(modelArr)
            }else {
                let modelArr = Array<XHMyContactsModel>()
                success(modelArr)
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }

    // MARK:- 获取地址列表
    fileprivate func getMyAddressList(failure:@escaping (ErrorType) -> Void, success:@escaping ([XHMyAdressModel]) -> Void) -> XHCancelRequest? {
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        var paramDict = ["userid": userid ?? "", "userkey": token ?? ""]
        
        let url = xhbaseURL +  "get_address_list" + "&c=" + "Address"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version =  (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["text"], let modelArr = Mapper<XHMyAdressModel>().mapArray(JSONObject: text)  {
                success(modelArr)
            }else {
                let modelArr = Array<XHMyAdressModel>()
                success(modelArr)
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }

    // MARK:- 添加/修改 收货地址
    fileprivate func modifyMyAddress(parameters: [String: String]?, failure:@escaping (ErrorType) -> Void, success:@escaping (Any) -> Void) -> XHCancelRequest? {
        guard var paramDict = parameters else {
            failure(ErrorType.networkError)
            return nil
        }
        
        let url = xhbaseURL + "address_modify" + "&c=" + "Address" 
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        paramDict["userid"] = userid
        paramDict["userkey"] = token
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version =  (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            
            if let text = (response as! [String: Any])["text"] {
                success(text as! String)
            }else {
                success("操作有误，请重新操作...")
            }
        }
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }
    
    // MARK:- 设置默认收货地址
    fileprivate func setDefaulMyAddress(parameters: [String: String]?, failure:@escaping (ErrorType) -> Void, success:@escaping (Any) -> Void) -> XHCancelRequest? {
        guard var paramDict = parameters else {
            failure(ErrorType.networkError)
            return nil
        }
        
        let url = xhbaseURL + "moren_modify" + "&c=" + "Address"
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        paramDict["userid"] = userid
        paramDict["userkey"] = token
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version =  (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["text"] {
                success(text as! String)
            }else {
                success("操作有误，请重新操作...")
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }
    
    // MARK:- 删除地址
    fileprivate func deleteMyAddress(parameters: [String: String]?, failure:@escaping (ErrorType) -> Void, success:@escaping (Any) -> Void) -> XHCancelRequest? {
        guard var paramDict = parameters else {
            failure(ErrorType.networkError)
            return nil
        }
        
        let url = xhbaseURL + "address_del" + "&c=" + "Address"
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        paramDict["userid"] = userid
        paramDict["userkey"] = token
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version =  (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["text"] {
                success(text as! String)
            }else {
                success("操作有误，请重新操作...")
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }

    // MARK:- 获取银行卡信息
    fileprivate func getMyBankCardList(failure:@escaping (ErrorType) -> Void, success:@escaping (Any) -> Void) -> XHCancelRequest? {
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        var paramDict = ["userid": userid ?? "", "userkey": token ?? ""]
        
        let url = xhbaseURL + "my_bank_detail" + "&c=" + "Authen"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version =  (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["text"], let bank =  (text as? Array<Any>)?[0], let model = Mapper<XHMyBankModel>().map(JSONObject: bank)  {
                if let bankDetail = (text as? Array<Any>)?[1], let detailModel = Mapper<XHBankDetailModel>().map(JSONObject: bankDetail) {
                    model.bankDetal = detailModel
                    success(model)
                }
            }else {
                success("未设置银行卡")
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }

    // MARK:- 获取城市列表
    fileprivate func getMyCityList(failure:@escaping (ErrorType) -> Void, success:@escaping ([XHMyAdressModel]) -> Void) -> XHCancelRequest? {
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        var paramDict = ["userid": userid ?? "", "userkey": token ?? ""]
        
        let url = xhbaseURL + "get_bank_city" + "&c=" + "Authen"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version =  (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            
            if let text = (response as! [String: Any])["text"], let modelArr = Mapper<XHMyAdressModel>().mapArray(JSONObject: text)  {
                success(modelArr)
            }else {
                let modelArr = Array<XHMyAdressModel>()
                success(modelArr)
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }

    // MARK:- 获取商品收藏列表
    fileprivate func getMyCollection_goods_List(failure:@escaping (ErrorType) -> Void, success:@escaping ([XHCollection_goodsModel]) -> Void) -> XHCancelRequest? {
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        var paramDict = ["userid": userid ?? "", "userkey": token ?? ""]
        
        let url = xhbaseURL + "get_my_collect" + "&c=" + "MyCollect"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version =  (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["text"], let modelArr = Mapper<XHCollection_goodsModel>().mapArray(JSONObject: text)  {
                success(modelArr)
            }else {
                let modelArr = Array<XHCollection_goodsModel>()
                success(modelArr)
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }
    
    // MARK:- 获取店铺收藏列表
    fileprivate func getMyCollection_shop_List(failure:@escaping (ErrorType) -> Void, success:@escaping ([XHCollection_shopModel]) -> Void) -> XHCancelRequest? {
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        var paramDict = ["userid": userid ?? "", "userkey": token ?? ""]
        
        let url = xhbaseURL +  "get_my_shopcollect" + "&c=" + "MyCollect"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version =  (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["text"], let modelArr = Mapper<XHCollection_shopModel>().mapArray(JSONObject: text)  {
                success(modelArr)
            }else {
                let modelArr = Array<XHCollection_shopModel>()
                success(modelArr)
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }

    // MARK:- 取消商品收藏
    fileprivate func cancelCollection_goods(parameters: [String: String]?, failure:@escaping (ErrorType) -> Void, success:@escaping (Any) -> Void) -> XHCancelRequest? {
        
        guard var paramDict = parameters else {
            failure(ErrorType.networkError)
            return nil
        }
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        paramDict["userid"] = userid
        paramDict["userkey"] = token

        let url = xhbaseURL +  "qx_collect" + "&c=" + "MyCollect"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version =  (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            success((response as! [String: Any])["text"]!)
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }
    
    // MARK:- 取消店铺收藏
    fileprivate func cancelCollection_shop(parameters: [String: String]?, failure:@escaping (ErrorType) -> Void, success:@escaping (Any) -> Void) -> XHCancelRequest? {
        
        guard var paramDict = parameters else {
            failure(ErrorType.networkError)
            return nil
        }
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        paramDict["userid"] = userid
        paramDict["userkey"] = token

        
        let url = xhbaseURL +  "qx_shop_collect" + "&c=" + "MyCollect"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version =  (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
           success((response as! [String: Any])["text"]!)
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }

    // MARK:- 修改登录密码
    fileprivate func modifyLoginPassword(parameters: [String: String]?, failure:@escaping (ErrorType) -> Void, success:@escaping (Any) -> Void) -> XHCancelRequest? {
        
        guard var paramDict = parameters else {
            failure(ErrorType.networkError)
            return nil
        }
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        paramDict["userid"] = userid
        paramDict["userkey"] = token
        
        let url = xhbaseURL +  "password_modify" + "&c=" + "Uppwd"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version =  (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
           success((response as! [String: Any])["text"]!)
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }

    // MARK:- 修改支付密码
    fileprivate func modifyPayPassword(parameters: [String: String]?, failure:@escaping (ErrorType) -> Void, success:@escaping (Any) -> Void) -> XHCancelRequest? {
        
        guard var paramDict = parameters else {
            failure(ErrorType.networkError)
            return nil
        }
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        paramDict["userid"] = userid
        paramDict["userkey"] = token
        
        let url = xhbaseURL +  "paypassword_modify" + "&c=" + "Uppwd"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version =  (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            success((response as! [String: Any])["text"]!)
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }

    // MARK:- 忘记支付密码
    fileprivate func forgetPayPassword(parameters: [String: String]?, failure:@escaping (ErrorType) -> Void, success:@escaping (Any) -> Void) -> XHCancelRequest? {
        
        guard var paramDict = parameters else {
            failure(ErrorType.networkError)
            return nil
        }
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        paramDict["userid"] = userid
        paramDict["userkey"] = token
        
        let url = xhbaseURL + "forget_zhifupwd" + "&c=" + "Login"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version =  (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            success((response as! [String: Any])["text"]!)
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }
    
    // MARK:- 获取帮助中心列表
    fileprivate func getHelpCenterList(failure:@escaping (ErrorType) -> Void, success:@escaping ([XHHelpModel]) -> Void) -> XHCancelRequest? {
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        var paramDict = ["userid": userid ?? "", "userkey": token ?? ""]
        
        let url = xhbaseURL +  "get_help_list" + "&c=" + "News"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version =  (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["text"], let modelArr = Mapper<XHHelpModel>().mapArray(JSONObject: text)  {
                success(modelArr)
            }else {
                let modelArr = Array<XHHelpModel>()
                success(modelArr)
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }
    
    // MARK:- 获取平台公告列表
    fileprivate func getAnnouncementList(failure:@escaping (ErrorType) -> Void, success:@escaping ([XHHelpModel]) -> Void) -> XHCancelRequest? {
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        var paramDict = ["userid": userid ?? "", "userkey": token ?? ""]
        
        let url = xhbaseURL +  "get_topline_list" + "&c=" + "Index"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version =  (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["text"], let modelArr = Mapper<XHHelpModel>().mapArray(JSONObject: text)  {
                success(modelArr)
            }else {
                let modelArr = Array<XHHelpModel>()
                success(modelArr)
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }
    
    // MARK:- 获取新闻动态列表
    fileprivate func getNewsList(failure:@escaping (ErrorType) -> Void, success:@escaping ([XHNewsModel]) -> Void) -> XHCancelRequest? {
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        var paramDict = ["userid": userid ?? "", "userkey": token ?? ""]
        
        let url = xhbaseURL +  "news_list" + "&c=" + "News"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version =  (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["text"], let modelArr = Mapper<XHNewsModel>().mapArray(JSONObject: text)  {
                success(modelArr)
            }else {
                let modelArr = Array<XHNewsModel>()
                success(modelArr)
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }
    
    // MARK:- 获取银行列表
    fileprivate func getBankList(parameters: [String: String]?, failure:@escaping (ErrorType) -> Void, success:@escaping ([XHBankListModel]) -> Void) -> XHCancelRequest? {
        
        guard var paramDict = parameters else {
            failure(ErrorType.networkError)
            return nil
        }
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        paramDict["userid"] = userid
        paramDict["userkey"] = token
        
        let url = xhbaseURL +  "get_bank_list" + "&c=" + "Authen"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version =  (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["text"], let modelArr = Mapper<XHBankListModel>().mapArray(JSONObject: text)  {
                success(modelArr)
            }else {
                let modelArr = Array<XHBankListModel>()
                success(modelArr)
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }
    
    // MARK:- 获取银行卡分支机构列表
    fileprivate func getBankBranchList(parameters: [String: String]?, failure:@escaping (ErrorType) -> Void, success:@escaping (Any) -> Void) -> XHCancelRequest? {
        
        guard var paramDict = parameters else {
            failure(ErrorType.networkError)
            return nil
        }
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        paramDict["userid"] = userid
        paramDict["userkey"] = token
        
        let url = xhbaseURL +  "get_cnaps" + "&c=" + "Authen"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version =  (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["text"], let modelArr = Mapper<XHBankListModel>().mapArray(JSONObject: text)  {
                success(modelArr)
            }else {
                let modelArr = Array<XHBankListModel>()
                success(modelArr)
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }

    // MARK:- 保存银行卡信息
    fileprivate func saveBankData(parameters: [String: String]?, failure:@escaping (ErrorType) -> Void, success:@escaping (String) -> Void) -> XHCancelRequest? {
        
        guard var paramDict = parameters else {
            failure(ErrorType.networkError)
            return nil
        }
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        paramDict["userid"] = userid
        paramDict["userkey"] = token
        
        let url = xhbaseURL + "my_bank_modify" + "&c=" + "Authen"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version =  (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["text"]  {
                success(text as! String)
            }else {
                success("未知错误~")
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }
    
    // MARK:- 获取我的订单列表
    fileprivate func getMyOrdersList(parameters: [String: String]?, failure:@escaping (ErrorType) -> Void, success:@escaping (Any) -> Void) -> XHCancelRequest? {
        
        guard var paramDict = parameters else {
            failure(ErrorType.networkError)
            return nil
        }
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        paramDict["userid"] = userid
        paramDict["userkey"] = token
        
        let url = xhbaseURL +  "my_order_list" + "&c=" + "MyOrder"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version =  (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["text"], let orderModelArr = Mapper<XHMyOrderModel>().mapArray(JSONObject: text)  {
                success(orderModelArr)
            }else {
                success((response as! [String: Any])["text"])
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }
    
    // MARK:- 取消订单
    fileprivate func cancelMyOrder(parameters: [String: String]?, failure:@escaping (ErrorType) -> Void, success:@escaping (Any) -> Void) -> XHCancelRequest? {
        
        guard var paramDict = parameters else {
            failure(ErrorType.networkError)
            return nil
        }
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        paramDict["userid"] = userid
        paramDict["userkey"] = token
        
        let url = xhbaseURL +  "my_order_cancle" + "&c=" + "MyOrder"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version =  (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["text"] {
                success(text)
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }
    
    // MARK:- 删除订单
    fileprivate func removeMyOrder(parameters: [String: String]?, failure:@escaping (ErrorType) -> Void, success:@escaping (Any) -> Void) -> XHCancelRequest? {
        
        guard var paramDict = parameters else {
            failure(ErrorType.networkError)
            return nil
        }
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        paramDict["userid"] = userid
        paramDict["userkey"] = token
        
        let url = xhbaseURL +  "my_order_remove" + "&c=" + "MyOrder"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version =  (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["text"] {
                success(text)
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }
    
    // MARK:-  获取订单详情
    fileprivate func getMyOrderDetail(parameters: [String: String]?, failure:@escaping (ErrorType) -> Void, success:@escaping (Any) -> Void) -> XHCancelRequest? {
        
        guard var paramDict = parameters else {
            failure(ErrorType.networkError)
            return nil
        }
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        paramDict["userid"] = userid
        paramDict["userkey"] = token
        
        let url = xhbaseURL +   "get_order_detail" + "&c=" + "MyComment"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version =  (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["text"], let orderModel = Mapper<XHMyOrderModel>().map(JSONObject: text) {
                success(orderModel)
            }else {
                success(String(describing: ((response as! [String: Any])["text"])!))
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }

    // MARK:- 获取我的订单 线下消费订单列表
    fileprivate func getMyOrder_offlineOrdersList(parameters: [String: String]?, failure:@escaping (ErrorType) -> Void, success:@escaping (Any) -> Void) -> XHCancelRequest? {
        
        guard var paramDict = parameters else {
            failure(ErrorType.networkError)
            return nil
        }
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        paramDict["userid"] = userid
        paramDict["userkey"] = token
        
        let url = xhbaseURL + "my_shoporder"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version =  (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["text"], let modelArr = Mapper<XHShopOfflineOrderModel>().mapArray(JSONObject: text) {
                success(modelArr)
            }else {
                success("未知错误~")
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }
    
    // MARK:- 退货申请
    fileprivate func applyForSalesReturn(parameters: [String: String]?, failure:@escaping (ErrorType) -> Void, success:@escaping (Any) -> Void) -> XHCancelRequest? {
        
        guard var paramDict = parameters else {
            failure(ErrorType.networkError)
            return nil
        }
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        paramDict["userid"] = userid
        paramDict["hyid"] = userid
        paramDict["userkey"] = token
        
        let url = xhbaseURL +  "apply_for_return" + "&c=" + "MyOrder"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version =  (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["text"] {
                success(String(describing: text as! String))
            }else {
                success(String(describing: (response as! [String: Any])["text"]))
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }

    // MARK:- 物流详情
    fileprivate func checkLogisticsDetail(parameters: [String: String]?, failure:@escaping (ErrorType) -> Void, success:@escaping (Any) -> Void) -> XHCancelRequest? {
        
        guard var paramDict = parameters else {
            failure(ErrorType.networkError)
            return nil
        }
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        paramDict["userid"] = userid
        paramDict["hyid"] = userid
        paramDict["userkey"] = token
        
        let url = xhbaseURL +  "ckwl" + "&c=" + "Wallet"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version =  (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["text"], let modelList = Mapper<XHLogisticsModel>().mapArray(JSONObject: text) {
                success(modelList)
            }else {
                success((response as! [String: Any])["text"])
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }

    // MARK:- 确认收货 postPayment_integral
    fileprivate func confirmGotSales(parameters: [String: String]?, failure:@escaping (ErrorType) -> Void, success:@escaping (Any) -> Void) -> XHCancelRequest? {
        
        guard var paramDict = parameters else {
            failure(ErrorType.networkError)
            return nil
        }
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        paramDict["userid"] = userid
        paramDict["hyid"] = userid
        paramDict["userkey"] = token
        
        let url = xhbaseURL +  "my_order_conform" + "&c=" + "MyOrder"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version =  (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["text"] {
                success(text as! String)
            }else {
                success("未知错误~")
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }
    
    // MARK:- 获取我的评价列表 commitMyValuation
    fileprivate func getMyValuationList(parameters: [String: String]?, failure:@escaping (ErrorType) -> Void, success:@escaping (Any) -> Void) -> XHCancelRequest? {
        
        guard var paramDict = parameters else {
            failure(ErrorType.networkError)
            return nil
        }
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        paramDict["userid"] = userid
        paramDict["hyid"] = userid
        paramDict["userkey"] = token
        
        let state: String = paramDict["state"]!
        
        let url = xhbaseURL + "get_comment_list_new" + "&c=" + "MyComment"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version =  (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if state == "1" {
                if let text = (response as! [String: Any])["text"], let modelArr = Mapper<XHMyValuationModel>().mapArray(JSONObject: text) {
                    success(modelArr)
                }else {
                    success( (response as! [String: Any])["text"])
                }
            }else {
                if let text = (response as! [String: Any])["text"], let modelArr = Mapper<XHMyElavation_CheckPendingModel>().mapArray(JSONObject: text) {
                    success(modelArr)
                }else {
                    success( (response as! [String: Any])["text"])
                }
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }
    
    
    // MARK:- 提交我的评价
    fileprivate func commitMyValuation(parameters: [String: String]?, failure:@escaping (ErrorType) -> Void, success:@escaping (Any) -> Void) -> XHCancelRequest? {
        
        guard var paramDict = parameters else {
            failure(ErrorType.networkError)
            return nil
        }
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        paramDict["userid"] = userid
        paramDict["hyid"] = userid
        paramDict["userkey"] = token
        
        let url = xhbaseURL + "comment_modify" + "&c=" + "MyComment"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version =  (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["status"] {
                if (text as! NSNumber) == 1  {
                    success("评论提交成功")
                }else {
                    success(((response as! [String: Any])["text"]) as! String)
                    if ((response as! [String: Any])["text"]) as! String == "请重新登陆！" {
                        let login = XHLoginController()
                        let nav = XHNavigationController(rootViewController: login)
                        UIApplication.shared.keyWindow?.rootViewController?.present(nav, animated: true, completion: nil)
                    }
                }
            }else {
                success("未知错误~")
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }
    
    // MARK:- 积分支付
    fileprivate func postPayment_integral(parameters: [String: String]?, failure:@escaping (ErrorType) -> Void, success:@escaping (Any) -> Void) -> XHCancelRequest? {
        
        guard var paramDict = parameters else {
            failure(ErrorType.networkError)
            return nil
        }
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        paramDict["userid"] = userid
        paramDict["hyid"] = userid
        paramDict["userkey"] = token
        
        let url = xhbaseURL + "user_pay_jifen" + "&c=" + "MyOrder"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version =  (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["status"] {
                if (text as! NSNumber) == 1  {
                    success("支付成功")
                }else {
                    success((response as! [String: Any])["text"])
                }
            }else {
                success("未知错误~")
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }
}

extension XHRequest {
    // MARK:- 获取商盟分类列表
    fileprivate func getFriendClassifyList(failure:@escaping (ErrorType) -> Void, success:@escaping ([XHFriendClassModel]) -> Void) -> XHCancelRequest? {
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        var paramDict = ["userid": userid ?? "", "userkey": token ?? ""]
        
        let url = xhbaseURL +  "get_dmdspcate_list" + "&c=" + "Dmdlist"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version =  (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["text"], let modelArr = Mapper<XHFriendClassModel>().mapArray(JSONObject: text)  {
                success(modelArr)
                NSKeyedArchiver.archiveRootObject(modelArr, toFile:friendCalssesPath)
            }else {
                let modelArr = Array<XHFriendClassModel>()
                success(modelArr)
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }
    
    // MARK:- 获取推荐商铺列表
    fileprivate func getRecommendShopsList(parameters: [String: String]?, failure:@escaping (ErrorType) -> Void, success:@escaping ([XHBussinessShopModel]) -> Void) -> XHCancelRequest? {
        
        guard var paramDict = parameters else {
            failure(ErrorType.networkError)
            return nil
        }
                
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        paramDict["userid"] = userid
        paramDict["userkey"] = token
        
        let url = xhbaseURL +  "get_dmd_list" + "&c=" + "Dmdlist"
        
        let cateid = paramDict["cateid"]
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version =  (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["text"], let modelArr = Mapper<XHBussinessShopModel>().mapArray(JSONObject: text)  {
                success(modelArr)
                if cateid == "0" {
                    NSKeyedArchiver.archiveRootObject(modelArr, toFile:friendRecommendPath)
                }
            }else {
                let modelArr = Array<XHBussinessShopModel>()
                success(modelArr)
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }

    // MARK:- 获取店铺详情
    fileprivate func getShopDetail(parameters: [String: String]?, failure:@escaping (ErrorType) -> Void, success:@escaping (Any) -> Void) -> XHCancelRequest? {
        
        guard var paramDict = parameters else {
            failure(ErrorType.networkError)
            return nil
        }
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        paramDict["userid"] = userid
        paramDict["userkey"] = token
        
        let url = xhbaseURL + "get_dmd_detail" + "&c=" + "Dmd"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version =  (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            
            if let text = (response as! [String: Any])["text"], let model = Mapper<XHShopDetailModel>().map(JSONObject: text) {
                success(model)
            }else {
                success( (response as! [String: Any])["text"] as! String)
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }

    // MARK:- 获取店铺商品列表
    fileprivate func getShopDetail_goodsList(parameters: [String: String]?, failure:@escaping (ErrorType) -> Void, success:@escaping ([XHGoodsListModel]) -> Void) -> XHCancelRequest? {
        
        guard var paramDict = parameters else {
            failure(ErrorType.networkError)
            return nil
        }
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        paramDict["userid"] = userid
        paramDict["userkey"] = token
        
        let url = xhbaseURL + "get_dmdgood_list" + "&c=" + "Dmd"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version =  (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["text"], let modelArr = Mapper<XHGoodsListModel>().mapArray(JSONObject: text) {
                success(modelArr)
            }else {
                let modelArr = Array<XHGoodsListModel>()
                success(modelArr)
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }

    // MARK:- 获取搜索店铺列表
    fileprivate func getSearchShopList(parameters: [String: String]?, failure:@escaping (ErrorType) -> Void, success:@escaping ([XHBussinessShopModel]) -> Void) -> XHCancelRequest? {
        
        guard var paramDict = parameters else {
            failure(ErrorType.networkError)
            return nil
        }
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        paramDict["userid"] = userid
        paramDict["userkey"] = token
        
        let url = xhbaseURL +  "search_dmd" + "&c=" + "Dmdlist"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version =  (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["text"], let modelArr = Mapper<XHBussinessShopModel>().mapArray(JSONObject: text) {
                success(modelArr)
            }else {
                let modelArr = Array<XHBussinessShopModel>()
                success(modelArr)
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }

    
    // MARK:- 收藏店铺
    fileprivate func addShopCollection(parameters: [String: String]?, failure:@escaping (ErrorType) -> Void, success:@escaping (String) -> Void) -> XHCancelRequest? {
        
        guard var paramDict = parameters else {
            failure(ErrorType.networkError)
            return nil
        }
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        paramDict["userid"] = userid
        paramDict["userkey"] = token
        
        let url = xhbaseURL +  "add_colect_shop" + "&c=" + "Dmd"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version =  (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["text"] {
                success(text as! String)
            }else {
                success("未知错误~")
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }

    // MARK:- 获取商品详情 getGoods_commentList
    fileprivate func getGoodsDetail(parameters: [String: String]?, failure:@escaping (ErrorType) -> Void, success:@escaping (XHGoodsDetailModel) -> Void) -> XHCancelRequest? {
        
        guard var paramDict = parameters else {
            failure(ErrorType.networkError)
            return nil
        }
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        paramDict["userid"] = userid
        paramDict["userkey"] = token
        
        let url = xhbaseURL + "get_sp_detail" + "&c=" + "Goods"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version =  (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["text"], let model = Mapper<XHGoodsDetailModel>().map(JSONObject: text) {
                success(model)
            }else {
                let model = XHGoodsDetailModel()
                success(model)
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }
    
    // MARK:- 获取商品详情中的评论列表
    fileprivate func getGoods_commentList(parameters: [String: String]?, failure:@escaping (ErrorType) -> Void, success:@escaping (Any) -> Void) -> XHCancelRequest? {
        
        guard var paramDict = parameters else {
            failure(ErrorType.networkError)
            return nil
        }
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        paramDict["userid"] = userid
        paramDict["userkey"] = token
        
        let url = xhbaseURL + "get_sp_detail" + "&c=" + "Goods"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version =  (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["text"], let model = Mapper<XHGoods_commentModel>().mapArray(JSONObject: text) {
                success(model)
            }else {
                let modelArr: [XHGoods_commentModel] = []
                success(modelArr)
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }
    
    // MARK:- 检查商品库存
    fileprivate func checkGoodsStock(parameters: [String: String]?, failure:@escaping (ErrorType) -> Void, success:@escaping ([XHGoodsPropertyModel]) -> Void) -> XHCancelRequest? {
        
        guard var paramDict = parameters else {
            failure(ErrorType.networkError)
            return nil
        }
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        paramDict["userid"] = userid
        paramDict["userkey"] = token
        
        let url = xhbaseURL + "get_sp_zd1" + "&c=" + "Goods"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version =  (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["text"], let modelArr = Mapper<XHGoodsPropertyModel>().mapArray(JSONObject: text) {
                success(modelArr)
            }else {
                let modelArr = [XHGoodsPropertyModel]()
                success(modelArr)
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }

    
    // MARK:- 获取积分兑换商品详情
    fileprivate func getIntegral_GoodsDetail(parameters: [String: String]?, failure:@escaping (ErrorType) -> Void, success:@escaping (XHGoodsDetailModel) -> Void) -> XHCancelRequest? {
        
        guard var paramDict = parameters else {
            failure(ErrorType.networkError)
            return nil
        }
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        paramDict["userid"] = userid
        paramDict["userkey"] = token
        
        let url = xhbaseURL + "get_spjifen_detail" + "&c=" + "Goodsjf"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version =  (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["text"], let model = Mapper<XHGoodsDetailModel>().map(JSONObject: text) {
                success(model)
            }else {
                let model = XHGoodsDetailModel()
                success(model)
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }

    // MARK:- 添加商品收藏
    fileprivate func addProductCollection_goodsDetail(parameters: [String: String]?, failure:@escaping (ErrorType) -> Void, success:@escaping (String) -> Void) -> XHCancelRequest? {
        
        guard var paramDict = parameters else {
            failure(ErrorType.networkError)
            return nil
        }
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        paramDict["userid"] = userid
        paramDict["userkey"] = token
        
        let url = xhbaseURL + "add_collect" + "&c=" + "MyCollect"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version =  (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["text"] {
                success(text as! String)
            }else {
                success("失败~")
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }

    // MARK:- 添加商品到购物车
    fileprivate func addGoodsToShoppingCart(parameters: [String: String]?, failure:@escaping (ErrorType) -> Void, success:@escaping (String) -> Void) -> XHCancelRequest? {
        
        
        guard var paramDict = parameters else {
            failure(ErrorType.networkError)
            return nil
        }
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        paramDict["userid"] = userid
        paramDict["userkey"] = token
        
        let url = xhbaseURL +  "add_cart" + "&c=" + "Goods"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version =  (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["status"] {
                if (text as! NSNumber) == 1 {
                    success("\(String(describing: ((response as! [String: Any])["text"])!))")
                }else {
                    success(((response as! [String: Any])["text"]) as! String)
                }
            }else {
                success("添加失败")
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }
    
    // MARK:- 获取购物车列表
    fileprivate func getShoppingCartList(failure:@escaping (ErrorType) -> Void, success:@escaping ([XHShoppingCartModel]) -> Void) -> XHCancelRequest? {
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        var paramDict = ["userid": userid ?? "", "userkey": token ?? ""]
        
        let url = xhbaseURL + "get_cart_list" + "&c=" + "Car"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version =  (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["text"], let modelArr = Mapper<XHShoppingCartModel>().mapArray(JSONObject: text) {
                success(modelArr)
            }else {
                let mapArr = Array<XHShoppingCartModel>()
                success(mapArr)
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }
    
    // MARK:- 修改购物车商品
    fileprivate func modifyShoppingCartGoods(parameters: [String: Any]?, failure:@escaping (ErrorType) -> Void, success:@escaping (String) -> Void) -> XHCancelRequest? {
        
        guard var paramDict = parameters else {
            failure(ErrorType.networkError)
            return nil
        }
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        paramDict["userid"] = userid
        paramDict["userkey"] = token
        
        let url = xhbaseURL +  "change_cart" + "&c=" + "Car"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version =  (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["text"]{
                success(text as! String)
            }else {
                success("未知错误")
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }

    // MARK:- 获取默认收货人信息
    fileprivate func getDefaultAddresseeInfo(failure:@escaping (ErrorType) -> Void, success:@escaping (Any) -> Void) -> XHCancelRequest? {
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        var paramDict = ["userid": userid ?? "", "userkey": token ?? ""]
        
        let url = xhbaseURL + "get_address" + "&c=" + "Car"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version =  (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["text"], let modelArr = Mapper<XHMyAdressModel>().map(JSONObject: text) {
                success(modelArr)
            }else {
                
                success((response as! [String: Any])["text"])
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }

    
    // MARK:- 获取可用余额
    fileprivate func getEffectiveBanlance(failure:@escaping (ErrorType) -> Void, success:@escaping (Any) -> Void) -> XHCancelRequest? {
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        var paramDict = ["userid": userid ?? "", "userkey": token ?? ""]
        
        let url = xhbaseURL + "get_balance" + "&c=" + "Payment"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version =  (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["text"] {
                success(text)
            }else {
                success((response as! [String: Any])["text"])
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }

    // MARK:- 获取支付方式列表
    fileprivate func getPaymentList(failure:@escaping (ErrorType) -> Void, success:@escaping (Any) -> Void) -> XHCancelRequest? {
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        var paramDict = ["userid": userid ?? "", "userkey": token ?? ""]
        
        let url = xhbaseURL + "config_pay" + "&c=" + "Payment"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version =  (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["text"] {
                success(text)
            }else {
                success((response as! [String: Any])["text"])
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }
    
    // MARK:- 提交订单  ------ 普通商品
    fileprivate func commitOrder_common(parameters: [String: Any]?, failure:@escaping (ErrorType) -> Void, success:@escaping (String) -> Void) -> XHCancelRequest? {
        
        guard var paramDict = parameters else {
            failure(ErrorType.networkError)
            return nil
        }
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        paramDict["userid"] = userid
        paramDict["userkey"] = token
        
        let url = xhbaseURL + "add_order" + "&c=" + "Car"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version =  (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["text"]{
                success(text as! String)
            }else {
                success("未知错误")
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }

    // MARK:- 提交订单   积分订单
    fileprivate func commitOrder_integral(parameters: [String: Any]?, failure:@escaping (ErrorType) -> Void, success:@escaping (String) -> Void) -> XHCancelRequest? {
        
        guard var paramDict = parameters else {
            failure(ErrorType.networkError)
            return nil
        }
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        paramDict["userid"] = userid
        paramDict["userkey"] = token
        
        let url = xhbaseURL + "add_jifenorder" + "&c=" + "Goodsjf"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version =  (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["text"]{
                success(text as! String)
            }else {
                success("未知错误")
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }

    // MARK:- 支付过程中 查看订单
    fileprivate func getPayment_orderDetail(parameters: [String: String]?, failure:@escaping (ErrorType) -> Void, success:@escaping (Any) -> Void) -> XHCancelRequest? {
        
        guard var paramDict = parameters else {
            failure(ErrorType.networkError)
            return nil
        }
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        paramDict["userid"] = userid
        paramDict["userkey"] = token
        
        let type = paramDict["type"]
        
        let lastUrl = type == "3" ? "get_shop_order_detail" : "get_cart_order_detail"
        
        let url = xhbaseURL + lastUrl + "&c=" + "Payment"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version =  (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["text"], let model = Mapper<XHPaymentOrderDetailModel>().map(JSONObject: text) {
                success(model)
            }else {
                success((response as! [String: Any])["text"])
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }

    
    // MARK:- 获取二维码支付图片
    fileprivate func getQRCoderPaymentImage(parameters: [String: String]?, failure:@escaping (ErrorType) -> Void, success:@escaping (String) -> Void) -> XHCancelRequest? {
        
        guard var paramDict = parameters else {
            failure(ErrorType.networkError)
            return nil
        }
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        paramDict["userid"] = userid
        paramDict["userkey"] = token
        
        let style = paramDict["style"]
        let lastUrl = style == "1" ? "get_shoppay_ewm" : "get_shoppay_ewm2"
        let url = xhbaseURL +  lastUrl + "&c=" + "Payment"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version =  (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["text"]{
                success(text as! String)
            }else {
                success("未知错误")
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }
    
    // MARK:- 测试当日限额
    fileprivate func testPeydayLimitMoney(parameters: [String: String]?, failure:@escaping (ErrorType) -> Void, success:@escaping (String) -> Void) -> XHCancelRequest? {
        
        guard var paramDict = parameters else {
            failure(ErrorType.networkError)
            return nil
        }
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        paramDict["userid"] = userid
        paramDict["userkey"] = token
        
        let url = xhbaseURL + "test_pay_yu" + "&c=" + "Payment"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version =  (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["status"]{
                if (text as? String) == "1" || text as? NSNumber == 1 {
                    success("可用")
                }else {
                    success((response as! [String: Any])["status"] as! String)
                }
            }else {
                success("未知错误")
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }

    // MARK:- 余额支付
    fileprivate func payment_banlance(parameters: [String: String]?, failure:@escaping (ErrorType) -> Void, success:@escaping (String) -> Void) -> XHCancelRequest? {
        
        guard var paramDict = parameters else {
            failure(ErrorType.networkError)
            return nil
        }
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        paramDict["userid"] = userid
        paramDict["userkey"] = token
        
        let style = paramDict["style"]
        let lastUrl = style == "1" ? ("shop_pay_yu" + "&c=" + "Business") : ("user_pay_yu" + "&c=" + "Payment" )
        let url = xhbaseURL + lastUrl
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version =  (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["status"]{
                if (text as! NSNumber) == 1 {
                    success("恭喜您，支付成功!")
                }
            }else {
                success("未知错误")
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }
    
    // MARK:- 获取用户当前的积分
    fileprivate func getUserCurrentIntegral(failure:@escaping (ErrorType) -> Void, success:@escaping (Any) -> Void) -> XHCancelRequest? {
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        var paramDict = ["userid": userid ?? "", "userkey": token ?? ""]
        
        let url = xhbaseURL +  "use_money" + "&c=" + "Cate"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version =  (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if (response as! [String: Any])["text"] is String {
               success((response as! [String: Any])["text"] as! String)
            }else {
                success((response as! [String: Any])["text"])
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }
}


// MARK:- ✡️✡️分类  类目
extension XHRequest {
    // MARK:- 获取分类列表
    fileprivate func getClassifyList(failure:@escaping (ErrorType) -> Void, success:@escaping ([XHClassifyModel]) -> Void) -> XHCancelRequest? {
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        var paramDict = ["userid": userid ?? "", "userkey": token ?? ""]
        
        let url = xhbaseURL + "get_sptype_list" + "&c=" + "Cate"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version =  (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["text"], var modelArr = Mapper<XHClassifyModel>().mapArray(JSONObject: text)  {
                modelArr.reverse()
                let classModel = XHClassifyModel()
                classModel.id = "-1"
                classModel.title = "推荐专区"
                modelArr.insert(classModel, at: 0)
                success(modelArr)
                NSKeyedArchiver.archiveRootObject(modelArr, toFile:classifyListPath)
            }else {
                let modelArr = Array<XHClassifyModel>()
                success(modelArr)
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }

    // MARK:- 获取特惠专区数据
    fileprivate func getClassify_SpecialZoneData(parameters: [String: String]?, failure:@escaping (ErrorType) -> Void, success:@escaping ([XHSpecialFavModel]) -> Void) -> XHCancelRequest? {
        
        guard var paramDict = parameters else {
            failure(ErrorType.networkError)
            return nil
        }
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        paramDict["userid"] = userid
        paramDict["userkey"] = token
        
        let url = xhbaseURL + "get_goods_list" + "&c=" + "Cate"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version =  (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["text"], let modelArr = Mapper<XHSpecialFavModel>().mapArray(JSONObject: text)  {
                success(modelArr)
            }else {
                let modelArr = Array<XHSpecialFavModel>()
                success(modelArr)
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }
    
    // MARK:- 获取推荐专区banner
    fileprivate func getClassify_recommend_banner(failure:@escaping (ErrorType) -> Void, success:@escaping ([XHClassifyBannerModel]) -> Void) -> XHCancelRequest? {
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        var paramDict = ["userid": userid ?? "", "userkey": token ?? ""]
        
        let url = xhbaseURL +  "top_banner" + "&c=" + "Index"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version =  (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["text"],  let modelArr = Mapper<XHClassifyBannerModel>().mapArray(JSONObject: text) {
                success(modelArr)
                NSKeyedArchiver.archiveRootObject(modelArr, toFile:cl_bannerPath)
            }else {
                let modelArr = Array<XHClassifyBannerModel>()
                success(modelArr)
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }

    // MARK:- 推荐专区 推荐类
    fileprivate func getClassify_recommend_recommend(failure:@escaping (ErrorType) -> Void, success:@escaping ([XHClassifyRecommendModel]) -> Void) -> XHCancelRequest? {
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        var paramDict = ["userid": userid ?? "", "userkey": token ?? ""]
        
        let url = xhbaseURL + "rec_sub" + "&c=" + "Cate"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version =  (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["text"],  let modelArr = Mapper<XHClassifyRecommendModel>().mapArray(JSONObject: text) {
                success(modelArr)
                NSKeyedArchiver.archiveRootObject(modelArr, toFile:cl_recommendPath)
            }else {
                let modelArr = Array<XHClassifyRecommendModel>()
                success(modelArr)
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }
    
    // MARK:- 推荐专区 热门分类
    fileprivate func getClassify_recommend_hotClassify(failure:@escaping (ErrorType) -> Void, success:@escaping ([XHClassifyHotModel]) -> Void) -> XHCancelRequest? {
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        var paramDict = ["userid": userid ?? "", "userkey": token ?? ""]
        
        let url = xhbaseURL + "hot_cate" + "&c=" + "Cate"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version =  (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["text"],  let modelArr = Mapper<XHClassifyHotModel>().mapArray(JSONObject: text) {
                success(modelArr)
                NSKeyedArchiver.archiveRootObject(modelArr, toFile:cl_hotPath)
            }else {
                let modelArr = Array<XHClassifyHotModel>()
                success(modelArr)
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }

    // MARK:- 获取类目子类数据
    fileprivate func getClassify_childClassesData(parameters: [String: String]?, failure:@escaping (ErrorType) -> Void, success:@escaping ([XHClassifyChildModel]) -> Void) -> XHCancelRequest? {
        
        guard var paramDict = parameters else {
            failure(ErrorType.networkError)
            return nil
        }
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        paramDict["userid"] = userid
        paramDict["userkey"] = token
        
        let url = xhbaseURL + "sec_cate" + "&c=" + "Cate"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version =  (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            
            if let text = (response as! [String: Any])["text"], let modelArr = Mapper<XHClassifyChildModel>().mapArray(JSONObject: text)  {
                success(modelArr)
            }else {
                let modelArr = Array<XHClassifyChildModel>()
                success(modelArr)
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }
    
    // MARK:- 获取专场数据
    fileprivate func getSessionData(parameters: [String: String]?, failure:@escaping (ErrorType) -> Void, success:@escaping (Any) -> Void) -> XHCancelRequest? {
        
        guard var paramDict = parameters else {
            failure(ErrorType.networkError)
            return nil
        }
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        paramDict["userid"] = userid
        paramDict["userkey"] = token
        
        let url = xhbaseURL +  "sub_list" + "&c=" + "Subject"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version =  (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            
            if let text = ((response as! [String: Any])["text"] as? Array<Any>)?[0], let model = Mapper<XHSessionModel>().map(JSONObject: text)  {
                success(model)
            }else {
                success((response as! [String: Any])["text"] as! String)
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }
    
    // MARK:- 获取搜索商品数据
    fileprivate func getSearchGoodsList(parameters: [String: String]?, failure:@escaping (ErrorType) -> Void, success:@escaping (Any) -> Void) -> XHCancelRequest? {
        
        guard var paramDict = parameters else {
            failure(ErrorType.networkError)
            return nil
        }
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        paramDict["userid"] = userid
        paramDict["userkey"] = token
        
        let url = xhbaseURL +  "sec_goods_list" + "&c=" + "Goods"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version =  (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            
            if let text = (response as! [String: Any])["text"], let model = Mapper<XHSpecialFavModel>().mapArray(JSONObject: text)  {
                success(model)
            }else {
                success((response as! [String: Any])["text"] as! String)
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }
}

// MARK:- ☯️☯️☯️ 首⃣页⃣网⃣络⃣请⃣求⃣
extension XHRequest {
    // MARK:- 获取循环指数
    fileprivate func getCirculation(failure:@escaping (ErrorType) -> Void, success:@escaping (XHCirculationModel) -> Void) -> XHCancelRequest? {
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        var paramDict = ["userid": userid ?? "", "userkey": token ?? ""]
        
        let url = xhbaseURL + "get_xunhuanzhishu" + "&c=" + "Index"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version =  (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["text"],  let model = Mapper<XHCirculationModel>().map(JSONObject: text) {
                success(model)
                NSKeyedArchiver.archiveRootObject(model, toFile:circulationPath)
            }else {
                let model = XHCirculationModel()
                success(model)
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }

    // MARK:- 获⃣取⃣首⃣页⃣通⃣知⃣
    fileprivate func getHomeNotice(failure:@escaping (ErrorType) -> Void, success:@escaping (XHHomeNoticeModel) -> Void) -> XHCancelRequest? {
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        var paramDict = ["userid": userid ?? "", "userkey": token ?? ""]
        
        let url = xhbaseURL + "get_new_notice" + "&c=" + "Test"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version = (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["app_version"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["text"],  let model = Mapper<XHHomeNoticeModel>().map(JSONObject: text) {
                success(model)
                NSKeyedArchiver.archiveRootObject(model, toFile:homeNoticePath)
            }else {
                let model = XHHomeNoticeModel()
                success(model)
            }
        }
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }

    
    // MARK:- 获⃣取⃣ 精⃣选⃣推⃣荐⃣商⃣品⃣ 列⃣表⃣
    fileprivate func getHomeRecommendGoodsList(failure:@escaping (ErrorType) -> Void, success:@escaping ([XHSpecialFavModel]) -> Void) -> XHCancelRequest? {
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        var paramDict = ["userid": userid ?? "", "userkey": token ?? ""]
        
        let url = xhbaseURL + "get_tuijian_good" + "&c=" + "Index"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version = (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["text"],  let modelArr = Mapper<XHSpecialFavModel>().mapArray(JSONObject: text) {
                success(modelArr)
                NSKeyedArchiver.archiveRootObject(modelArr, toFile:homeRecommend_GoodsListPath)
            }else {
                let modelArr = Array<XHSpecialFavModel>()
                success(modelArr)
            }
        }
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }
    
    // MARK:- 获⃣取⃣首⃣页⃣推⃣荐⃣b⃣a⃣n⃣n⃣e⃣r⃣数⃣组⃣
    fileprivate func getHomeRecommend_bannersList(failure:@escaping (ErrorType) -> Void, success:@escaping ([XHClassifyBannerModel]) -> Void) -> XHCancelRequest? {
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        var paramDict = ["userid": userid ?? "", "userkey": token ?? ""]
        
        let url = xhbaseURL + "mid_banner_goods" + "&c=" + "Index"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version = (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["text"],  let modelArr = Mapper<XHClassifyBannerModel>().mapArray(JSONObject: text) {
                success(modelArr)
                NSKeyedArchiver.archiveRootObject(modelArr, toFile:home_bannerPath)
            }else {
                let modelArr = Array<XHClassifyBannerModel>()
                success(modelArr)
            }
        }
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }

    // MARK:- 获⃣取⃣首⃣页⃣ 推⃣荐⃣ b⃣a⃣n⃣n⃣e⃣r⃣商品 数⃣组⃣
    fileprivate func getHomeRecommend_banners_GoodsList(failure:@escaping (ErrorType) -> Void, success:@escaping ([XHHomeBannerGoodsModel]) -> Void) -> XHCancelRequest? {
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        var paramDict = ["userid": userid ?? "", "userkey": token ?? ""]
        
        let url = xhbaseURL + "mid_banner_sub_ver" + "&c=" + "Index"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version = (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["text"],  let modelArr = Mapper<XHHomeBannerGoodsModel>().mapArray(JSONObject: text) {
                success(modelArr)
                NSKeyedArchiver.archiveRootObject(modelArr, toFile:homeBannerGoodsPath)
            }else {
                let modelArr = Array<XHHomeBannerGoodsModel>()
                success(modelArr)
            }
        }
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }
    
    // MARK:- 获⃣取⃣首⃣页⃣ 用户角色 数⃣组⃣
    fileprivate func getHomeUserPlatformList(failure:@escaping (ErrorType) -> Void, success:@escaping ([XHPlatformModel]) -> Void) -> XHCancelRequest? {
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        var paramDict = ["userid": userid ?? "", "userkey": token ?? ""]
        
        let url = xhbaseURL +  "get_role" + "&c=" + "Index"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version = (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["text"],  var modelArr = Mapper<XHPlatformModel>().mapArray(JSONObject: text) {
                let model = XHPlatformModel()
                model.status_name = "详情"
                model.title = "运营中心"
                model.subtitle = "品牌商家可申请成为运营中心，和循环宝商城一起共赢未来。"
                modelArr.append(model)
                success(modelArr)
            }else {
                let modelArr = Array<XHPlatformModel>()
                
                success(modelArr)
            }
        }
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }

    // MARK:- 获⃣取⃣ 指数排行 数⃣组⃣ getHomePlaneData
    fileprivate func getScaleRankList(failure:@escaping (ErrorType) -> Void, success:@escaping ([XHScaleRankModel]) -> Void) -> XHCancelRequest? {
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        var paramDict = ["userid": userid ?? "", "userkey": token ?? ""]
        
        let url = xhbaseURL +  "assignzs" + "&c=" + "Index"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version = (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["text"],  let modelArr = Mapper<XHScaleRankModel>().mapArray(JSONObject: text) {
                success(modelArr)
            }else {
                let modelArr = Array<XHScaleRankModel>()
                
                success(modelArr)
            }
        }
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }

    // MARK:- 积分商城数据列表
    fileprivate func getIntegralShopList(parameters: [String: String]?, failure:@escaping (ErrorType) -> Void, success:@escaping (Any) -> Void) -> XHCancelRequest? {
        
        guard var paramDict = parameters else {
            failure(ErrorType.networkError)
            return nil
        }
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        paramDict["userid"] = userid
        paramDict["userkey"] = token
        
        let url = xhbaseURL + "grade_goods_list" + "&c=" + "Goodsjf"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version = (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["text"], let modelList = Mapper<XHIntegralGoodsModel>().mapArray(JSONObject: text) {
                success(modelList)
            }else {
                success("未知错误~")
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }
    
    // MARK:- 获取首页 飞机报喜 数据
    fileprivate func getHomePlaneData(failure:@escaping (ErrorType) -> Void, success:@escaping(Any) -> Void) -> XHCancelRequest? {
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        var paramDict = ["userid": userid ?? "", "userkey": token ?? ""]
        
        let url = xhbaseURL +  "lucky_list_new" + "&c=" + "draw2"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version = (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["text"],  let modelArr = Mapper<XHLuckyModel>().mapArray(JSONObject: text) {
                success(modelArr)
            }
        }
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }
}

// MARK:- 店铺
extension XHRequest {
    // MARK:- 开通循环大使
    fileprivate func openAmbassador(failure:@escaping (ErrorType) -> Void, success:@escaping (String) -> Void) -> XHCancelRequest? {
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        var paramDict = ["userid": userid ?? "", "userkey": token ?? ""]
        
        let url = xhbaseURL + "add_cdds"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version = (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["text"] {
                success(text as! String)
            }
        }
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }
    
    // MARK:- 获取我的店铺信息
    fileprivate func getMyShopInfo(failure:@escaping (ErrorType) -> Void, success:@escaping (Any) -> Void) -> XHCancelRequest? {
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        var paramDict = ["userid": userid ?? "", "userkey": token ?? ""]
        
        let url = xhbaseURL +  "get_my_shop" + "&c=" + "Dmd"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version = (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["text"], let model = Mapper<XHMyShopModel>().map(JSONObject: text) {
                success(model)
            }else {
                success((response as! [String: Any])["text"])
            }
        }
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }

    // MARK:- 获取商家订单列表
    fileprivate func getMyShopOrdersList(parameters: [String: String]?, failure:@escaping (ErrorType) -> Void, success:@escaping (Any) -> Void) -> XHCancelRequest? {
        
        guard var paramDict = parameters else {
            failure(ErrorType.networkError)
            return nil
        }
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        paramDict["userid"] = userid
        paramDict["userkey"] = token
        
        let url = xhbaseURL + "my_shop_order_new" + "&c=" + "Dmdlist"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version = (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["text"], let modelList = Mapper<XHMyShopOrderModel>().mapArray(JSONObject: text) {
                success(modelList)
            }else {
                success("未知错误~")
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }
    
    // MARK:- 商家订单  取消
    fileprivate func cancelMyShopOrder(parameters: [String: String]?, failure:@escaping (ErrorType) -> Void, success:@escaping (Any) -> Void) -> XHCancelRequest? {
        
        guard var paramDict = parameters else {
            failure(ErrorType.networkError)
            return nil
        }
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        paramDict["userid"] = userid
        paramDict["userkey"] = token
        
        let url = xhbaseURL + "get_modify_order" + "&c=" + "Dmd"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version = (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["text"] {
                success(text as! String)
            }else {
                success("未知错误~")
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }

    // MARK:- 商家订单  详情
    fileprivate func getMyShopOrder_detail(parameters: [String: String]?, failure:@escaping (ErrorType) -> Void, success:@escaping (Any) -> Void) -> XHCancelRequest? {
        
        guard var paramDict = parameters else {
            failure(ErrorType.networkError)
            return nil
        }
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        paramDict["userid"] = userid
        paramDict["userkey"] = token
        
        let url = xhbaseURL +  "get_shop_order_detail" + "&c=" + "Business"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version = (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["text"], let model = Mapper<XHMyShopOrderDetailModel>().map(JSONObject: text) {
                success(model)
            }else {
                success("未知错误~")
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }
    
    // MARK:- 获取消费者昵称
    fileprivate func getCustomerNickname(parameters: [String: String]?, failure:@escaping (ErrorType) -> Void, success:@escaping (Any) -> Void) -> XHCancelRequest? {
        
        guard var paramDict = parameters else {
            failure(ErrorType.networkError)
            return nil
        }
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        paramDict["userid"] = userid
        paramDict["userkey"] = token
        
        let url = xhbaseURL + "get_muser" + "&c=" + "Business"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version = (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            
            if let text = (response as! [String: Any])["text"], let model = Mapper<XHTempUserModel>().map(JSONObject: text) {
                success(model)
            }else {
                success((response as! [String: Any])["text"])
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }

    // MARK:- 商家付款  提交订单
    fileprivate func shop_payment_commitOrder(parameters: [String: String]?, failure:@escaping (ErrorType) -> Void, success:@escaping (Any) -> Void) -> XHCancelRequest? {
        
        guard var paramDict = parameters else {
            failure(ErrorType.networkError)
            return nil
        }
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        paramDict["userid"] = userid
        paramDict["userkey"] = token
        
        let url = xhbaseURL + "dmd_shoporder_append" + "&c=" + "Business"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version = (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["text"], let model = Mapper<XHUserModel>().map(JSONObject: text) {
                success(model)
            }else {
                success((response as! [String: Any])["text"])
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }
    
    // MARK:- 请求店铺设置信息
    fileprivate func getMyShop_setting_info(failure:@escaping (ErrorType) -> Void, success:@escaping (Any) -> Void) -> XHCancelRequest? {
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        var paramDict = ["userid": userid ?? "", "userkey": token ?? ""]
        
        let url = xhbaseURL + "my_shop_setting" + "&c=" + "Dmd"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version = (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["text"], let model = Mapper<XHMyShop_settingModel>().map(JSONObject: text) {
                success(model)
            }else {
                success("未知错误~")
            }
        }
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }

    
    // MARK:- 请求店铺设置信息
    fileprivate func getMyShop_setting_classList(failure:@escaping (ErrorType) -> Void, success:@escaping (Any) -> Void) -> XHCancelRequest? {
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        var paramDict = ["userid": userid ?? "", "userkey": token ?? ""]
        
        let url = xhbaseURL + "get_dmd_type" + "&c=" + "Dmd"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version = (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["text"], let model = Mapper<XHFriendClassModel>().mapArray(JSONObject: text) {
                success(model)
            }else {
                success("未知错误~")
            }
        }
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }
    
    // MARK:- 开通店铺  保存信息 saveShopSettingInfo
    fileprivate func openShopSettingInfo(parameters: [String: String]?, failure:@escaping (ErrorType) -> Void, success:@escaping (Any) -> Void) -> XHCancelRequest? {
        
        guard var paramDict = parameters else {
            failure(ErrorType.networkError)
            return nil
        }
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        paramDict["userid"] = userid
        paramDict["userkey"] = token
        
        let type = paramDict["type"]
        let lastUrl = type == "0" ? "dmd_append&c=Dmd" : "dmd_append_brand&c=Dmdlist"
        
        let url = xhbaseURL + lastUrl
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version = (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
//        let headers: HTTPHeaders = [
//            "Authorization": "Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==",
//            "Accept": "application/json"
//        ]
//        requestPOSTURL(url, headers: headers, params: paramDict, failure: { (errorType, error)
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["status"] {
                if  (text as! NSNumber) == 1 {
                    success("资料设置成功")
                }else {
                    success((response as! [String: Any])["text"] as! String)
                }
            }else {
                success((response as! [String: Any])["text"])
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }
    
    // MARK:- 开通店铺  保存信息
    fileprivate func saveShopSettingInfo(parameters: [String: String]?, failure:@escaping (ErrorType) -> Void, success:@escaping (Any) -> Void) -> XHCancelRequest? {
        
        guard var paramDict = parameters else {
            failure(ErrorType.networkError)
            return nil
        }
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        paramDict["userid"] = userid
        paramDict["userkey"] = token
        
        let url = xhbaseURL + "my_shop_setting" + "&c=" + "Dmd"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version = (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["status"] {
                if (text as! NSNumber) == 1 {
                    success("保存成功")
                }else {
                    success("保存失败")
                }
            }else {
                success((response as! [String: Any])["text"])
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }

    // MARK:- 获取商家 用户订单列表
    fileprivate func getShopCustomerOrdersList(parameters: [String: String]?, failure:@escaping (ErrorType) -> Void, success:@escaping (Any) -> Void) -> XHCancelRequest? {
        
        guard var paramDict = parameters else {
            failure(ErrorType.networkError)
            return nil
        }
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        paramDict["userid"] = userid
        paramDict["userkey"] = token
        
        let url = xhbaseURL + "shop_user_order" + "&c=" + "Dmdlist"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version = (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["text"], let modelArr = Mapper<XHShop_customerOrdersModel>().mapArray(JSONObject: text) {
               success(modelArr)
            }else {
                success((response as! [String: Any])["text"])
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }

    // MARK:- 获取商家 用户订单详情
    fileprivate func getShopCustomer_Ordersdetail(parameters: [String: String]?, failure:@escaping (ErrorType) -> Void, success:@escaping (Any) -> Void) -> XHCancelRequest? {
        
        guard var paramDict = parameters else {
            failure(ErrorType.networkError)
            return nil
        }
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        paramDict["userid"] = userid
        paramDict["userkey"] = token
        
        let url = xhbaseURL + "get_order_detail" + "&c=" + "MyComment"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version = (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["text"], let modelArr = Mapper<XHMyOrderModel>().map(JSONObject: text) {
                success(modelArr)
            }else {
                success((response as! [String: Any])["text"] ?? "")
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }

    // MARK:- 店铺 确认退货
    fileprivate func myShop_postGoods_confirmReturnSales(parameters: [String: String]?, failure:@escaping (ErrorType) -> Void, success:@escaping (Any) -> Void) -> XHCancelRequest? {
        
        guard var paramDict = parameters else {
            failure(ErrorType.networkError)
            return nil
        }
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        paramDict["userid"] = userid
        paramDict["userkey"] = token
        
        let url = xhbaseURL + "deal_goods" + "&c=" + "Business"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version = (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["status"] {
                if (text as! NSNumber) == 1 {
                     success("操作成功")
                }else {
                    success((response as! [String: Any])["text"])
                }
            }else {
                success("未知错误~")
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }
    
    // MARK:- 店铺内消费
    fileprivate func innerCustomOrder(parameters: [String: String]?, failure:@escaping (ErrorType) -> Void, success:@escaping (Any) -> Void) -> XHCancelRequest? {
        
        guard var paramDict = parameters else {
            failure(ErrorType.networkError)
            return nil
        }
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        paramDict["userid"] = userid
        paramDict["userkey"] = token
        
        let url = xhbaseURL + "user_shoporder_append"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version = (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["status"] {
                if (text as! NSNumber) == 1 {
                    success((response as! [String: Any])["text"])
                }else {
                    success((response as! [String: Any])["text"])
                }
            }else {
                success("未知错误~")
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }
    
    // MARK:- 获取商铺 线下消费订单列表 getTabbarIconList
    fileprivate func getShop_offlineOrdersList(parameters: [String: String]?, failure:@escaping (ErrorType) -> Void, success:@escaping (Any) -> Void) -> XHCancelRequest? {
        
        guard var paramDict = parameters else {
            failure(ErrorType.networkError)
            return nil
        }
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        paramDict["userid"] = userid
        paramDict["userkey"] = token
        
        let url = xhbaseURL + "my_shop_userorder"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version =  (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["text"], let modelArr = Mapper<XHShopOfflineOrderModel>().mapArray(JSONObject: text) {
               success(modelArr)
            }else {
                success("未知错误~")
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }
    
    // MARK:- 获取tabbar图标列表
    fileprivate func getTabbarIconList(failure:@escaping (ErrorType) -> Void, success:@escaping (Any) -> Void) -> XHCancelRequest? {
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        var paramDict = ["userid": userid ?? "", "userkey": token ?? ""]
        
        let url = "http://appback.zxhshop.cn/app.php?do=" + "pic_sub"
//            xhbaseURL + "pic_sub"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version =  (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["text"], let modelArr = Mapper<XHTabbarIconModel>().mapArray(JSONObject: text) {
                success(modelArr)
            }else {
                success("未知错误~")
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }
}

// MARK:- 发现
extension XHRequest {
    // MARK:- 请求抽奖列表
    fileprivate func getLottoryList(failure:@escaping (ErrorType) -> Void, success:@escaping (Any) -> Void) -> XHCancelRequest? {
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        var paramDict = ["userid": userid ?? "", "userkey": token ?? ""]
        
        let url = xhbaseURL + "Jackpot_list_3" + "&c=" + "Drawe"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version =  (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["text"], let model = Mapper<XHLottoryModel>().mapArray(JSONObject: text) {
                success(model)
                NSKeyedArchiver.archiveRootObject(model, toFile: lottoryListPath)
            }else {
                let modelArr = Array<XHLottoryModel>()
                success(modelArr)
            }
        }
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }
    
    // MARK:- 请求积分兑换商品列表
    fileprivate func getIntegralGoodsList(failure:@escaping (ErrorType) -> Void, success:@escaping (Any) -> Void) -> XHCancelRequest? {
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        var paramDict = ["userid": userid ?? "", "userkey": token ?? ""]
        
        let url = xhbaseURL + "grade_goods_list" + "&c=" + "Goodsjf"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version = (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["text"], let model = Mapper<XHDiscoveryGoodsModel>().mapArray(JSONObject: text) {
                success(model)
                NSKeyedArchiver.archiveRootObject(model, toFile: discoveryGoodsPath)
            }else {
                let modelArr = Array<XHDiscoveryGoodsModel>()
                success(modelArr)
            }
        }
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }

    // MARK:- 请求抽奖规则
    fileprivate func getLottoryRegular(failure:@escaping (ErrorType) -> Void, success:@escaping (Any) -> Void) -> XHCancelRequest? {
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        var paramDict = ["userid": userid ?? "", "userkey": token ?? ""]
        
        let url = xhbaseURL + "draw_rule2" + "&c=" + "Drawe"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version = (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["text"] {
                success(text)
            }else {
                success("未知错误~")
            }
        }
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }
    
    // MARK:- 获取我的中奖信息
    fileprivate func getMyWinningMessage(parameters: [String: String]?, failure:@escaping (ErrorType) -> Void, success:@escaping (Any) -> Void) -> XHCancelRequest? {
        
        guard var paramDict = parameters else {
            failure(ErrorType.networkError)
            return nil
        }
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        paramDict["userid"] = userid
        paramDict["userkey"] = token
        
        let url = xhbaseURL + "draw_detail" + "&c=" + "Drawe"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version = (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["text"], let modelArr = Mapper<XHMyWinningModel>().mapArray(JSONObject: text) {
               success(modelArr)
            }else {
                success((response as! [String: Any])["text"])
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }

    // MARK:- 获取所有人的中奖信息
    fileprivate func getWinningMessageList(parameters: [String: String]?, failure:@escaping (ErrorType) -> Void, success:@escaping (Any) -> Void) -> XHCancelRequest? {
        
        guard var paramDict = parameters else {
            failure(ErrorType.networkError)
            return nil
        }
        
        let token = SSKeychain.password(forService: userTokenName, account: "TOKEN")
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        
        paramDict["userid"] = userid
        paramDict["userkey"] = token
        
        let url = xhbaseURL + "lucky_list" + "&c=" + "draw2"
        
        let infoDictionary: Dictionary = Bundle.main.infoDictionary!
        let version = (infoDictionary["CFBundleShortVersionString"] as? String)!
        paramDict["platformName"] = "iOS"
        paramDict["platformVersion"] = version
        
        let manager = XHNetworkTools.instance.requestPOSTURL(url, params: paramDict, failure: { (errorType, error) in
            failure(errorType)
        }) { (response) in
            if let text = (response as! [String: Any])["text"], let modelArr = Mapper<XHLuckyModel>().mapArray(JSONObject: text)  {
                success(modelArr)
            }else {
                success((response as! [String: Any])["text"])
            }
        }
        
        let cancelRequest = XHCancelRequest(request: manager)
        return cancelRequest
    }
}
