//
//  XHIntegralPayFooterView.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/10/10.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHIntegralPayFooterView: UIView {

    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet weak var payButton: UIButton!
    
    var integralButtonClickedClosure: ((_ textFeile: UITextField) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        payButton.layer.cornerRadius = 6
        payButton.layer.masksToBounds = true
    }
    
    
    @IBAction func integralButtonClicked(_ sender: UIButton) {
        integralButtonClickedClosure?(passwordTF)
    }
    
}
