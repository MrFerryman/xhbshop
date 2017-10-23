//
//  XHOrderStatusOrderDetail_obligationCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/8.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHOrderStatusOrderDetail_obligationCell: UITableViewCell {
    /// 订单编号
    @IBOutlet weak var orderCodeL: UILabel!
    /// 下单时间
    @IBOutlet weak var orderTimeL: UILabel!
    
    var orderModel: XHMyOrderModel? {
        didSet {
            orderCodeL.text = orderModel?.orderNum
            orderTimeL.text = orderModel?.time
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
