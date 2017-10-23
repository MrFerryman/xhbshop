//
//  XHHomeLoopView.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/10/11.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHHomeLoopView: UIView {
    
    /// 数据数组
    var dataArr: [String]? = [] {
        didSet {
            if dataArr?.count != 0 {
                loopView.textColor = .white
                loopView.textFont = UIFont.systemFont(ofSize: 14)
                loopView.textDataArr = dataArr
                loopView.startScrollBottomToTop()
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = XHRgbaColorFromHex(rgb: 0x000000, alpha: 0.4)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// MARK:- 设置界面
    private func setupUI() {
        addSubview(speakerView)
        speakerView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(16)
            make.width.equalTo(12)
            make.height.equalTo(10)
        }
        
        addSubview(loopView)
        loopView.snp.makeConstraints { (make) in
            make.top.right.bottom.equalTo(self)
            make.left.equalTo(speakerView.snp.right).offset(16)
            make.right.equalTo(-16)
        }
    }
    
    // MARK:- 懒加载
    /// 喇叭
    private lazy var speakerView: UIImageView = UIImageView(image: UIImage(named: "home_speaker"))
    
    /// 跑马灯视图
    private lazy var loopView: LMJScrollTextView2 = LMJScrollTextView2(frame: CGRect(x: 0, y: 0, width: kUIScreenWidth - 74, height: 25))
}
