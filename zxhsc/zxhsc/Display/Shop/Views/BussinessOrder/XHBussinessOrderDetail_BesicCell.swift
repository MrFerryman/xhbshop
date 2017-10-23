//
//  XHBussinessOrderDetail_BesicCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/11.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHBussinessOrderDetail_BesicCell: UITableViewCell {

    @IBOutlet weak var orderNumL: UILabel! // 订单编号
    
    @IBOutlet weak var orderTimeL: UILabel! // 订单日期
    
    @IBOutlet weak var retrunL: UILabel! // 让利比
    
    @IBOutlet weak var orderMoneyL: UILabel! // 订单金额
    
    @IBOutlet weak var orderStatusL: UILabel! // 订单状态
    
    var orderModel: XHMyShopOrderDetailModel? {
        didSet {
            orderNumL.text = orderModel?.orderNumber
            orderTimeL.text = orderModel?.time
            if orderModel?.scale != nil {
                retrunL.text = "\((orderModel?.scale)!)%"
            }
            
            if orderModel?.totalPrice != nil, orderModel?.totalPrice != 0.0 {
                orderMoneyL.text = "\((orderModel?.totalPrice)!)"
            }else {
                orderMoneyL.text = orderModel?.money
            }
            
            orderStatusL.text = orderModel?.status
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
