//
//  XHXHB_FreezedCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/9/21.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHXHB_FreezedCell: UITableViewCell {

    @IBOutlet weak var countL: UILabel!
    
    var earningModel: XHUserEarningModel? {
        didSet {
            if earningModel?.xhb_freezed != nil {
                countL.text = "\((earningModel?.xhb_freezed)!)"
            }
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
