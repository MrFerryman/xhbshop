//
//  XHPersonalOrder_orderDetailCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/14.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHPersonalOrder_orderDetailCell: UITableViewCell {

    @IBOutlet weak var orderNumL: UILabel! // 订单编号
    
    @IBOutlet weak var orderTimeL: UILabel!  // 下单时间
    
    @IBOutlet weak var productCountL: UILabel! // 商品数量
    
    @IBOutlet weak var totalPriceL: UILabel! // 订单总价
    
    @IBOutlet weak var orderStatusL: UILabel! // 订单状态
    
    @IBOutlet weak var sendTimeL: UILabel! // 发货时间
    
    @IBOutlet weak var getTimeL: UILabel! // 收货时间
    
    var orderModel: XHMyOrderModel? {
        didSet {
            orderNumL.text = orderModel?.orderNum
            
            orderTimeL.text = orderModel?.time
            
            productCountL.text = orderModel?.number ?? "0"
            
            if orderModel?.price != nil, orderModel?.number != nil {
                let price = NSString(string: (orderModel?.price)!).floatValue
                let number = NSString(string: (orderModel?.number)!).floatValue
                let totalPrice = price * number
                totalPriceL.text = "\(totalPrice)"
            }
            
            orderStatusL.text = orderModel?.status
            
            sendTimeL.text = orderModel?.sendTime
            
            getTimeL.text = orderModel?.getTime
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
