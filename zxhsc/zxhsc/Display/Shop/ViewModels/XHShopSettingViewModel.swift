//
//  XHShopSettingViewModel.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/10.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import ObjectMapper

class XHShopSettingViewModel: NSObject {

    var dataSourceArr: Array<XHShopSettingModel>? = []
    
    /// MARK:- 请求店铺设置信息
    class func getShop_setting_info( _ targetVc: UIViewController, dataArrClosure: @escaping ((_ result: Any) -> ())) {
        targetVc.showHud(in: targetVc.view)
        _ = XHRequest.shareInstance.requestNetData(dataType: .getMyShop_setting_data, failure: { (errorType) in
            targetVc.hideHud()
            var title: String?
            switch errorType {
            case .timeOut:
                title = "网络请求超时，请重新请求~"
            default:
                title = "网络请求错误，请重新请求~"
            }
            targetVc.showHint(in: targetVc.view, hint: title!)
        }, success: { (sth) in
            targetVc.hideHud()
            dataArrClosure(sth)
        })
    }
    
    /// MARK:- 请求店铺分类列表
    class func getShop_setting_classList( _ targetVc: UIViewController, dataArrClosure: @escaping ((_ result: Any) -> ())) {
        targetVc.showHud(in: targetVc.view)
        _ = XHRequest.shareInstance.requestNetData(dataType: .getShop_classList, failure: { (errorType) in
            targetVc.hideHud()
            var title: String?
            switch errorType {
            case .timeOut:
                title = "网络请求超时，请重新请求~"
            default:
                title = "网络请求错误，请重新请求~"
            }
            targetVc.showHint(in: targetVc.view, hint: title!)
        }, success: { (sth) in
            targetVc.hideHud()
            dataArrClosure(sth)
        })
    }
    
    // MARK:- 保存店铺信息
    static func saveShopInfo(_ paraDict: [String: String], _ targetVc: UIViewController, dataArrClosure: @escaping ((_ result: Any) -> ())) {
        targetVc.showHud(in: targetVc.view)
        _ = XHRequest.shareInstance.requestNetData(dataType: .saveShopSettingInfo, parameters: paraDict, failure: { (errorType) in
            targetVc.hideHud()
            var title: String?
            switch errorType {
            case .timeOut:
                title = "网络请求超时，请重新请求~"
            default:
                title = "网络请求错误，请重新请求~"
            }
            targetVc.showHint(in: targetVc.view, hint: title!)
        }, success: { (sth) in
            targetVc.hideHud()
            dataArrClosure(sth)
        })
    }

    override init() {
        
        let filePath = Bundle.main.path(forResource: "Shop_setting_Plist.plist", ofType: nil)
        let arr = NSArray(contentsOfFile: filePath!) as! Array<Dictionary<String, Any>>
        
        dataSourceArr = Mapper<XHShopSettingModel>().mapArray(JSONArray: arr)
    }
    
    // MARK:- 开通店铺信息
    static func openShopInfo(_ paraDict: [String: String], _ targetVc: UIViewController, dataArrClosure: @escaping ((_ result: Any) -> ())) {
        targetVc.showHud(in: targetVc.view)
        _ = XHRequest.shareInstance.requestNetData(dataType: .openShopSettingInfo, parameters: paraDict, failure: { (errorType) in
            targetVc.hideHud()
            var title: String?
            switch errorType {
            case .timeOut:
                title = "网络请求超时，请重新请求~"
            default:
                title = "网络请求错误，请重新请求~"
            }
            targetVc.showHint(in: targetVc.view, hint: title!)
        }, success: { (sth) in
            targetVc.hideHud()
            dataArrClosure(sth)
        })
    }
}
