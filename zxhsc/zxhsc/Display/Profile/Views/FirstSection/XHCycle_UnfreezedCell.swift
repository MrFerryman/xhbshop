//
//  XHCycle_UnfreezedCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/9/21.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHCycle_UnfreezedCell: UITableViewCell {

    @IBOutlet weak var titleL: UILabel!
    
    @IBOutlet weak var accountL: UILabel!
    
    @IBOutlet weak var comeL: UILabel!
    
    @IBOutlet weak var timeL: UILabel!
    
    var unfreezedModel: XHUnfreezedDetailModel? {
        didSet {
            titleL.text = unfreezedModel?.content
            accountL.text = unfreezedModel?.account
            if unfreezedModel?.xhb != nil {
                comeL.text = "\((unfreezedModel?.xhb)!)"
            }
            timeL.text = unfreezedModel?.time
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
