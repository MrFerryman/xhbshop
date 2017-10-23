//
//  XHWithdrawalController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/7/27.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHWithdrawalController: UIViewController {

    @IBOutlet weak var accountL: UILabel!
    
    @IBOutlet weak var moneyTF: UITextField!
    
    @IBOutlet weak var withDrawalL: UILabel!
    
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet weak var explainL: UILabel!
    
    @IBOutlet weak var commitBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userModel = NSKeyedUnarchiver.unarchiveObject(withFile:userAccountPath) as? XHUserModel
        accountL.text = userModel?.account
        loadBalance()
        getBalanceExplain()
        commitBtn.layer.cornerRadius = 8
        commitBtn.layer.masksToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- 获取可提现余额
    private func loadBalance() {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        _ = XHRequest.shareInstance.requestNetData(dataType: .getWithdraw_Balance, failure: { [weak self] (errorType) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self?.loadBalance()
        }) { [weak self] (sth) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self?.withDrawalL.text = "\(sth)"
        }
    }
    
    // MARK:- 提现申请
    private func applyForWithdraw() {
        
        let paraDict = ["money": moneyTF.text!, "pwd": passwordTF.text!]
        showHud(in: view, hint: "提交中...", yOffset: 0)
        _ = XHRequest.shareInstance.requestNetData(dataType: .applyForWithdraw, parameters: paraDict, failure: { [weak self] (errorType) in
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
            let str = sth as! String
            XHAlertController.showAlertSigleAction(title: nil, message: sth as? String, confirmTitle: "确定", confirmComplete: {
                if str == "请先认证信息" {
                    let authenID = XHAuthenIdentiferController()
                    self?.navigationController?.pushViewController(authenID, animated: true)
                }
            })
        }
    }
    
    // MARK:- 获取提现说明
    private func getBalanceExplain() {
        let paraDict = ["helpid": "41"]
        _ = XHRequest.shareInstance.requestNetData(dataType: .helpDetail, parameters: paraDict, failure: { [weak self] (errorType) in
            self?.getBalanceExplain()
        }, success: { [weak self] (sth) in
            let model = sth as! XHHTMLModel
            self?.explainL.text = model.alternate_fields1
        })
    }
    

    @IBAction func conformButtonClicked(_ sender: UIButton) {
        
        if judge() == true {
            applyForWithdraw()
        }
        
    }
    
    private func judge() -> Bool {
        
        if (moneyTF.text?.isEmpty)! == true || Int(moneyTF.text!)! % 100 != 0 {
            showHint(in: view, hint: "提现金额输入有误，请重新输入")
            moneyTF.becomeFirstResponder()
            return false
        }
        
        if Int(moneyTF.text!)! > Int(withDrawalL.text!)! {
            showHint(in: view, hint: "提现金额不能大于可提现金额")
            moneyTF.becomeFirstResponder()
            return false
        }
        
        if NSString(string: passwordTF.text!).length < 6 {
            showHint(in: view, hint: "支付密码输入有误，请重新输入")
            passwordTF.becomeFirstResponder()
            return false
        }
        
        return true
    }
    
}
