//
//  XHXHPersonalOrder_footerView.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/14.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHXHPersonalOrder_footerView: UIView {

    /// 确认退货按钮点击事件回调
    var confirmReturnButtonClickedClosure: (() -> ())?
    /// 联系买家按钮点击事件回调
    var connectUserButtonClickedClosure: (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- 事件相关
    // MARK:-  确认退货按钮点击事件
    @objc private func confirmReturnButtonClicked() {
        confirmReturnButtonClickedClosure?()
    }
    
    // MARK:- 联系用户按钮点击事件
    @objc private func connectUserButtonClicked() {
        connectUserButtonClickedClosure?()
    }

    
    // MARK:- ========== 界面相关 ==========
    private func setupUI() {
        addSubview(confirmReturnBtn)
//        addSubview(connectUserBtn)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        confirmReturnBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.right.equalTo(-8)
            make.width.equalTo(70)
            make.height.equalTo(30)
        }
        
//        connectUserBtn.snp.makeConstraints { (make) in
//            make.centerY.equalTo(self)
//            make.right.equalTo(confirmReturnBtn.snp.left).offset(-12)
//            make.width.equalTo(70)
//            make.height.equalTo(30)
//        }
    }
    
  
    // MARK:- ======= 懒加载 =========
    // 确认退货
    private lazy var confirmReturnBtn: UIButton = {
       let btn = UIButton(type: .custom)
        btn.setTitle("查看物流", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.setTitleColor(XHRgbColorFromHex(rgb: 0xea2000), for: .normal)
        btn.setBackgroundImage(UIImage(named: "order_redButton"), for: .normal)
        btn.addTarget(self, action: #selector(confirmReturnButtonClicked), for: .touchUpInside)
        return btn
    }()
    
    // 联系用户
    private lazy var connectUserBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("联系用户", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.setTitleColor(XHRgbColorFromHex(rgb: 0x777777), for: .normal)
        btn.setBackgroundImage(UIImage(named: "order_cancelBtn_bg"), for: .normal)
        btn.addTarget(self, action: #selector(connectUserButtonClicked), for: .touchUpInside)
        return btn
    }()
}
