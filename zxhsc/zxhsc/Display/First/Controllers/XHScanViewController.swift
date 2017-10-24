//
//  XHScanViewController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/14.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import ObjectMapper
import swiftScan

class XHScanViewController: LBXScanViewController {
    
    /**
     @brief  扫码区域上方提示文字
     */
    var topTitle:UILabel?
    
    /**
     @brief  闪关灯开启状态
     */
    var isOpenedFlash:Bool = false
    
    // MARK: - 底部几个功能：开启闪光灯、相册、我的二维码
    
    //底部显示的功能项
    var bottomItemsView:UIView?
    
    //相册
    var btnPhoto:UIButton = UIButton()
    
    //闪光灯
    var btnFlash:UIButton = UIButton()
    
    //我的二维码
    var btnMyQR:UIButton = UIButton()
    
    fileprivate let viewName = "二维码扫描页面"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNav()
        
        //需要识别后的图像
        setNeedCodeImage(needCodeImg: true)
        
        //框向上移动10个像素
//        scanStyle?.centerUpOffset += 10
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TalkingData.trackPageBegin(viewName)
        drawBottomItems()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        TalkingData.trackPageEnd(viewName)
    }
    
    override func handleCodeResult(arrayResult: [LBXScanResult]) {
        
        for result:LBXScanResult in arrayResult
        {
            if let str = result.strScanned {
                print(str)
            }
        }
        
        let result:LBXScanResult = arrayResult[0]
        
        if XHRegularManager.isValidationURL(str: result.strScanned!) == true {
            let vc = XHWebViewController()
            vc.urlStr = result.strScanned
            navigationController?.pushViewController(vc, animated: true)
        }else {
            
            if result.strScanned?.localizedCaseInsensitiveContains("shop_id") == true {
                let scanner = Scanner(string: result.strScanned!)
                scanner.scanUpToCharacters(from: CharacterSet.decimalDigits, into: nil)
                var number :Int = 0
                scanner.scanInt(&number)
                
                let shopV = XHBussinessShopController()
                shopV.shopId = "\(number)"
                navigationController?.pushViewController(shopV, animated: true)
                return
            }
            
            let alertC = UIAlertController(title: "扫描结果", message: String(describing: result.strScanned!), preferredStyle: .alert)
           
            let cancelA = UIAlertAction(title: "确定", style: .cancel, handler: nil)
            alertC.addAction(cancelA)
            present(alertC, animated: true, completion: nil)
        }
    }
    
    func getDictionaryFromJSONString(jsonString:String) ->NSDictionary{
        
        let jsonData:Data = jsonString.data(using: .utf8)!
        
        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if dict != nil {
            return dict as! NSDictionary
        }
        return NSDictionary()
    }
    
    func drawBottomItems()
    {
        if (bottomItemsView != nil) {
            
            return;
        }
        
        let yMax = self.view.frame.maxY - self.view.frame.minY
        bottomItemsView = UIView(frame:CGRect(x: 0.0, y: yMax - 100,width: self.view.frame.size.width, height: 100 ) )
        
        bottomItemsView!.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.6)
        
        self.view .addSubview(bottomItemsView!)
        
        let size = CGSize(width: 65, height: 87);
        
        self.btnFlash = UIButton()
        btnFlash.bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        btnFlash.center = CGPoint(x: bottomItemsView!.frame.width / 4, y: bottomItemsView!.frame.height / 2)
        btnFlash.setImage(UIImage(named: "CodeScan.bundle/qrcode_scan_btn_flash_nor"), for:UIControlState.normal)
        btnFlash.addTarget(self, action: #selector(XHScanViewController.openOrCloseFlash), for: UIControlEvents.touchUpInside)
        
        self.btnPhoto = UIButton()
        btnPhoto.bounds = btnFlash.bounds
        btnPhoto.center = CGPoint(x: bottomItemsView!.frame.width * 3 / 4, y: bottomItemsView!.frame.height/2)
        btnPhoto.setImage(UIImage(named: "CodeScan.bundle/qrcode_scan_btn_photo_nor"), for: UIControlState.normal)
        btnPhoto.setImage(UIImage(named: "CodeScan.bundle/qrcode_scan_btn_photo_down"), for: UIControlState.highlighted)
        btnPhoto.addTarget(self, action: #selector(LBXScanViewController.openPhotoAlbum), for: UIControlEvents.touchUpInside)
        
        bottomItemsView?.addSubview(btnFlash)
        bottomItemsView?.addSubview(btnPhoto)
        
        self.view .addSubview(bottomItemsView!)
    }
    
    //开关闪光灯
    @objc func openOrCloseFlash()
    {
        scanObj?.changeTorch();
        
        isOpenedFlash = !isOpenedFlash
        
        if isOpenedFlash
        {
            btnFlash.setImage(UIImage(named: "CodeScan.bundle/qrcode_scan_btn_flash_down"), for:UIControlState.normal)
        }
        else
        {
            btnFlash.setImage(UIImage(named: "CodeScan.bundle/qrcode_scan_btn_flash_nor"), for:UIControlState.normal)
        }
    }
    
    @objc private func dismissCrrentView() {
        dismiss(animated: true, completion: nil)
    }
    
    private func setupNav() {
        title = "扫一扫"
        navigationController?.navigationBar.tintColor = XHRgbColorFromHex(rgb: 0x333333)
        let leftItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissCrrentView))
        navigationItem.leftBarButtonItem = leftItem
    }
    
}

class XHScanResultModel: Mappable {
    
    /// 店铺ID
    var shop_id: String?
    
    init() {}
    
    required init?(map: Map) {}

   func mapping(map: Map) {
        shop_id <- map["shop_id"]
    }
}
