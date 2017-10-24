//
//  XHBussinessOrderCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/11.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHBussinessOrderCell: UITableViewCell {

    @IBOutlet weak var orderNumL: UILabel! // 订单编号
    
    @IBOutlet weak var statusL: UILabel! // 订单状态
    
    @IBOutlet weak var orderTimeL: UILabel! // 订单时间
    
    @IBOutlet weak var returnL: UILabel! // 让利比
    
    @IBOutlet weak var customerNumL: UILabel! // 消费者账号
    
    @IBOutlet weak var moneyL: UILabel! // 订单金额
    
    @IBOutlet weak var orderIdL: UILabel! // 订单识别号
    
    @IBOutlet weak var paymentBtn: UIButton!
    
    @IBOutlet weak var cancelBtn: UIButton!
    
    /// 取消按钮点击事件回调
    var cancelOrderButtonClickedClosure: ((_ orderModel: XHMyShopOrderModel) -> ())?
    /// 去付款按钮点击事件回调
    var goToPayButtonClickedClosure: ((_ orderModel: XHMyShopOrderModel) -> ())?
    
    var orderModel: XHMyShopOrderModel? {
        didSet {
            if orderModel?.order_number != nil {
                orderNumL.text = "订单编号: " + (orderModel?.order_number)!
            }
            
            switch (orderModel?.status  ?? 0) {
            case 1:
                statusL.text = "待付款"
                paymentBtn.isHidden = false
                cancelBtn.isHidden = false
            case 2:
                statusL.text = "已完成"
                paymentBtn.isHidden = true
                cancelBtn.isHidden = true

            case 3:
                statusL.text = "已取消"
                paymentBtn.isHidden = true
                cancelBtn.isHidden = true

            default:
                break
            }
            
            if orderModel?.time != nil {
                orderTimeL.text = "订单时间: " + (orderModel?.time)!
            }
            
            if orderModel?.scale != nil {
                returnL.text = "让利比例: \((orderModel?.scale)!)%"
            }
            
            if orderModel?.userNum != nil {
                customerNumL.text = "消费者账号: " + (orderModel?.userNum)!
            }
            
            moneyL.text = "￥\((orderModel?.totalPrice)!)"
            
            if orderModel?.order_Id != nil {
                orderIdL.text = "订单识别码:" + "【" + (orderModel?.order_Id)! + "】"
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // MARK:- 取消订单按钮点击事件
    @IBAction func cancelOrderButtonClicked(_ sender: UIButton) {
        cancelOrderButtonClickedClosure?(orderModel!)
    }
    
    
    // MARK:- 去付款按钮点击事件
    @IBAction func goToPayment(_ sender: UIButton) {
        goToPayButtonClickedClosure?(orderModel!)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
