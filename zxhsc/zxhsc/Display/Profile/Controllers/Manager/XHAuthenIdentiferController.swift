//
//  XHAuthenIdentiferController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/7/30.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHAuthenIdentiferController: UIViewController {
    
    
    @IBOutlet weak var nameTF: UITextField!

    @IBOutlet weak var idenNumTF: UITextField!
    
    @IBOutlet weak var nextBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nextBtn.layer.cornerRadius = 6
        nextBtn.layer.masksToBounds = true
        
        setupNav()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func nextButtonClicked(_ sender: UIButton) {
        if judge() == true {
            let bankV = XHAuthenBankController()
            let myBankM = XHMyBankModel()
            myBankM.name = nameTF.text
            myBankM.idCardNum = idenNumTF.text
            bankV.bankModel = myBankM
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
