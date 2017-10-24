//
//  XHOrderStatusLogiCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/7.
//  Copyright © 2017年 zxhsc. All rights reserved.
//  物流信息

import UIKit

class XHOrderStatusLogiCell: UITableViewCell {

    @IBOutlet weak var titleL: UILabel!
    
    @IBOutlet weak var timeL: UILabel!
    
    var orderModel: XHMyOrderModel? {
        didSet {
            
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
