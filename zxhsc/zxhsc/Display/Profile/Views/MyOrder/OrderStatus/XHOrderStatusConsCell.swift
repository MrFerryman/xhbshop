//
//  XHOrderStatusConsCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/7.
//  Copyright © 2017年 zxhsc. All rights reserved.
// 收货人信息

import UIKit

class XHOrderStatusConsCell: UITableViewCell {

    @IBOutlet weak var titleL: UILabel!
    
    @IBOutlet weak var phoneNumL: UILabel!
    
    @IBOutlet weak var detaiAddressL: UILabel!
    
    var orderModel: XHMyOrderModel? {
        didSet {
            if orderModel?.addressee != nil {
                titleL.text = "收货人：" + (orderModel?.addressee)!
            }
            
            phoneNumL.text = orderModel?.phoneNum
            
            if orderModel?.address_city != nil, orderModel?.address_detail != nil {
                detaiAddressL.text = (orderModel?.address_city)! + " " + (orderModel?.address_detail)!
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
