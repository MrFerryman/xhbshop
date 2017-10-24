//
//  XHShopSettingDetailController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/10.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHShopSettingDetailController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var alertView: UIImageView!
    
    @IBOutlet weak var attentionL: UILabel!
    
    /// 保存按钮回调
    var saveButtonClickedClosure: (() -> ())?
    
    var shopSettingModel: XHShopSettingDetailModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = shopSettingModel?.title
        
        saveButton.layer.cornerRadius = 6
        saveButton.layer.masksToBounds = true
        textField.placeholder = "请输入" + (shopSettingModel?.title)!
        alertView.alpha = 0
        attentionL.alpha = 0
        if shopSettingModel?.subTitle != "请设置" {
            textField.text = shopSettingModel?.subTitle
        }
        
        if shopSettingModel?.title == "让利比例" {
            alertView.alpha = 1
            attentionL.alpha = 1
            textField.keyboardType = .decimalPad
        }else if shopSettingModel?.title == "店铺电话" {
            textField.keyboardType = .numberPad
        }
        
        //点击空白处收回键盘 注册点击事件
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:))))
    }

    // MARK:- 点击空白处收回键盘 实现方法
    @objc func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            textField.resignFirstResponder()
        }
        sender.cancelsTouchesInView = false
    }
   
    @IBAction func saveButtonClicked(_ sender: UIButton) {
        
        if judge() == false {
            return
        }
        shopSettingModel?.subTitle = textField.text
        saveButtonClickedClosure?()
        showHint(in: view, hint: "保存成功~")
        let time: TimeInterval = 1.0
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
            //code
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK:- 逻辑判断
    private func judge() -> Bool {
        if textField.text?.isEmpty == true {
            showHint(in: view, hint: "设置内容不能为空~")
            return false
        }
        
        if shopSettingModel?.title == "让利比例" {
            let count: CGFloat = StringToFloat(str: textField.text!)
            if count < 0.05 || count > 1 {
                showHint(in: view, hint: "输入参数有误，请重新输入~")
                return false
            }
        }
        if shopSettingModel?.title == "店铺电话" {
            if XHRegularManager.isCalidateMobileNumber(num: textField.text!) == false {
                showHint(in: view, hint: "电话号码输入有误，请重新输入~")
                return false
            }
        }
        
        return true
    }
}
