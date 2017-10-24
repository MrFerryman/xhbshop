//
//  XHSettingDetailConfController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/7/30.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHSettingDetailConfController: UIViewController {

    @IBOutlet weak var textField: UITextField! // 文本输入框
    
    @IBOutlet weak var saveButton: UIButton! // 保存按钮
    
    fileprivate let viewName = "个人中心_设置个人资料页面"
    
    var comeFromType: configType = .nickname
    
    var userModel: XHMemberDetailModel?
    
    /// 数据保存之后的回调
    var savedButtonClickedClosure: ((_ memberMode: XHMemberDetailModel) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupBesicUI()
        
        switch comeFromType {
        case .idNumber:
            textField.text = userModel?.idCardNum
        case .name:
            textField.text = userModel?.name
        case .nickname:
            textField.text = userModel?.nickname
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


    @IBAction func saveButtonClicked(_ sender: UIButton) {
        if judge() == true {
            
            switch comeFromType {
            case .idNumber: // 身份证
                userModel?.idCardNum = textField.text!
            case .name: // 姓名
                userModel?.name = textField.text!
            case .nickname: // 昵称
                userModel?.nickname = textField.text!
            }
            showHint(in: view, hint: "保存成功")
            
            let time: TimeInterval = 0.5
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) { [weak self] in
                self?.savedButtonClickedClosure?((self?.userModel)!)
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    private func judge() -> Bool {
        switch comeFromType {
        case .nickname:
            if XHRegularManager.validateNickname(nickname: textField.text!) == false {
                showHint(in: view, hint: "昵称设置不正确，请重新输入~")
                textField.becomeFirstResponder()
                return false
            }
        case .name:
            if textField.text?.isEmpty == true {
                showHint(in: view, hint: "姓名不能为空，请重新输入~")
                textField.becomeFirstResponder()
                return false
            }
        case .idNumber:
            if XHRegularManager.isIdentifer(str: textField.text!) == false {
                showHint(in: view, hint: "身份证号码不正确，请重新输入~")
                textField.becomeFirstResponder()
                return false
            }
        }
        
        return true
    }
    
    private func setupBesicUI() {
        saveButton.layer.cornerRadius = 6
        saveButton.layer.masksToBounds = true
        
        switch comeFromType {
        case .nickname:
            title = "修改昵称"
            textField.placeholder = "请输入您的昵称"
        case .name:
            title = "修改姓名"
            textField.placeholder = "请输入您的姓名"
        case .idNumber:
            title = "修改身份证号码"
            textField.keyboardType = .numberPad
            textField.placeholder = "请输入您的身份证号码"
        }
    }
}
