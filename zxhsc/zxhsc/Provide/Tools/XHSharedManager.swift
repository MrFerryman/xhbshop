//
//  XHSharedManager.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/8.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHSharedManager: NSObject {
    static let sharedInstance = XHSharedManager()
    private override init() {}
    
    func shared(sharedText: String?, saveImage: UIImage?, sharedUrl: URL?, sharedTitle: String?) {
        
        
        let activityItems = [sharedText, saveImage, sharedUrl] as [Any]
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
         activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.postToFacebook, UIActivityType.message, UIActivityType.copyToPasteboard, UIActivityType.mail, UIActivityType.print]
        
        UIApplication.shared.keyWindow?.rootViewController?.present(activityVC, animated: true, completion: nil)
        
        
        // 1.创建分享参数
//        let shareParames = NSMutableDictionary()
//        shareParames.ssdkSetupShareParams(byText: sharedText,
//                                         images : saveImage,
//                                         url : sharedUrl,
//                                         title : sharedTitle,
//                                         type : SSDKContentType.auto)
        //2.进行分享
//        ShareSDK.showShareActionSheet(UIApplication.shared.keyWindow, items: nil, shareParams: shareParames) { (state, type, nil, entity, error, finished) in
//            switch state{
//
//            case SSDKResponseState.success:
//                print("分享成功")
//                UIApplication.shared.keyWindow?.rootViewController?.showHint(in: UIApplication.shared.keyWindow!, hint: "分享成功")
//            case SSDKResponseState.fail:
//                print("授权失败,错误描述:\(String(describing: error))")
//                UIApplication.shared.keyWindow?.rootViewController?.showHint(in: UIApplication.shared.keyWindow!, hint: "分享失败")
//            case SSDKResponseState.cancel:
//                print("操作取消")
//                UIApplication.shared.keyWindow?.rootViewController?.showHint(in: UIApplication.shared.keyWindow!, hint: "分享取消")
//            default:
//                break
//            }
//
//        }
    }
}
