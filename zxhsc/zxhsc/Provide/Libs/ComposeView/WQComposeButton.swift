//
//  WQComposeButton.swift
//  封装好用的方法
//
//  Created by 清风依旧醉春风 on 2017/4/10.
//  Copyright © 2017年 moviewisdom. All rights reserved.
//

import UIKit

class WQComposeButton: UIView {

    // 第一步 -- 重写构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 第二步 -- 定义一个方法,来实现 视图的添加和布局
    fileprivate func setupUI(){
        imgView.adjustsImageWhenHighlighted = false
        imgView.isEnabled = false
       addSubview(imgView)
        addSubview(titleL)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
       imgView.snp.makeConstraints { (make) in
           make.centerX.equalTo(self)
           make.top.equalTo(self)
           make.width.height.equalTo(46)
        }
        
        titleL.snp.makeConstraints { (make) in
            make.top.equalTo(imgView.snp.bottom).offset(8)
            make.centerX.equalTo(self)
        }
    }
    
    // 第三步: 懒加载控件
    // 图片
    lazy var imgView: UIButton = UIButton()
    
    // 标题
    lazy var titleL: UILabel = {
       let label = UILabel()
        label.textColor = XHRgbColorFromHex(rgb: 0x333333)
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
}
