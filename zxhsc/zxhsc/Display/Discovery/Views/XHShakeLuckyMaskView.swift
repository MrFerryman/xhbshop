
//
//  XHShakeLuckyMaskView.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/9/19.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHShakeLuckyMaskView: UIView {

    @IBOutlet weak var bottomCon: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if kUIScreenWidth == 320 {
            bottomCon.constant = 95
        }else if KUIScreenHeight == 812 {
            bottomCon.constant = 145
        }
    }
    
    
    @IBAction func getRulesBtnClicked(_ sender: UIButton) {
        self.removeFromSuperview()
    }
}
