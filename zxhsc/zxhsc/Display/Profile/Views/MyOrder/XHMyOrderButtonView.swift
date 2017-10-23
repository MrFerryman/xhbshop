//
//  XHMyOrderButtonView.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/7.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHMyOrderButtonView: UIView {

    var cellType: OrderType = .obligation {
        didSet {
            setupUI()
        }
    }
    
    /// 按钮点击回调
    var buttonClickedClosure: ((_ sender: UIButton) -> ())?
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        setupUI()
//    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- ======= 事件相关 ======
    // MARK:-  按钮点击事件
    @objc private func buttonClicked(_ sender: UIButton) {
        buttonClickedClosure?(sender)
    }
    
    // MARK:- ====== 界面相关 =======
    private func setupUI() {
        
        addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(self)
            make.height.equalTo(1)
        }
        
        switch cellType {
        case .obligation: // 待付款
            addSubview(cancelBtn)
            addSubview(goToFukuanBtn)

            deleteBtn.removeFromSuperview()
            checkBtn.removeFromSuperview()
            confirmBtn.removeFromSuperview()
            salesReturnBtn.removeFromSuperview()
            goToFukuanBtn.snp.makeConstraints({ (make) in
                make.centerY.equalTo(self)
                make.right.equalTo(-16)
                make.width.equalTo(70)
                make.height.equalTo(30)
            })
            cancelBtn.snp.makeConstraints({ (make) in
                make.centerY.equalTo(self)
                make.width.equalTo(70)
                make.height.equalTo(30)
                make.right.equalTo(goToFukuanBtn.snp.left).offset(-12)
            })
        case .shipped: // 已发货
            addSubview(checkBtn)
            addSubview(confirmBtn)
            addSubview(salesReturnBtn)

            deleteBtn.removeFromSuperview()
            goToFukuanBtn.removeFromSuperview()
            cancelBtn.removeFromSuperview()
            confirmBtn.snp.makeConstraints({ (make) in
                make.centerY.equalTo(self)
                make.right.equalTo(-16)
                make.width.equalTo(70)
                make.height.equalTo(30)
            })
            
            checkBtn.snp.makeConstraints({ (make) in
                make.centerY.equalTo(self)
                make.width.equalTo(70)
                make.height.equalTo(30)
                make.right.equalTo(confirmBtn.snp.left).offset(-12)
            })
            
            salesReturnBtn.snp.makeConstraints({ (make) in
                make.centerY.equalTo(self)
                make.right.equalTo(checkBtn.snp.left).offset(-12)
                make.width.equalTo(70)
                make.height.equalTo(30)
            })
            
        case .finished, .canceled: // 已完成
            addSubview(deleteBtn)

            checkBtn.removeFromSuperview()
            goToFukuanBtn.removeFromSuperview()
            cancelBtn.removeFromSuperview()
            confirmBtn.removeFromSuperview()
            salesReturnBtn.removeFromSuperview()
            deleteBtn.snp.makeConstraints({ (make) in
                make.centerY.equalTo(self)
                make.right.equalTo(-16)
                make.width.equalTo(70)
                make.height.equalTo(30)
            })
        case .shipments: // 待发货
            checkBtn.removeFromSuperview()
            goToFukuanBtn.removeFromSuperview()
            cancelBtn.removeFromSuperview()
            confirmBtn.removeFromSuperview()
            deleteBtn.removeFromSuperview()
            addSubview(salesReturnBtn)
            salesReturnBtn.snp.makeConstraints({ (make) in
                make.centerY.equalTo(self)
                make.width.equalTo(70)
                make.height.equalTo(30)
                make.right.equalTo(-16)
            })
        default:
            break
        }
    }
    
    // MARK:- ====== 懒加载 =======
    /// 取消订单按钮
    private lazy var cancelBtn: UIButton = {
       let btn = UIButton(type: .custom)
        btn.setTitle("取消订单", for: .normal)
        btn.adjustsImageWhenHighlighted = false
        btn.tag = 1001
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.setTitleColor(XHRgbColorFromHex(rgb: 0x777777), for: .normal)
        btn.setBackgroundImage(UIImage(named: "order_cancelBtn_bg"), for: .normal)
        btn.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        return btn
    }()
    
    /// 去付款
    private lazy var goToFukuanBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("去付款", for: .normal)
        btn.adjustsImageWhenHighlighted = false
        btn.tag = 1002
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.setTitleColor(XHRgbColorFromHex(rgb: 0xea2000), for: .normal)
        btn.setBackgroundImage(UIImage(named: "order_redButton"), for: .normal)
        btn.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        return btn
    }()
    
    /// 删除订单
    private lazy var deleteBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("删除订单", for: .normal)
        btn.adjustsImageWhenHighlighted = false
        btn.tag = 1003
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.setTitleColor(XHRgbColorFromHex(rgb: 0x777777), for: .normal)
        btn.setBackgroundImage(UIImage(named: "order_cancelBtn_bg"), for: .normal)
        btn.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        return btn
    }()

    /// 查看物流
    private lazy var checkBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("查看物流", for: .normal)
        btn.adjustsImageWhenHighlighted = false
        btn.tag = 1004
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.setTitleColor(XHRgbColorFromHex(rgb: 0x777777), for: .normal)
        btn.setBackgroundImage(UIImage(named: "order_cancelBtn_bg"), for: .normal)
        btn.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        return btn
    }()
    
    /// 确认收货
    private lazy var confirmBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("确认收货", for: .normal)
        btn.adjustsImageWhenHighlighted = false
        btn.tag = 1005
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.setTitleColor(XHRgbColorFromHex(rgb: 0xea2000), for: .normal)
        btn.setBackgroundImage(UIImage(named: "order_redButton"), for: .normal)
        btn.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        return btn
    }()
    
    /// 申请退货
    private lazy var salesReturnBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("申请退货", for: .normal)
        btn.adjustsImageWhenHighlighted = false
        btn.tag = 1006
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.setTitleColor(XHRgbColorFromHex(rgb: 0x777777), for: .normal)
        btn.setBackgroundImage(UIImage(named: "order_cancelBtn_bg"), for: .normal)
        btn.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var line: UIView = {
       let view = UIView()
        view.backgroundColor = XHRgbColorFromHex(rgb: 0xf4f6f7)
        return view
    }()
}
