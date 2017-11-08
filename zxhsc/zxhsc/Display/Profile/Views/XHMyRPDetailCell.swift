//
//  XHMyRPDetailCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/10/23.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHMyRPDetailCell: UITableViewCell {

    @IBOutlet weak var accountL: UILabel!
    
    @IBOutlet weak var timeL: UILabel!
    
    @IBOutlet weak var moneyL: UILabel!
    
    @IBOutlet weak var xhbL: UILabel!
    
    var redModel: XHRedPacketModel? {
        didSet {
            
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
