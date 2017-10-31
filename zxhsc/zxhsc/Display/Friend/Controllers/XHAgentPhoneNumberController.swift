//
//  XHAgentPhoneNumberController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/10/30.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHAgentPhoneNumberController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var maskView: UIView!
    
    @IBOutlet weak var phoneNumTF: UITextField!
    
    @IBOutlet weak var nicknameL: UILabel!
    
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    /// 取消按钮点击事件回调
    var cancelButtonClickedClosure: (() -> ())?
    /// 确认按钮点击事件回调
    var confirmButtonClickedClosure: ((_ phoneNumber: String) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        maskView.layer.cornerRadius = 6
        maskView.layer.masksToBounds = true
        nicknameL.text = ""
        phoneNumTF.delegate = self
        activityView.isHidden = true
        phoneNumTF.addTarget(self, action: #selector(textFieldDidEditingChanged(_:)), for: .editingChanged)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @objc private func textFieldDidEditingChanged(_ textField: UITextField) {
        if NSString(string: textField.text!).length == 11 {
            textField.resignFirstResponder()
            getCustomerNickname()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == phoneNumTF {
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
    
    // MARK:- 获取消费者昵称
    private func getCustomerNickname() {
        let paraDict = ["muser": phoneNumTF.text!]
        activityView.isHidden = false
        XHMyShopViewModel.getCustomerDetail(paraDict, self) { [weak self] (result) in
            self?.activityView.isHidden = true
            if result is XHTempUserModel {
                self?.nicknameL.text = "代理商昵称: " + ((result as! XHTempUserModel).nickname)!
                self?.activityView.isHidden = false
                self?.nicknameL.alpha = 0
                self?.nicknameL.alpha = 1
                self?.activityView.isHidden = true
            }else {
                XHAlertController.showAlertSigleAction(title: "提示", message: "\(result as! String)", confirmTitle: "朕晓得了", confirmComplete: nil)
            }
        }
    }

    // MARK:-  确认按钮的点击事件
    @IBAction func confirmButtonClicked(_ sender: UIButton) {
        if XHRegularManager.isCalidateMobileNumber(num: phoneNumTF.text!) == false {
            showHint(in: view, hint: "请输入正确的代理商号码")
            return
        }
        
        confirmButtonClickedClosure?(phoneNumTF.text!)
    }
    
    // MARK:- 取消按钮的点击事件
    @IBAction func cancelButtonClicked(_ sender: UIButton) {
        cancelButtonClickedClosure?()
    }
    
}
