//
//  XHSettingPayPswController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/17.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHSettingPayPswController: UIViewController {

    @IBOutlet weak var topCon: NSLayoutConstraint!
    
    @IBOutlet weak var payTF: UITextField! // 支付密码
    
    @IBOutlet weak var confirmTF: UITextField!  // 确认密码
    
    @IBOutlet weak var commitButton: UIButton! // 提交按钮
    
    fileprivate let viewName = "首次设置支付密码页面"
    
    var isResigter: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        commitButton.layer.cornerRadius = 6
        commitButton.layer.masksToBounds = true
        
        setupNav()
        
        if KUIScreenHeight == 812 {
            topCon.constant = 90
        }else {
            topCon.constant = 64
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
    
    // MARK:- 提交按钮点击事件
    @IBAction func commitButtonClicked(_ sender: UIButton) {
        if judge() == true {
            commitData()
        }
    }
    
    // MARK:- 提交数据
    private func commitData() {
        
        let paraDict = ["zhifupass": payTF.text] as! [String: String]
        showHud(in: view, hint: "提交中...", yOffset: 0)
        _ = XHRequest.shareInstance.requestNetData(dataType: .setPayPsw, parameters: paraDict, failure: { [weak self] (errorType) in
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
            self?.showHint(in: (self?.view)!, hint: str)
            if str == "操作成功" {
                let time: TimeInterval = 1.0
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
                    self?.payTF.resignFirstResponder()
                    self?.confirmTF.resignFirstResponder()
                    if self?.isResigter == false {
                        self?.dismiss(animated: true, completion: nil)
                    }else {
                        self?.navigationController?.childViewControllers[0].dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }

    private func judge() -> Bool {
        if (payTF.text?.lengthOfBytes(using: String.Encoding.utf8))! < 6 ||  (confirmTF.text?.lengthOfBytes(using: String.Encoding.utf8))! < 6 {
            showHint(in: view, hint: "密码设置有误，请重新输入~")
            return false
        }
        
        if payTF.text != confirmTF.text {
            showHint(in: view, hint: "两次密码设置不一致，请重新输入~")
            return false
        }
        
        return true
    }
    
    private func setupNav() {
        title = "设置支付密码"
        navigationItem.hidesBackButton = true
    }
}
