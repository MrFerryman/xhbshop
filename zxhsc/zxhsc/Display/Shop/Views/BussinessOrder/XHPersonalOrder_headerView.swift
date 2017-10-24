//
//  XHPersonalOrder_headerView.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/14.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHPersonalOrder_headerView: UIView {
    
    var orderStatus: PersonalOrderStatus = .waitToFukuan {
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
    
    // MARK:- ======== 界面相关 =======
    private func setupUI() {
        switch orderStatus {
        case .waitToFukuan, .waitToSend: // 待付款 待发货
            addSubview(iconView)
            addSubview(titleL)
            addSubview(timeL)
            if orderStatus == .waitToFukuan {
                titleL.text = "等待买家付款"
                timeL.text = "剩余2天23小时59分钟，未付款订单自动取消"
            }else {
                titleL.text = "等待您的店铺发货"
                timeL.text = "剩余2天23小时59分钟，请尽快发货"
            }
            
            iconView.image = UIImage(named: "order_detail_wait")
            iconView.snp.remakeConstraints({ (make) in
                make.top.equalTo(18)
                make.left.equalTo(16)
                make.width.equalTo(12)
                make.height.equalTo(14)
            })
            
            titleL.snp.remakeConstraints({ (make) in
                make.centerY.equalTo(iconView)
                make.left.equalTo(iconView.snp.right).offset(10)
            })
            
            timeL.snp.remakeConstraints({ (make) in
                make.left.equalTo(titleL)
                make.top.equalTo(titleL.snp.bottom).offset(4)
            })
        case .waitToGet: // 等待买家收货
            timeL.removeFromSuperview()
            addSubview(iconView)
            iconView.image = UIImage(named: "order_detail_deliver")
            iconView.snp.remakeConstraints({ (make) in
                make.centerY.equalTo(self)
                make.left.equalTo(13)
                make.width.equalTo(18)
                make.height.equalTo(14)
            })
            
            titleL.text = "等待用户收货"
            addSubview(titleL)
            titleL.snp.remakeConstraints({ (make) in
                make.centerY.equalTo(iconView)
                make.left.equalTo(iconView.snp.right).offset(5)
            })
        case .waitToConfirmGet, .finished: // 等待买家确认收货 订单已完成
            timeL.removeFromSuperview()
            addSubview(iconView)
            iconView.image = UIImage(named: "order_detail_complete")
            iconView.snp.remakeConstraints({ (make) in
                make.centerY.equalTo(self)
                make.left.equalTo(16)
                make.width.height.equalTo(14)
            })
            
            titleL.text = orderStatus == .waitToConfirmGet ? "等待买家确认收货" : "订单已完成"
            addSubview(titleL)
            titleL.snp.remakeConstraints({ (make) in
                make.centerY.equalTo(iconView)
                make.left.equalTo(iconView.snp.right).offset(5)
            })
        case .canceled, .confirmReturn: // 订单已取消 确认退货
            timeL.removeFromSuperview()
            addSubview(iconView)
            iconView.image = UIImage(named: "order_detail_cancel")
            iconView.snp.remakeConstraints({ (make) in
                make.centerY.equalTo(self)
                make.left.equalTo(16)
            })
            titleL.text = orderStatus == .canceled ? "订单已取消" : "订单已确认退货"
            addSubview(titleL)
            titleL.snp.remakeConstraints({ (make) in
                make.centerY.equalTo(iconView)
                make.left.equalTo(iconView.snp.right).offset(5)
            })
            
        case .applyForReturn: // 申请退货
            addSubview(iconView)
            iconView.image = UIImage(named: "order_detail_tui")
            iconView.snp.remakeConstraints({ (make) in
                make.top.equalTo(19)
                make.left.equalTo(16)
            })
            titleL.text = "用户已申请退货"
            addSubview(titleL)
            titleL.snp.remakeConstraints({ (make) in
                make.centerY.equalTo(iconView)
                make.left.equalTo(iconView.snp.right).offset(5)
            })

            addSubview(timeL)
            timeL.text = "请处理退货申请，用户等待您的回复"
            timeL.snp.remakeConstraints({ (make) in
                make.left.equalTo(titleL)
                make.top.equalTo(titleL.snp.bottom).offset(4)
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
        label.text = "剩余2天23小时59分钟，未付款订单自动取消"
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()
}
