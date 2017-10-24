//
//  XHLoginController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/7/14.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHLoginController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var topViewHeight: NSLayoutConstraint!

    @IBOutlet weak var topHidenView: UIView! // 头部可隐藏视图
    
    @IBOutlet weak var bottomMoveView: UIView! // 下面可移动视图
    
    @IBOutlet weak var appIconView: UIImageView! // 图标图片视图
    
    @IBOutlet weak var appNameL: UIView! // app名称
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var phoneNumberTF: UITextField!
    
    @IBOutlet weak var secretCodeTF: UITextField!
    
    // 返回按钮点击 或 登录成功之后的回调
    var successLoginClosure: (() -> ())?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.cornerRadius = 6
        loginButton.layer.masksToBounds = true
        
        phoneNumberTF.addTarget(self, action: #selector(phoneNumberTFBeginEdit(sender:)), for: .editingDidBegin)
        secretCodeTF.addTarget(self, action: #selector(secutyCodeTFBeginEdit(sender:)), for: .editingDidBegin)
        
        phoneNumberTF.delegate = self
        
        //点击空白处收回键盘 注册点击事件
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:))))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNav()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == phoneNumberTF {
            if NSString(string: string).length == 0 {  return true }
            let existedLength = NSString(string: textField.text!).length
            let selectedLength = range.length
            let replaceLength = NSString(string: string).length
            if existedLength - selectedLength + replaceLength > 11 {
                return false
            }
        }
        return true
    }
    
    fileprivate func setChildViewControllerNav() {
        UIApplication.shared.statusBarStyle = .default
        
        tabBarController?.tabBar.isHidden = true
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : XHRgbColorFromHex(rgb: 0x333333)]
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.tintColor = XHRgbColorFromHex(rgb: 0x333333)
    }
    
    // MARK:- 点击空白处收回键盘 实现方法
    @objc func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            phoneNumberTF.resignFirstResponder()
            secretCodeTF.resignFirstResponder()
        }
        sender.cancelsTouchesInView = false
    }

    // MARK:- 登录按钮点击事件
    @IBAction func login(_ sender: UIButton) {
        phoneNumberTF.resignFirstResponder()
        secretCodeTF.resignFirstResponder()
        if judgeData() {
           
            showHud(in: view)
            let paraDict: [String: String] = ["user": phoneNumberTF.text!, "pwd": secretCodeTF.text!]
            _ = XHRequest.shareInstance.requestNetData(dataType: .login, parameters: paraDict, failure: { [weak self] (errorType) in
                self?.hideHud()
                var title: String?
                switch errorType {
                case .timeOut:
                    title = "网络请求超时，请重新请求~"
                default:
                    title = "网络请求错误，请重新请求~"
                }
                self?.showHint(in: (self?.view)!, hint: title!)
            }, success: { [weak self] (userModel) in
                self?.hideHud()
                
                if userModel is XHUserModel {
                    let model = userModel as! XHUserModel
                    if model.loginStatus == .success {
                        self?.showHint(in: (self?.view)!, hint: "登录成功~")
                        TalkingData.onLogin(self?.phoneNumberTF.text, type: TDAccountType.type1, name: nil)
                        let time: TimeInterval = 1.0
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
                            //code
                            self?.navigationController?.popViewController(animated: true)
                            self?.dismiss(animated: true, completion: nil)
                            self?.successLoginClosure?()
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
                    }else {
                        self?.showHint(in: (self?.view)!, hint: "用户名或密码输入有误，请重新操作~")
                        self?.phoneNumberTF.becomeFirstResponder()
                    }
                }else {
                    let str = userModel as! String
                    self?.showHint(in: (self?.view)!, hint: str)
                }
                
            })
        }
    }
    
    // MARK:- 返回按钮点击事件
    @objc private func backButtonClick() {
        phoneNumberTF.resignFirstResponder()
        secretCodeTF.resignFirstResponder()
        dismiss(animated: true, completion: { [weak self] in
            self?.successLoginClosure?()
        })
    }
    
    // MARK:- 注册按钮点击事件
    @objc private func registerButtonItemClick() {
        let register = XHRegisterProtocolController()
        setChildViewControllerNav()
        navigationController?.pushViewController(register, animated: true)
    }
    
    // MARK:- 查看密码按钮点击事件
    @IBAction func seeCodeButtonClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            secretCodeTF.isSecureTextEntry = false
        }else {
            secretCodeTF.isSecureTextEntry = true
        }
    }
    
    // MARK:- 忘记密码按钮点击事件
    @IBAction func forgetPasswordButtonClicked(_ sender: UIButton) {
        let forgetVc = XHForgetPasswordController()
        forgetVc.isPaymentPassword = false
        forgetVc.title = "重置密码"
        navigationController?.pushViewController(forgetVc, animated: true)
    }
    
    
    // MARK:- 监听事件
    // 账号 输入框
    @objc private func phoneNumberTFBeginEdit(sender: UITextField) {
        if topViewHeight.constant != 0 {
            animateTopView()
        }
        
    }
    
    // 密码 输入框
    @objc private func secutyCodeTFBeginEdit(sender: UITextField) {
        if topViewHeight.constant != 0 {
            animateTopView()
        }
        
    }

    
    // 做动画
    private func animateTopView() {
        UIView.animate(withDuration: 0.5, animations: { 
            self.topHidenView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
            self.topHidenView.alpha = 0
            self.title = "循环宝商城登录"
            self.bottomMoveView.frame = CGRect(x: 0, y: 44, width: kUIScreenWidth, height: 200)
        }) { (isFinish) in
            self.topViewHeight.constant = 0
        }
    }
    
    
    // MARK:- 判断逻辑
    //判断数据是否正确
    private func judgeData() -> Bool{
        
        if !XHRegularManager.isCalidateMobileNumber(num: (phoneNumberTF.text)!) {
            self.showHint(in: view, hint: "请输入正确的手机号")
            return false
        }
        if (secretCodeTF.text! as NSString).length < 6 ||  (secretCodeTF.text! as NSString).length > 20{
            self.showHint(in: view, hint: "请输入6-20位密码")
            return false
        }
        return true
    }

    
    private func setupNav() {
        
        let item = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem = item
        
        UIApplication.shared.statusBarStyle = .default

        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()

        // 退出按钮
        let backItem = UIBarButtonItem(image: UIImage(named: "Profile_login_close"), style: .plain, target: self, action: #selector(backButtonClick))
        navigationItem.leftBarButtonItem = backItem
        
        // 注册按钮
        let registerItem = UIBarButtonItem(title: "注册", style: .plain, target: self, action: #selector(registerButtonItemClick))
        navigationItem.rightBarButtonItem = registerItem
        
        navigationController?.navigationBar.tintColor = XHRgbColorFromHex(rgb: 0x333333)
    }

}
