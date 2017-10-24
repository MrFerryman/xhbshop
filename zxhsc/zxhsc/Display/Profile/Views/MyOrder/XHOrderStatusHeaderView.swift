//
//  XHOrderStatusHeaderView.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/7.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHOrderStatusHeaderView: UIView {

    var orderStatus: OrderType = .obligation {
        didSet {
            setupUI()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgView)
        bgView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(iconView)
        addSubview(titleL)
        
        switch orderStatus {
        case .obligation: // 待付款
            addSubview(timeL)
            iconView.image = UIImage(named: "order_detail_wait")
            iconView.snp.remakeConstraints({ (make) in
                make.left.equalTo(16)
                make.top.equalTo(18)
                make.width.equalTo(12)
                make.height.equalTo(14)
            })
            
            titleL.text = "等待买家付款"
            titleL.snp.remakeConstraints({ (make) in
                make.centerY.equalTo(iconView)
                make.left.equalTo(iconView.snp.right).offset(10)
            })
            
            timeL.text = "24小时内未付款，订单自动取消"
            timeL.snp.remakeConstraints({ (make) in
                make.left.equalTo(titleL)
                make.top.equalTo(titleL.snp.bottom)
            })
            
        case .shipments: // 待发货
            addSubview(timeL)
            iconView.image = UIImage(named: "order_detail_wait")
            iconView.snp.remakeConstraints({ (make) in
                make.left.equalTo(16)
                make.top.equalTo(18)
                make.width.equalTo(12)
                make.height.equalTo(14)
            })
            
            titleL.text = "等待卖家发货"
            titleL.snp.remakeConstraints({ (make) in
                make.centerY.equalTo(iconView)
                make.left.equalTo(iconView.snp.right).offset(10)
            })
            
            timeL.text = "卖家将尽快为您发货，敬请耐心等待..."
            timeL.snp.remakeConstraints({ (make) in
                make.left.equalTo(titleL)
                make.top.equalTo(titleL.snp.bottom)
            })
        case .shipped: // 已发货
            addSubview(timeL)
            iconView.image = UIImage(named: "order_detail_deliver")
            iconView.snp.remakeConstraints({ (make) in
                make.left.equalTo(16)
                make.top.equalTo(18)
                make.width.equalTo(18)
                make.height.equalTo(14)
            })
            
            titleL.text = "卖家已发货"
            titleL.snp.remakeConstraints({ (make) in
                make.centerY.equalTo(iconView)
                make.left.equalTo(iconView.snp.right).offset(10)
            })
            
            timeL.text = "自发货之日起15天后，将自动确认收货"
            timeL.snp.remakeConstraints({ (make) in
                make.left.equalTo(titleL)
                make.top.equalTo(titleL.snp.bottom)
            })

        case .finished: // 已完成
            timeL.removeFromSuperview()
            iconView.image = UIImage(named: "order_detail_complete")
            iconView.snp.remakeConstraints({ (make) in
                make.left.equalTo(16)
                make.width.height.equalTo(16)
                make.centerY.equalTo(self)
            })
            
            titleL.text = "交易完成"
            titleL.snp.remakeConstraints({ (make) in
                make.centerY.equalTo(self)
                make.left.equalTo(iconView.snp.right).offset(6)
            })
        default:
            timeL.removeFromSuperview()
            iconView.image = UIImage(named: "order_detail_cancel")
            iconView.snp.remakeConstraints({ (make) in
                make.left.equalTo(16)
                make.width.height.equalTo(16)
                make.centerY.equalTo(self)
            })
            
            titleL.text = "交易取消"
            titleL.snp.remakeConstraints({ (make) in
                make.centerY.equalTo(self)
                make.left.equalTo(iconView.snp.right).offset(6)
            })
        }
    }

    /// MARK:- ====== 懒加载 =========
    private lazy var bgView: UIImageView = UIImageView(image: UIImage(named: "order_detail_bg"))
    
    /// 图标
    private lazy var iconView: UIImageView = UIImageView(image: UIImage(named: "order_detail_wait"))
    
    /// 标题
    private lazy var titleL: UILabel = {
       let label = UILabel()
        label.textColor = .white
        label.text = "等待买家付款"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    /// 时间
    private lazy var timeL: UILabel = {
       let label = UILabel()
        label.textColor = .white
        label.text = "剩余14天23小时59分钟自动确认"
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()
}
