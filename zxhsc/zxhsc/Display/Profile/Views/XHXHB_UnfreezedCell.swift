//
//  XHXHB_UnfreezedCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/9/21.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHXHB_UnfreezedCell: UITableViewCell {

    @IBOutlet weak var countL: UILabel!
    
    @IBOutlet weak var todayFontL: UILabel!
    
    @IBOutlet weak var today_unfreezedL: UILabel!
    
    var unfreezedModel: XHXHB_UnfreezedModel? {
        didSet {
            if unfreezedModel?.total_freezed != nil {
                countL.text = "\((unfreezedModel?.total_freezed)!)"
            }
            
            if unfreezedModel?.today_freezed != nil, unfreezedModel?.today_freezed != 0 {
                todayFontL.isHidden = false
                today_unfreezedL.isHidden = false
                today_unfreezedL.text = "\((unfreezedModel?.today_freezed)!)"
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        today_unfreezedL.isHidden = true
        todayFontL.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
