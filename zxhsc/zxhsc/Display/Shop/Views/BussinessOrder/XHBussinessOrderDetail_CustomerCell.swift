//
//  XHBussinessOrderDetail_CustomerCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/11.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHBussinessOrderDetail_CustomerCell: UITableViewCell {

    @IBOutlet weak var customerL: UILabel! //消费者账号
    
    @IBOutlet weak var returnL: UILabel! // 循环宝
    
    var orderModel: XHMyShopOrderDetailModel? {
        didSet {
            customerL.text = orderModel?.user
            
            if orderModel?.xhb != nil {
                returnL.text = "\((orderModel?.xhb)!)"
            }
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
