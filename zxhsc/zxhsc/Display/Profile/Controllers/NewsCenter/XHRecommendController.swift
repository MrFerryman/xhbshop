//
//  XHRecommendController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/7/31.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import SSKeychain

class XHRecommendController: UIViewController {

    @IBOutlet weak var qrCodeView: UIImageView!
    
    @IBOutlet weak var whiteView: UIView!
    
    @IBOutlet weak var nameL: UILabel!
    
    @IBOutlet weak var nicknameL: UILabel!
    
    @IBOutlet weak var phoneNumL: UILabel!
    
    
    @IBOutlet weak var logoBottomCon: NSLayoutConstraint!
    
    @IBOutlet weak var detalBottomCon: NSLayoutConstraint!
    
    
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    fileprivate let viewName = "荐码页面"
    
    private var userModel: XHMemberDetailModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if kUIScreenWidth == 320 {
            logoBottomCon.constant = 50
            detalBottomCon.constant = 65
        }
        
        whiteView.layer.cornerRadius = 6
        whiteView.layer.masksToBounds = true
        
        setupNav()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
        loadMemberDetail()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TalkingData.trackPageBegin(viewName)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        TalkingData.trackPageEnd(viewName)
    }
    
    
    /// MARK:- 返回按钮点击事件
    @objc private func rightBarButtonClicked() {
        dismiss(animated: true, completion: nil)
    }
    
    private func loadData() {
        _ = XHRequest.shareInstance.requestNetData(dataType: .getQRCodeImage, failure: { [weak self] (errorType) in
            var title: String?
            switch errorType {
            case .timeOut:
                title = "网络请求超时，请重新请求~"
            default:
                title = "网络请求错误，请重新请求~"
            }
            self?.showHint(in: (self?.view)!, hint: title!)
        }) { [weak self] (sth) in
            if XHRegularManager.isValidationURL(str: sth as! String) == true {
                self?.qrCodeView.sd_setImage(with: URL(string: sth as! String), placeholderImage: UIImage(named: XHPlaceholdImage), options: .progressiveDownload, completed: { (image, error, chacheType, url) in
                    self?.activityView.isHidden = true
                })
            }else {
                XHAlertController.showAlertSigleAction(title: nil, message: sth as? String, confirmTitle: "确定", confirmComplete: nil)
            }
        }
    }
    
    
    private func loadMemberDetail() {
        _ = XHRequest.shareInstance.requestNetData(dataType: .get_memberDetail, failure: { [weak self] (errorType) in
            self?.loadMemberDetail()
        }) { [weak self] (model) in
            if model is XHMemberDetailModel {
                let userModel = model as! XHMemberDetailModel
                
                self?.userModel = userModel
                
                self?.nameL.text = userModel.name
                self?.nicknameL.text = userModel.nickname
                self?.phoneNumL.text = userModel.account
            }else {
                XHAlertController.showAlertSigleAction(title: nil, message: model as? String, confirmTitle: "确定", confirmComplete: nil)
            }
        }
    }
    
    ///  MARK:- 分享按钮点击事件
    @objc private func sharedButtonClicked() {
        
        if userModel != nil {
            // 1. 创建分享参数
            let saveImage = UIImage(named: "profile_header_icon")
            
            // 分享文本
            let sharedText = "推荐人:" + String(describing: (userModel?.name)!) + "(" + String(describing: (userModel?.nickname)!) + ")"
            // 标题
            let sharedTitle = "循环宝商城推荐二维码"
            // url
            let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
            let url = "http://wx2.zxhshop.cn/index.php?m=Reg&cid=" + (userid ?? "")
            let sharedUrl = URL(string: url)
            
            XHSharedManager.sharedInstance.shared(sharedText: sharedText, saveImage: saveImage, sharedUrl: sharedUrl, sharedTitle: sharedTitle)
        }else {
            showHint(in: view, hint: "数据请求中，请稍后再试~")
        }
        
    }
    
    private func setupNav() {
        //导航栏透明
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        let rightItem = UIBarButtonItem(image: UIImage(named: "Profile_login_close")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(rightBarButtonClicked))
        navigationItem.leftBarButtonItem = rightItem
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        let sharedItem = UIBarButtonItem(image: UIImage(named: "shop_shared_white")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(sharedButtonClicked))
        navigationItem.rightBarButtonItem = sharedItem
    }
}
