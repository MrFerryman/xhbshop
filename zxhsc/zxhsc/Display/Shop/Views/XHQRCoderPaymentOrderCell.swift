//
//  XHQRCoderPaymentOrderCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/9/12.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHQRCoderPaymentOrderCell: UITableViewCell {

    @IBOutlet weak var totalPirceL: UILabel!
    
    @IBOutlet weak var timeL: UILabel!
    
    @IBOutlet weak var numberL: UILabel!
    
    var orderModel: XHPaymentOrderDetailModel? {
        didSet {
            if orderModel?.price != nil, orderModel?.price != 0.0 {
                totalPirceL.text = "￥" + "\((orderModel?.price)!)"
            }else {
                totalPirceL.text = "￥" + (orderModel?.priceStr ?? "0")
            }
            
           
            timeL.text = orderModel?.time
            
            numberL.text = orderModel?.orderNumber
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
