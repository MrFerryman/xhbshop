//
//  AppDelegate.swift
//  zxhsc
//
//  Created by 12345678 on 2017/7/13.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, BMKGeneralDelegate, JPUSHRegisterDelegate {

    var window: UIWindow?
    var _mapManager: BMKMapManager?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // 创建窗口
        window = UIWindow()
        let tabbarC = XHTabBarController()
        window?.rootViewController = tabbarC
        window?.makeKeyAndVisible()
        
        //键盘
        IQKeyboardManager.sharedManager().enable = true
        
        XHShoppingCartViewModel.getShoppingCartList((UIApplication.shared.keyWindow?.rootViewController)!) { (result) in}
        
        setupSharedSDK()
        
        _ = XHRequest.shareInstance.requestNetData(dataType: .getShopStatus, failure: { (error) in
        }) { (sth) in
            if sth is XHShopDetailModel {
                tabbarC.childViewControllers[2].title = "店铺"
                isOpenShop = true
            }else {
                tabbarC.childViewControllers[2].title = "商盟"
                isOpenShop = false
            }
        }
        
//        XHTabbarViewModel().loadTabbarIconList { [weak self] (iconsList) in
//            if iconsList.count > 0 {
//
//                self?.modifyTabbarIcon(0, tabbarC: tabbarC, img_normal: iconsList[0].home_unselected, img_selected: iconsList[0].home_selected, imgName: "home_icon")
//
//                self?.modifyTabbarIcon(1, tabbarC: tabbarC, img_normal: iconsList[0].class_unselected, img_selected: iconsList[0].class_selected, imgName: "class_icon")
//
//                self?.modifyTabbarIcon(2, tabbarC: tabbarC, img_normal: iconsList[0].shop_unselected, img_selected: iconsList[0].shop_selected, imgName: "shop_icon")
//
//                self?.modifyTabbarIcon(3, tabbarC: tabbarC, img_normal: iconsList[0].discovery_unselected, img_selected: iconsList[0].discovery_selected, imgName: "discover_icon")
//
//                self?.modifyTabbarIcon(4, tabbarC: tabbarC, img_normal: iconsList[0].profile_unselected, img_selected: iconsList[0].profile_selected, imgName: "profile_icon")
//            }
//        }
        
        _mapManager = BMKMapManager()
        // 如果要关注网络及授权验证事件，请设定generalDelegate参数
        let ret = _mapManager?.start("X7RmillnuTG4wIDqhmcxTIZ636RUyqQa", generalDelegate: self)
        if ret == false {
            NSLog("manager start failed!")
        }
        
        /* 极光推送相关 */
        // 初始化APNs
        let entity = JPUSHRegisterEntity()
        entity.types = Int(JPAuthorizationOptions.alert.union(JPAuthorizationOptions.badge).union(JPAuthorizationOptions.sound).rawValue)
        JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
        // 初始化JPush
        JPUSHService.setup(withOption: launchOptions, appKey: "12f32b53ef28aa053d5414ef", channel: "App Store", apsForProduction: false)
        
        return true
    }
    
    // MARK:- 修改tabbar图标
    private func modifyTabbarIcon(_ index: Int, tabbarC: XHTabBarController, img_normal: String?, img_selected: String?, imgName: String) {
        
//        let resultStr = img_normal?.replacingOccurrences(of: ".png", with: "@2x.png")
        let imgURL = XHImageBaseURL + img_normal!
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: URL(string: imgURL)!)
            let normal_img = UIImage(data: data!)
            let filePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first! + img_normal!
           
            if ((try? UIImagePNGRepresentation(normal_img!)?.write(to: URL(fileURLWithPath: filePath), options: .atomic)) != nil) {
                tabbarC.childViewControllers[index].tabBarItem.image = UIImage(contentsOfFile: filePath)
            }
        }
        
        let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 22, height: 22))
        imgView.sd_setImage(with: URL(string: XHImageBaseURL + (img_normal ?? imgName)), placeholderImage: UIImage(named: imgName), options: .progressiveDownload, progress: { (resiveP, exceptP, url) in
            print(exceptP)
        }) { (image, error, cachaType, url)  in
            
        }
        
        tabbarC.childViewControllers[index].tabBarItem.image = imgView.image
        
        let imgView0 = UIImageView()
        imgView0.sd_setImage(with: URL(string: XHImageBaseURL + (img_selected ?? imgName)), placeholderImage: UIImage(named: imgName), options: .progressiveDownload, completed: { (image, error, cachaType, url) in
            tabbarC.childViewControllers[index].tabBarItem.selectedImage = image
        })
    }

    /// MARK:- 初始化分享
    private func setupSharedSDK() {
        /**
         *  初始化ShareSDK应用
         *
         *  @param activePlatforms          使用的分享平台集合，如:@[@(SSDKPlatformTypeSinaWeibo), @(SSDKPlatformTypeTencentWeibo)];
         *  @param importHandler           导入回调处理，当某个平台的功能需要依赖原平台提供的SDK支持时，需要在此方法中对原平台SDK进行导入操作。具体的导入方式可以参考ShareSDKConnector.framework中所提供的方法。
         *  @param configurationHandler     配置回调处理，在此方法中根据设置的platformType来填充应用配置信息
         */
        
        ShareSDK.registerActivePlatforms( [SSDKPlatformType.typeWechat.rawValue],
            onImport: {(platform : SSDKPlatformType) -> Void in
                switch platform {
                case SSDKPlatformType.typeWechat:
                    ShareSDKConnector.connectWeChat(WXApi.classForCoder())
                default:
                    break
                }
        },
            onConfiguration: {(platform : SSDKPlatformType , appInfo : NSMutableDictionary?) -> Void in
                switch platform {
                case SSDKPlatformType.typeWechat:
                    //设置微信应用信息
                    appInfo?.ssdkSetupWeChat(byAppId: "wx9dfc4b2157c65590",
                                             appSecret: "b19e59933bbe4538fd3e4bb291a6f694")
                default:
                    break
                }
        })
    }
    
    
    // MARK:- ********** 有关推送 ****************
    // 注册APNs成功并上报DeviceToken
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        /// Required - 注册 DeviceToken
        JPUSHService.registerDeviceToken(deviceToken)
    }
    
    // 实现注册APNs失败接口（可选）
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("did Fail To Register For Remote Notifications With Error: \(error)")
    }
    
    // 添加处理APNs通知回调方法
    // iOS 10 Support
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        
        let userInfo = notification.request.content.userInfo
        let badgeCount = notification.request.content.badge as! Int
        JPUSHService.setBadge(badgeCount)
        
        if notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self) == true {
            JPUSHService.handleRemoteNotification(userInfo)
        }
        
        completionHandler(Int(JPAuthorizationOptions.alert.union(JPAuthorizationOptions.badge).union(JPAuthorizationOptions.sound).rawValue)) // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
    }
    
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        let userInfo = response.notification.request.content.userInfo
        if response.notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self) == true {
            JPUSHService.handleRemoteNotification(userInfo)
            
            // 发送通知，跳转到消息详情页
        }
        completionHandler() // 系统要求执行这个方法
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        JPUSHService.handleRemoteNotification(userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        JPUSHService.handleRemoteNotification(userInfo)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

