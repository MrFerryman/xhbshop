//
//  XHAuthenIdentiferController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/7/30.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHAuthenIdentiferController: UIViewController {
    
    @IBOutlet weak var topCon: NSLayoutConstraint!
    
    @IBOutlet weak var nameTF: UITextField!

    @IBOutlet weak var idenNumTF: UITextField!
    
    @IBOutlet weak var nextBtn: UIButton!
    
    var myBankModel: XHMyBankModel?
    
    fileprivate let viewName = "认证设置_设置个人信息页面"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nextBtn.layer.cornerRadius = 6
        nextBtn.layer.masksToBounds = true
        
        nameTF.text = myBankModel?.name
        idenNumTF.text = myBankModel?.idCardNum
        
        setupNav()
        if KUIScreenHeight == 812 {
            topCon.constant = 90
        }else {
            topCon.constant = 64
        }
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
    
    @IBAction func nextButtonClicked(_ sender: UIButton) {
        if judge() == true {
            let bankV = XHAuthenBankController()
//            let myBankM = XHMyBankModel()
            myBankModel = myBankModel == nil ? XHMyBankModel() : myBankModel
            myBankModel?.name = nameTF.text
            myBankModel?.idCardNum = idenNumTF.text
            bankV.bankModel = myBankModel
            navigationController?.pushViewController(bankV, animated: true)
        }
    }
    
    private func judge() -> Bool {
        if nameTF.text?.isEmpty == true {
            showHint(in: view, hint: "持卡人姓名不能为空")
            return false
        }
        
        if XHRegularManager.isIdentifer(str: idenNumTF.text!) == false {
            showHint(in: view, hint: "身份证输入有误，请重新输入")
            return false
        }
        
        return true
    }
    
    private func setupNav() {
        title = "身份认证"
        let item = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem = item
    }
}
