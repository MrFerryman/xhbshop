//
//  XHMyShop_OfflineCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/9/27.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHMyShop_OfflineCell: UITableViewCell {

    @IBOutlet weak var orderNumL: UILabel!
    
    @IBOutlet weak var timeL: UILabel!
    
    @IBOutlet weak var priceL: UILabel!
    
    @IBOutlet weak var customerL: UILabel!
    
    @IBOutlet weak var orderCodeL: UILabel!
    
    
    var orderModel: XHShopOfflineOrderModel? {
        didSet {
            orderNumL.text = orderModel?.orderNumber
            timeL.text = orderModel?.time
            priceL.text = "￥" + (orderModel?.price ?? "0")
            customerL.text = orderModel?.customer
            orderCodeL.text = "【" + (orderModel?.id ?? "") + "】"
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
