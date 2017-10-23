//
//  XHShopSettingCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/10.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHShopSettingCell: UITableViewCell {

    @IBOutlet weak var titleL: UILabel!
    
    @IBOutlet weak var subTitleL: UILabel!
    
    var shopSettingModel: XHShopSettingDetailModel? {
        didSet {
            titleL.text = shopSettingModel?.title
            subTitleL.text = shopSettingModel?.subTitle
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
