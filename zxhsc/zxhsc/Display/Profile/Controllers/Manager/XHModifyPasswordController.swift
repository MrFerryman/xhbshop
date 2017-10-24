//
//  XHModifyPasswordController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/7/26.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHModifyPasswordController: UIViewController {

    @IBOutlet weak var oldPasswordTF: UITextField!
    
    @IBOutlet weak var newPasswordTF: UITextField!
    
    @IBOutlet weak var confirmPasswordTF: UITextField!
    
    fileprivate var viewName = ""
    /// 是不是登录密码
    var isLoginPassword: Bool = true {
        didSet {
            viewName = isLoginPassword == true ? "修改登录密码页面" : "修改支付密码界面"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TalkingData.trackPageBegin(viewName)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        TalkingData.trackPageEnd(viewName)
    }
    
    private func uploadData() {
        
        var requestType: XHNetDataType = .modifyPassword_login
        
        if isLoginPassword == true {
            requestType = .modifyPassword_login
        }else {
            requestType = .modifyPassword_pay
        }
        
        let paraDict = ["oldpwd": oldPasswordTF.text!, "newpwd": newPasswordTF.text!, "surepwd": confirmPasswordTF.text!]
        showHud(in: view, hint: "提交中...", yOffset: 0)
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
            let time: TimeInterval = 0.5
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }

    @IBAction func confirmButtonClicked(_ sender: UIButton) {
        if isValid() == true {
            
            uploadData()
        }
    }
    
    private func isValid() -> Bool {
        
        if oldPasswordTF.text?.isEmpty == true {
            showHint(in: view, hint: "请输入旧密码~")
            return false
        }
        
        if isLoginPassword == false {
            if NSString(string: newPasswordTF.text!).length < 6 {
                showHint(in: view, hint: "新密码输入有误，请重新输入~")
                return false
            }
        }else {
            if !XHRegularManager.isValidPassword(psw: newPasswordTF.text!) {
                showHint(in: view, hint: "新密码输入有误，请重新输入~")
                return false
            }
        }
        
        if newPasswordTF.text != confirmPasswordTF.text {
            showAlert()
            return false
        }
        
        return true
    }
    
    private func showAlert() {
        let alertC = UIAlertController(title: title, message: "两次新密码设置不一致，请重新输入~", preferredStyle: .alert)
        
            let confirmA = UIAlertAction(title: "确定", style: .default, handler: nil)
            alertC.addAction(confirmA)
        self.present(alertC, animated: true, completion: nil)
    }

}
