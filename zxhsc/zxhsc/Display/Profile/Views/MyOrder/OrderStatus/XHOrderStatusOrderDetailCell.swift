//
//  XHOrderStatusOrderDetailCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/7.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHOrderStatusOrderDetailCell: UITableViewCell {

    @IBOutlet weak var orderNumberL: UILabel! // 订单编号
    @IBOutlet weak var orderTimeL: UILabel! // 下单时间
    
    @IBOutlet weak var orderStatusL: UILabel! // 订单状态
    
    @IBOutlet weak var sendTimeL: UILabel! // 发货时间
    
    @IBOutlet weak var getTimeL: UILabel! // 收货时间
    
    var orderModel: XHMyOrderModel? {
        didSet {
            orderNumberL.text = orderModel?.orderNum
            orderTimeL.text = orderModel?.time
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
