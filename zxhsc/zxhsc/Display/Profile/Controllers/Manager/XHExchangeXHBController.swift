//
//  XHExchangeXHBController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/11/8.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import SSKeychain

class XHExchangeXHBController: UIViewController {

    @IBOutlet weak var freezed_xhbL: UILabel! // 当前冻结循环宝
    
    @IBOutlet weak var activity_xhbL: UILabel! // 当前正在激励循环宝
    
    @IBOutlet weak var navHeightCon: NSLayoutConstraint!
    
    @IBOutlet weak var accountTF: UITextField!
    
    @IBOutlet weak var nicknameL: UILabel!
    
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    @IBOutlet weak var countTF: UITextField!
    
    @IBOutlet weak var freezedButton: UIButton!
    
    @IBOutlet weak var unfreezedButton: UIButton!
    
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet weak var confirmButton: UIButton!
    
    /// 当前选中的循环宝类型 1 - 冻结 2 - 激励
    var current_XHB_type: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        confirmButton.layer.cornerRadius = 6
        confirmButton.layer.masksToBounds = true
        
        freezedButton.isSelected = true
        
        activityView.isHidden = true
        
        //点击空白处收回键盘 注册点击事件
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:))))
        
        accountTF.addTarget(self, action: #selector(customerPhoneNumberEditDidEnd), for: .editingDidEnd)
        
        getUserEarning()
    }

    @IBAction func confirmButtonClicked(_ sender: UIButton) {
        accountTF.resignFirstResponder()
        countTF.resignFirstResponder()
        passwordTF.resignFirstResponder()
        
        if judge() == true {
            postRequest()
        }
    }
    
    private func postRequest() {
        
        let paraDict = ["phone": accountTF.text!, "zhifupass": passwordTF.text!, "xhb": countTF.text!, "type": "\(current_XHB_type)"]
        XHProfileViewModel.post_exchange_xhb(target: self, paramter: paraDict) { (result) in
            var title = "交易成功!!!"
            
            if (result as! String) != "转宝成功" {
               title = result as! String
            }
            XHAlertController.showAlertSigleAction(title: "提示", message: title, confirmTitle: "确定", confirmComplete: { [weak self] in
                self?.accountTF.text = ""
                self?.nicknameL.text = "转宝人昵称"
                self?.countTF.text = ""
                self?.passwordTF.text = ""
                self?.freezedButton.isSelected = true
                self?.unfreezedButton.isSelected = false
                self?.current_XHB_type = 1
                self?.nicknameL.textColor = XHRgbColorFromHex(rgb: 0xaaaaaa)
            })
        }
    }
    
    // MARK:- 冻结按钮点击事件
    @IBAction func freezedButtonClicked(_ sender: UIButton) {
        sender.isSelected = true
        unfreezedButton.isSelected = false
        current_XHB_type = 1
    }
    
    // MARK:- 激励按钮点击事件
    @IBAction func unfreezedButtonClicked(_ sender: UIButton) {
        sender.isSelected = true
        freezedButton.isSelected = false
        current_XHB_type = 2
    }
    
    // MARK:- 获取用户收益
    private func getUserEarning() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        _ = XHRequest.shareInstance.requestNetData(dataType: .getUserEarning, failure: { [weak self] (errorType) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            var title: String?
            switch errorType {
            case .timeOut:
                title = "网络请求超时，请重新请求~"
            default:
                title = "网络请求错误，请重新请求~"
            }
            self?.showHint(in: (self?.view)!, hint: title!)
        }) { [weak self] (sth) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if sth is XHUserEarningModel {
                let userE = sth as! XHUserEarningModel
                self?.freezed_xhbL.text = "\(userE.xhb_freezed)个"
                self?.activity_xhbL.text = "\(String(describing: (userE.xhb_now ?? 0)))个"
            }else {
                let str = sth as! String
                self?.showHint(in: (self?.view)!, hint: str)
                
                if str == "请重新登陆！" {
                    SSKeychain.deletePassword(forService: userTokenName, account: "TOKEN")
                    SSKeychain.deletePassword(forService: userTokenName, account: "USERID")
                   let login = XHLoginController()
                    let nav = XHNavigationController(rootViewController: login)
                    self?.present(nav, animated: true, completion: nil)
                }
            }
        }
    }
    
    
    // MARK:- 消费者手机号输入完成后的方法
    @objc private func customerPhoneNumberEditDidEnd() {
        if XHRegularManager.isCalidateMobileNumber(num: accountTF.text!) == false {
            showHint(in: view, hint: "消费者手机号输入有误，请重新输入~")
        }else {
            getCustomerNickname()
        }
    }
    
    // MARK:- 获取消费者昵称
    private func getCustomerNickname() {
        let paraDict = ["muser": accountTF.text!]
        activityView.isHidden = false
        XHMyShopViewModel.getCustomerDetail(paraDict, self) { [weak self] (result) in
            if result is XHTempUserModel {
                self?.nicknameL.text = (result as! XHTempUserModel).nickname
                self?.nicknameL.alpha = 0
                self?.nicknameL.alpha = 1
                self?.activityView.isHidden = true
                self?.nicknameL.textColor = XHRgbColorFromHex(rgb: 0x666666)
            }else {
                XHAlertController.showAlertSigleAction(title: "提示", message: "\(result as! String)", confirmTitle: "朕晓得了", confirmComplete: nil)
            }
        }
    }
    
    // MARK:- 点击空白处收回键盘 实现方法
    @objc func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            accountTF.resignFirstResponder()
            countTF.resignFirstResponder()
            passwordTF.resignFirstResponder()
        }
        sender.cancelsTouchesInView = false
    }

    // MARK:- 逻辑判断
    private func judge() -> Bool {
        if nicknameL.text == "收宝人昵称" {
            showHint(in: view, hint: "请输入收宝人账号~")
            return false
        }
        
        if NSString(string: countTF.text!).floatValue < 1 {
            showHint(in: view, hint: "转宝数量不能少于 1 个~")
            return false
        }
        
        if NSString(string: passwordTF.text!).length < 6 {
            showHint(in: view, hint: "支付密码有误，请重新输入~")
            return false
        }
        return true
    }
}
