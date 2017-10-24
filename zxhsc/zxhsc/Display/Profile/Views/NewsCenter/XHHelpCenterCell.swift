//
//  XHHelpCenterCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/7/30.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHHelpCenterCell: UITableViewCell {

    @IBOutlet weak var titleL: UILabel!
    
    @IBOutlet weak var dateL: UILabel!
    
    @IBOutlet weak var subTitleL: UILabel!
    
    var helpModel: XHHelpModel? {
        didSet {
            titleL.text = helpModel?.title
            dateL.text = helpModel?.time
            subTitleL.text = helpModel?.content
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
