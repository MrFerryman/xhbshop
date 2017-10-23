//
//  XHProfileUnloginHeaderView.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/7/25.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHProfileUnloginHeaderView: UIView {

    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var loginBtn: UIButton!
    
    var loginOrRegisterButtonClickClosure: (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // 头像切圆角
        imgView.layer.cornerRadius = 30
        imgView.layer.masksToBounds = true
        
        loginBtn.layoutButtonTitleImageEdge(style: .styleLeft, titleImageSpace: 3)
    }
    
    @IBAction func loginOrRegisterButtonClicked(_ sender: UIButton) {
        loginOrRegisterButtonClickClosure?()
    }
}
