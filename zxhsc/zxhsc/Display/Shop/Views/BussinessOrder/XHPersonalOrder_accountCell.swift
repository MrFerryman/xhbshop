//
//  XHPersonalOrder_accountCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/14.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHPersonalOrder_accountCell: UITableViewCell {

    @IBOutlet weak var accountL: UILabel! // 用户账号
    
    @IBOutlet weak var returnL: UILabel! // 循环宝
    
    var orderModel: XHMyOrderModel? {
        didSet {
            accountL.text = orderModel?.userAccount
            
            if orderModel?.totalXhb != nil {
                returnL.text = "\((orderModel?.totalXhb)!)"
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
