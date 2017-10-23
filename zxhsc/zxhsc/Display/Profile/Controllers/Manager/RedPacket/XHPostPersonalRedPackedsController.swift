//
//  XHPostPersonalRedPackedsController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/10/20.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHPostPersonalRedPackedsController: UIViewController {

    @IBOutlet weak var moneyTF: UITextField!
    
    
    @IBOutlet weak var countView: UIView!
    
    @IBOutlet weak var countTF: UITextField!
    
    @IBOutlet weak var putInButton: UIButton!
    
    /// 是否是个人红包
    var isPersonalRedPacketes: Bool = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if isPersonalRedPacketes == true {
            countView.isHidden = true
        }else {
            countView.isHidden = false
        }
        
        putInButton.layer.cornerRadius = 6
        putInButton.layer.masksToBounds = true
        setupNav()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- 按钮点击事件
    @IBAction func putInMoneyButtonClicked(_ sender: UIButton) {
        
    }
    
    

    private func setupNav() {
        title = "发红包"
    }

}
