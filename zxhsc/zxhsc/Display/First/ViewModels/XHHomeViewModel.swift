//
//  XHHomeViewModel.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/28.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHHomeViewModel: NSObject {

    static let sharedInstance = XHHomeViewModel()
    
    /// MARK:- 获取首页banner数组
    func getHomeBannerList(_ targetVc: XHFirstViewController, dataArrClosure: @escaping ((_ listArr: Array<XHClassifyBannerModel>) -> ())) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        _ = XHRequest.shareInstance.requestNetData(dataType: .getRecommend_banner, failure: { (errorType) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            var title: String?
            switch errorType {
            case .timeOut:
                title = "网络请求超时，请重新请求~"
            default:
                title = "网络请求错误，请重新请求~"
            }
            targetVc.showHint(in: targetVc.view, hint: title!)
            if targetVc.tableView.mj_header != nil {
                targetVc.tableView.mj_header.endRefreshing()
            }
            }, success: { (sth) in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                if sth is [XHClassifyBannerModel] {
                    let arr = sth as! [XHClassifyBannerModel]
                    dataArrClosure(arr)
                }
        })
    }
    
    /// MARK:- 获取循环指数
    func getCirculation(_ targetVc: XHFirstViewController, dataClosure: @escaping ((_ circulationModel: XHCirculationModel) -> ())) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        _ = XHRequest.shareInstance.requestNetData(dataType: .getCirculation, failure: { (errorType) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            var title: String?
            switch errorType {
            case .timeOut:
                title = "网络请求超时，请重新请求~"
            default:
                title = "网络请求错误，请重新请求~"
            }
            targetVc.showHint(in: targetVc.view, hint: title!)
            if targetVc.tableView.mj_header != nil {
                targetVc.tableView.mj_header.endRefreshing()
            }
        }, success: { (sth) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if sth is XHCirculationModel {
                dataClosure(sth as! XHCirculationModel)
            }
        })
    }
    
    /// MARK:- 获取通知
    func getNotice(_ targetVc: XHFirstViewController, dataClosure: @escaping ((_ noticeModel: XHHomeNoticeModel) -> ())) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        _ = XHRequest.shareInstance.requestNetData(dataType: .getHomeNotice, failure: { (errorType) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            var title: String?
            switch errorType {
            case .timeOut:
                title = "网络请求超时，请重新请求~"
            default:
                title = "网络请求错误，请重新请求~"
            }
            targetVc.showHint(in: targetVc.view, hint: title!)
            if targetVc.tableView.mj_header != nil {
                targetVc.tableView.mj_header.endRefreshing()
            }
        }, success: { (sth) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if sth is XHHomeNoticeModel {
                dataClosure(sth as! XHHomeNoticeModel)
            }
        })
    }
    
    /// MARK:- 获取精选推荐商品列表
    func getRecommend_goodsList(_ targetVc: XHFirstViewController, dataClosure: @escaping ((_ goodsList: [XHSpecialFavModel]) -> ())) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        _ = XHRequest.shareInstance.requestNetData(dataType: .getHomeRecommend_goodsList, failure: { (errorType) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            var title: String?
            switch errorType {
            case .timeOut:
                title = "网络请求超时，请重新请求~"
            default:
                title = "网络请求错误，请重新请求~"
            }
            targetVc.showHint(in: targetVc.view, hint: title!)
            if targetVc.tableView.mj_header != nil {
                targetVc.tableView.mj_header.endRefreshing()
            }
        }, success: { (sth) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if sth is [XHSpecialFavModel] {
                dataClosure(sth as! [XHSpecialFavModel])
            }
        })
    }
    
    /// MARK:- 获取推⃣荐⃣部⃣分⃣ 商品b⃣a⃣n⃣n⃣e⃣r⃣列表
    func getRecommend_bannersList(_ targetVc: XHFirstViewController, dataClosure: @escaping ((_ bannersList: [XHClassifyBannerModel]) -> ())) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        _ = XHRequest.shareInstance.requestNetData(dataType: .getHomeRecommend_bannersList, failure: { (errorType) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            var title: String?
            switch errorType {
            case .timeOut:
                title = "网络请求超时，请重新请求~"
            default:
                title = "网络请求错误，请重新请求~"
            }
            targetVc.showHint(in: targetVc.view, hint: title!)
            if targetVc.tableView.mj_header != nil {
                targetVc.tableView.mj_header.endRefreshing()
            }
        }, success: { (sth) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if sth is [XHClassifyBannerModel] {
                dataClosure(sth as! [XHClassifyBannerModel])
            }
        })
    }

    /// MARK:- 获取推⃣荐⃣部⃣分⃣ 商品列表
    func getRecommend_banners_goods_List(_ targetVc: XHFirstViewController, dataClosure: @escaping ((_ bannersList: [XHHomeBannerGoodsModel]) -> ())) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        _ = XHRequest.shareInstance.requestNetData(dataType: .getHomeRecommend_banner_goods_list, failure: { (errorType) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            var title: String?
            switch errorType {
            case .timeOut:
                title = "网络请求超时，请重新请求~"
            default:
                title = "网络请求错误，请重新请求~"
            }
            targetVc.showHint(in: targetVc.view, hint: title!)
            if targetVc.tableView.mj_header != nil {
                targetVc.tableView.mj_header.endRefreshing()
            }
            
        }, success: { (sth) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if sth is [XHHomeBannerGoodsModel] {
                dataClosure(sth as! [XHHomeBannerGoodsModel])
            }
        })
    }
    
    /// MARK:- 获取获奖信息列表
    func getLuckyList(paraDict: [String: String], _ targetVc: XHFirstViewController, dataClosure: @escaping ((_ luckyList: [XHLuckyModel]) -> ())) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        _ = XHRequest.shareInstance.requestNetData(dataType: .getWinningList, parameters:paraDict, failure: { (errorType) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            var title: String?
            switch errorType {
            case .timeOut:
                title = "网络请求超时，请重新请求~"
            default:
                title = "网络请求错误，请重新请求~"
            }
            targetVc.showHint(in: targetVc.view, hint: title!)
        }, success: { (sth) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if sth is [XHLuckyModel] {
                dataClosure(sth as! [XHLuckyModel])
            }
        })
    }
    
    /// MARK:- 获取 飞机报喜 数据
    func getHomePlaneData(_ targetVc: XHFirstViewController, dataClosure: @escaping ((_ bannersList: [XHLuckyModel]) -> ())) {
        _ = XHRequest.shareInstance.requestNetData(dataType: .getHomePlaneData, failure: { (errorType) in
            var title: String?
            switch errorType {
            case .timeOut:
                title = "网络请求超时，请重新请求~"
            default:
                title = "网络请求错误，请重新请求~"
            }
            targetVc.showHint(in: targetVc.view, hint: title!)
        }, success: { (sth) in
            if sth is [XHLuckyModel] {
                dataClosure(sth as! [XHLuckyModel])
            }
        })
    }

    private override init() {}
}
