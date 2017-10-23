//
//  XHFukuanStyleHeaderView.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/14.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHFukuanStyleHeaderView: UIView {

    var totalPrice: String? {
        didSet {
            if totalPrice != nil {
                totalProceL.text = totalPrice
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(iconView)
        iconView.clipsToBounds = true
        addSubview(titleL)
        addSubview(totalProceL)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleL.snp.makeConstraints { (make) in
            make.top.equalTo(15)
            make.centerX.equalTo(self).offset(6)
        }
        
        iconView.snp.makeConstraints { (make) in
            make.centerY.equalTo(titleL)
            make.right.equalTo(titleL.snp.left).offset(-6)
        }
        
        totalProceL.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(titleL.snp.bottom).offset(8)
        }
    }

    // MARK:- ======= 懒加载 ========
    /// 图标
    private lazy var iconView: UIImageView = UIImageView(image: UIImage(named: "order_detail_wait"))
    /// 文字
    private lazy var titleL: UILabel = {
       let label = UILabel()
        label.text = "待付款"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    /// 总额
    private lazy var totalProceL: UILabel = {
        let label = UILabel()
        label.text = "需支付：￥0"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
}
