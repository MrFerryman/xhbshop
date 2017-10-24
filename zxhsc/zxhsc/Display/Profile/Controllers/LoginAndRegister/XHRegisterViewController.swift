//
//  XHRegisterViewController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/7/25.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHRegisterViewController: UIViewController {

    @IBOutlet weak var recommenderTF: UITextField! // 推荐人
    
    @IBOutlet weak var phoneNumberTF: UITextField!
    
    @IBOutlet weak var nicknameTF: UITextField!
    
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet weak var varCodeTF: UITextField!
    
    @IBOutlet weak var getVerCodeButton: UIButton!
    
    @IBOutlet weak var agreeButton: UIButton!
    
    
    @IBOutlet var updownMargin: [NSLayoutConstraint]!
    
    /// 定时器和计数
    private lazy var count:Int = 60
    private lazy var timer:Timer = Timer()

    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if kUIScreenWidth == 320 {
            for constr in updownMargin {
                constr.constant = 22
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        timer.invalidate()
    }
    
    // MARK:- ======== 事件相关 =========
    
    // MARK:- 查看密码按钮点击事件
    @IBAction func checkPasswordButtonClicked(_ sender: UIButton) {
        if sender.isSelected == true {
            sender.isSelected = false
            passwordTF.isSecureTextEntry = true
        }else {
            sender.isSelected = true
            passwordTF.isSecureTextEntry = false
        }
    }
    
    private func setupChildControllerNav() {
        let item = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem = item

        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : XHRgbColorFromHex(rgb: 0x333333)]
        navigationController?.navigationBar.shadowImage = nil
    }
    
    // MARK:- 注册按钮点击事件
    @IBAction func registerButtonClicked(_ sender: UIButton) {
        if isValid() == true {
            showHud(in: view)
            
            let paraDict = ["phone": phoneNumberTF.text!, "pwd": passwordTF.text!, "code": varCodeTF.text!, "nicheng": nicknameTF.text!, "user": (recommenderTF.text) ?? ""]
            
            _ = XHRequest.shareInstance.requestNetData(dataType: .register, parameters: paraDict, failure: { [weak self] (errorType) in
                self?.hideHud()
                var title: String?
                switch errorType {
                case .timeOut:
                    title = "网络请求超时，请重新请求~"
                default:
                    title = "网络请求错误，请重新请求~"
                }
                self?.showHint(in: (self?.view)!, hint: title!)
            }, success: { [weak self] (string) in
                self?.hideHud()
                let str = string as! String
                self?.showHint(in: (self?.view)!, hint: str)
                if str == "注册成功" {
                    TalkingData.onRegister((self?.phoneNumberTF.text)!, type: TDAccountType.registered, name: (self?.nicknameTF.text)!)
                    let time: TimeInterval = 0.5
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
                        self?.login()
                    }
                }
            })
        }
    }
    
    private func login() {
        let paraDict: [String: String] = ["user": phoneNumberTF.text!, "pwd": passwordTF.text!]
        showHud(in: view, hint: "登录中...", yOffset: 0)
        _ = XHRequest.shareInstance.requestNetData(dataType: .login, parameters: paraDict, failure: { [weak self] (errorType) in
            self?.hideHud()
            var title: String?
            switch errorType {
            case .timeOut:
                title = "网络请求超时，请重新登录~"
            default:
                title = "网络请求错误，请重新登录~"
            }
            self?.showHint(in: (self?.view)!, hint: title!)
            }, success: { [weak self] (userModel) in
                self?.hideHud()
                if userModel is XHUserModel {
                    let model = userModel as! XHUserModel
                    if model.loginStatus == .success {
                        self?.showHint(in: (self?.view)!, hint: "登录成功~")
                        TalkingData.onLogin(self?.phoneNumberTF.text, type: TDAccountType.type1, name: (self?.nicknameTF.text)!)
                        let time: TimeInterval = 1.0
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
                            //code
                            let setPay = XHSettingPayPswController()
                            setPay.isResigter = true
                            self?.navigationController?.pushViewController(setPay, animated: true)
                        }
                        
                        _ = XHRequest.shareInstance.requestNetData(dataType: .getShopStatus, failure: { (error) in
                        }) { (sth) in
                            if sth is XHShopDetailModel {
                                isOpenShop = true
                                UIApplication.shared.keyWindow?.rootViewController?.childViewControllers[2].title = "店铺"
                            }else {
                                isOpenShop = false
                                UIApplication.shared.keyWindow?.rootViewController?.childViewControllers[2].title = "商盟"
                            }
                        }
                    }
                }else {
                    let str = userModel as! String
                    self?.showHint(in: (self?.view)!, hint: str)
                }
                
        })
    }
    
    // MARK:- 勾选按钮点击事件
    @IBAction func agreeButtonClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    // MARK:- ---------------------------------------------------------
    // MARK:- 获取验证码按钮点击事件
    @IBAction func getVerCodeButtonClicked(_ sender: UIButton) {
        
        if XHRegularManager.isCalidateMobileNumber(num: phoneNumberTF.text!) {
            
            getJudgeImage(sender)
        }else {
            showHint(in: view, hint: "手机号输入有误，请重新输入~")
        }
    }
    
    // MARK:- 获取校验图片
    private func getJudgeImage(_ sender: UIButton) {
        
        let url = getImageURL()
        alertView.showWithImageUrlString(url)
        
        alertView.nextButtonClickedClosure = { [weak self] in
            self?.alertView.urlString = self?.getImageURL()
        }
        
        alertView.confirmButtonClickedClosure = { [weak self] code in
            self?.verifyImageCode(code, sender: sender)
        }
    }
    
    /// MARK:- 产生随机数 并形成URL
    private func getImageURL() -> String {
        let sth = phoneNumberTF.text! + "\(arc4random())"
        let randomStr = XHNetworkTools.instance.md5String(str: sth)
        let url = "http://118.190.142.233/app.php?do=test_img&c=Login&phone=" + phoneNumberTF.text! + "&" + randomStr
        return url
    }
    
    // MARK:- 验证图片验证码
    private func verifyImageCode(_ code: String, sender: UIButton) {
        let paraDict = ["code": code, "phone": phoneNumberTF.text!]
        XHAcquireVerificationCodeViewModel.verifyImageCode(target: self, paraDict: paraDict) { [weak self] (result) in
            let code = NSString(string: result).integerValue
            if code != 0 {
                self?.showHint(in: (self?.view)!, hint: "图片验证码无误~")
                self?.getCode(sender, code: result)
            }else {
                XHAlertController.showAlertSigleAction(title: "提示", message: result, confirmTitle: "确定", confirmComplete: nil)
            }
        }
    }
    
    // MARK:- ---------------------------------------------------------
    /// MARK:- 获取验证码
    private func getCode(_ sender: UIButton, code: String) {
        let paraDict: [String: String] = ["phone" : phoneNumberTF.text!, "code2": code]
        
        XHAcquireVerificationCodeViewModel.getCode(target: self, paraDict: paraDict, success: { [weak self] (str) in
            let range = str.components(separatedBy: "您的验证码是")
            let alertV = UIAlertController(title: "提示", message: str, preferredStyle: .alert)
            let confirmA = UIAlertAction(title: "确定", style: .cancel) { (action) in
                if str == "验证码发送成功,请注意查收短信" {
                    sender.isEnabled = false
                    //添加定时器
                    self?.timer.invalidate()
                    self?.timer = Timer.scheduledTimer(timeInterval: 1, target: self!, selector: #selector(self?.timerChange(timer:)), userInfo: nil, repeats: true)
                    self?.timer.fire()
                }else if range.count > 1 {
                    self?.timer.invalidate()
                    self?.timer = Timer.scheduledTimer(timeInterval: 1, target: self!, selector: #selector(self?.timerChange(timer:)), userInfo: nil, repeats: true)
                    self?.timer.fire()
                }
            }
            alertV.addAction(confirmA)
            self?.present(alertV, animated: true, completion: nil)
        })
    }
    
    //  定时器执行方法
    @objc private func timerChange(timer: Timer) -> () {
        
        getVerCodeButton.titleLabel?.text = "\(String(format: "%02zd", count))s"
        getVerCodeButton.setTitle("\(String(format: "%02zd", count))s", for: .normal)
        count = count - 1
        
        if count == -1 {
            timer.invalidate()
            count = 60
            getVerCodeButton.titleLabel?.text = "点击获取"
            getVerCodeButton.setTitle("点击获取", for: .normal)
            getVerCodeButton.isEnabled = true
        }
    }
    
    private func isValid() -> Bool {
        
        if recommenderTF.text?.isEmpty == false, XHRegularManager.isCalidateMobileNumber(num: recommenderTF.text!) == false {
            showHint(in: view, hint: "推荐人号码输入有误，请重新输入")
            return false
        }
        
        if XHRegularManager.isCalidateMobileNumber(num: phoneNumberTF.text!) == false {
            showHint(in: view, hint: "手机号码输入有误，请重新输入")
            return false
        }
        
        if nicknameTF.text?.isEmpty == true {
            showHint(in: view, hint: "昵称不能为空~")
            return false
        }
        
        if !XHRegularManager.isValidPassword(psw: passwordTF.text!) {
            showHint(in: view, hint: "密码输入有误，请重新输入~")
            return false
        }
        
        if varCodeTF.text?.isEmpty == true {
            showHint(in: view, hint: "验证码不能为空~")
            return false
        }
        
        return true
    }
    
    // MARK:- ======== 界面相关 =========
    private lazy var alertView: XHJudgeImageAlertView = Bundle.main.loadNibNamed("XHJudgeImageAlertView", owner: nil, options: nil)?.first as! XHJudgeImageAlertView

}
