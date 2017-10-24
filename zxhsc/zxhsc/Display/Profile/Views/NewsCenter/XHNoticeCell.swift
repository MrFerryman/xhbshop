//
//  XHNoticeCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/7/31.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHNoticeCell: UITableViewCell {

    @IBOutlet weak var titleL: UILabel!
    
    @IBOutlet weak var dateL: UILabel!
    
    var announceModel: XHHelpModel? {
        didSet {
            titleL.text = announceModel?.title
            dateL.text = announceModel?.time
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
