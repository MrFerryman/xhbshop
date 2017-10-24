//
//  XHProfileHeaderView.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/7/13.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHProfileHeaderView: UIView {
    
    @IBOutlet weak var clickView: UIView!
    
    @IBOutlet weak var qrcodeView: UIView!
    
    @IBOutlet weak var headerIconImgView: UIImageView!
    
    @IBOutlet weak var titleL: UILabel!
    
    @IBOutlet weak var phoneL: UILabel!
    @IBOutlet weak var deadlineL: UILabel!
    
    /// 用户信息部分手势事件
    var cinfigViewTapGestureClosure: (() -> ())?
    
    /// 二维码部分按钮点击事件回调
    var qrCodeButtonClickClosure: (() -> ())?
    
    /// 用户模型
    var userModel: XHUserModel? {
        didSet {
            if userModel?.iconName != nil {
                 headerIconImgView.sd_setImage(with: URL(string: XHImageBaseURL + (userModel?.iconName)!), placeholderImage: UIImage(named: "profile_headerImg_icon"))
            }
           
            titleL.text = userModel?.nickname
            phoneL.text = userModel?.account
            deadlineL.text = userModel?.userLevel == "" ? "循环使者" : (userModel?.userLevel)!
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // 头像切圆角
        headerIconImgView.layer.cornerRadius = 30
        headerIconImgView.layer.masksToBounds = true
        
        // 给用户信息部分界面添加手势
        let tap = UITapGestureRecognizer(target: self, action: #selector(configViewClick))
        
        clickView.addGestureRecognizer(tap)
        
        // 给二维码部分界面添加手势
        let qrTap = UITapGestureRecognizer(target: self, action: #selector(qrCodeButtonClicked(_:)))
        
        qrcodeView.addGestureRecognizer(qrTap)
    }
    
    // MARK:- 用户信息部分手势事件
    @objc private func configViewClick() {
        cinfigViewTapGestureClosure?()
    }
    
    // MARK:- 二维码部分点击事件
    @objc private func qrCodeButtonClicked(_ sender: UIButton) {
        qrCodeButtonClickClosure?()
    }
}
