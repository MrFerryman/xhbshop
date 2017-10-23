//
//  XHIntegralPay_ProInfoCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/10/10.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHIntegralPay_ProInfoCell: UITableViewCell {

    @IBOutlet weak var nameL: UILabel!
    
    @IBOutlet weak var priceL: UILabel!
    
    @IBOutlet weak var integralL: UILabel!
    
    @IBOutlet weak var timeL: UILabel!
    
    var detailModel: XHMyOrderModel? {
        didSet {
            nameL.text = detailModel?.title
            priceL.text = detailModel?.gift
            timeL.text = detailModel?.time
        }
    }
    
    var integralString: String? {
        didSet {
            integralL.text = integralString
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
