//
//  XHLogisticsDetailHeaderCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/9/6.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHLogisticsDetailHeaderCell: UITableViewCell {

    
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var numberL: UILabel!
    
    @IBOutlet weak var resourceL: UILabel!
    
    var orderModel: XHMyOrderModel? {
        didSet {
            if orderModel?.icon != nil {
                iconImageView.sd_setImage(with: URL(string: XHImageBaseURL + (orderModel?.icon)!), placeholderImage: UIImage(named: XHPlaceholdImage), options: .progressiveDownload)
            }
            
            numberL.text = orderModel?.orderNum
            
            resourceL.text = ""
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
