//
//  XHDiscoveryMaskView.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/10/10.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHDiscoveryMaskView: UIView {

    /// 现在开始抽奖按钮点击事件回调
    var nowStartButtonClickedClosure: (() -> Void)?
    /// 关闭按钮点击事件回调
    var closeButtonClickedClosure: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
    @IBAction func nowStartButtonClicked(_ sender: UIButton) {
        nowStartButtonClickedClosure?()
    }
    
    @IBAction func closeButtonClicked(_ sender: UIButton) {
        closeButtonClickedClosure?()
    }
    
}
