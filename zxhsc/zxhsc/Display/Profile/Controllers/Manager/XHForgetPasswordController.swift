//
//  XHForgetPasswordController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/7/25.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHForgetPasswordController: UIViewController {

    @IBOutlet weak var topCon: NSLayoutConstraint!
    @IBOutlet weak var phoneNumTF: UITextField!
    
    @IBOutlet weak var newPasswordTF: UITextField!
    
    @IBOutlet weak var verCodeTF: UITextField!
    
    @IBOutlet weak var getVerCodeButton: UIButton!
    
    fileprivate var viewName = ""
    /// 是否是修改支付密码
    var isPaymentPassword: Bool = false {
        didSet {
            viewName = isPaymentPassword == true ? "修改支付密码页面" : "忘记登录密码页面"
        }
    }
    
    /// 定时器和计数
    private lazy var count:Int = 60
    private lazy var timer:Timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if KUIScreenHeight == 812 {
            topCon.constant = 90
        }else {
            topCon.constant = 64
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if isPaymentPassword == true {
            newPasswordTF.placeholder = "请输入新密码"
        }else {
            newPasswordTF.placeholder = "请输入新密码(英文字符加数字组合)"
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TalkingData.trackPageBegin(viewName)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        TalkingData.trackPageEnd(viewName)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func checkPasswordButtonClicked(_ sender: UIButton) {
        if sender.isSelected == true {
            sender.isSelected = false
            newPasswordTF.isSecureTextEntry = true
        }else {
            sender.isSelected = true
            newPasswordTF.isSecureTextEntry = false
        }
    }
    @IBAction func getVerCodeButtonClicked(_ sender: UIButton) {
        if XHRegularManager.isCalidateMobileNumber(num: phoneNumTF.text!) {
            if isPaymentPassword == true {
                getJudgeImage(sender)
                return
            }
           forgetPswPost(sender: sender)
        }else {
            showHint(in: view, hint: "手机号输入有误，请重新输入~")
        }
    }
    
    @IBAction func confirmButtonClicked(_ sender: UIButton) {
        if isValid() == true {
            reset_forgetPsw()
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
        let sth = phoneNumTF.text! + "\(arc4random())"
        let randomStr = XHNetworkTools.instance.md5String(str: sth)
        let url = "http://118.190.142.233/app.php?do=test_img&c=Login&phone=" + phoneNumTF.text! + "&" + randomStr
        return url
    }
    
    // MARK:- 验证图片验证码
    private func verifyImageCode(_ code: String, sender: UIButton) {
        let paraDict = ["code": code, "phone": phoneNumTF.text!]
        XHAcquireVerificationCodeViewModel.verifyImageCode(target: self, paraDict: paraDict) { [weak self] (result) in
            let code = NSString(string: result).integerValue
            if code != 0 {
                self?.showHint(in: (self?.view)!, hint: "图片验证码无误~")
                self?.forgetPswPost(sender: sender)
            }else {
                XHAlertController.showAlertSigleAction(title: "提示", message: result, confirmTitle: "确定", confirmComplete: nil)
            }
        }
    }
    // MARK:- ------------------------------------------------------------------
    // MARK:- 忘记密码中的 获取验证码
    private func forgetPswPost(sender: UIButton) {
        
        let paraDict = ["phone" : phoneNumTF.text] as! [String: String]
        
        showHud(in: view, hint: "发送中...", yOffset: 0)
        _ = XHRequest.shareInstance.requestNetData(dataType: .acquireVerCode_forgetPsw, parameters: paraDict, failure: { [weak self] (errorType) in
            self?.hideHud()
            var title: String?
            switch errorType {
            case .timeOut:
                title = "网络请求超时，请重新请求~"
            default:
                title = "网络请求错误，请重新请求~"
            }
            self?.showHint(in: (self?.view)!, hint: title!)
        }) {[weak self] (sth) in
            self?.hideHud()
            let str = sth as! String
            self?.showHint(in: (self?.view)!, hint: str)
            
            if str == "验证码发送成功,请注意查收短信" {
                sender.isEnabled = false
                //添加定时器
                self?.timer = Timer.scheduledTimer(timeInterval: 1, target: self!, selector: #selector(self?.timerChange(timer:)), userInfo: nil, repeats: true)
                self?.timer.fire()
            }
        }
    }
    
    // MARK:- 忘记密码中的 修改
    private func reset_forgetPsw() {
        
        var requestType: XHNetDataType = .forgetPsw
        
        if isPaymentPassword == true { // 忘记支付密码
            requestType = .forgetPassword_pay
        }else {
            requestType = .forgetPsw
        }
        
        let paraDict = ["phone" : phoneNumTF.text, "pwd": newPasswordTF.text, "code": verCodeTF.text] as! [String: String]
        
        showHud(in: view, hint: "发送中...", yOffset: 0)
        _ = XHRequest.shareInstance.requestNetData(dataType: requestType, parameters: paraDict, failure: { [weak self] (errorType) in
            self?.hideHud()
            var title: String?
            switch errorType {
            case .timeOut:
                title = "网络请求超时，请重新请求~"
            default:
                title = "网络请求错误，请重新请求~"
            }
            self?.showHint(in: (self?.view)!, hint: title!)
        }) { [weak self] (sth) in
            self?.hideHud()
            
            XHAlertController.showAlertSigleAction(title: nil, message: sth as? String, confirmTitle: "确定", confirmComplete: nil)
            
            let time: TimeInterval = 1.0
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
                self?.navigationController?.popViewController(animated: true)
            }
        }
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
        if XHRegularManager.isCalidateMobileNumber(num: phoneNumTF.text!) == false {
            showHint(in: view, hint: "手机号码输入有误，请重新输入")
            return false
        }
        
        if isPaymentPassword == true {
            if NSString(string: newPasswordTF.text!).length < 6 {
                showHint(in: view, hint: "密码输入有误，请重新输入~")
                return false
            }
        }else {
            if !XHRegularManager.isValidPassword(psw: newPasswordTF.text!) {
                showHint(in: view, hint: "密码输入有误，请重新输入~")
                return false
            }
        }
        
        if verCodeTF.text?.isEmpty == true {
            showHint(in: view, hint: "验证码不能为空~")
            return false
        }
        
        return true
    }
    
    private lazy var alertView: XHJudgeImageAlertView = Bundle.main.loadNibNamed("XHJudgeImageAlertView", owner: nil, options: nil)?.first as! XHJudgeImageAlertView
}
