//
//  XHCycleDetailCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/7/26.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHCycleDetailCell: UITableViewCell {

    @IBOutlet weak var titleL: UILabel!
    @IBOutlet weak var detailL: UILabel!
    
    @IBOutlet weak var timeL: UILabel!
    
    
    var cycleModel: XHCycleModel? {
        didSet {
            titleL.text = cycleModel?.product
            detailL.text = (cycleModel?.symbol)! + (cycleModel?.xhb_count)!
            timeL.text = cycleModel?.time
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        
        detailL.text = "+100.0000"
        titleL.text = "15311800527推荐商家"
        timeL.text = "2017-07-26 15:15:06"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
