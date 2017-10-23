//
//  XHShopSettingImageCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/10.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHShopSettingImageCell: UITableViewCell {

    @IBOutlet weak var titleL: UILabel!
    
    @IBOutlet weak var iconView: UIImageView!
    
    
    var shopSettingModel: XHShopSettingDetailModel? {
        didSet {
            titleL.text = shopSettingModel?.title
            if shopSettingModel?.iconUrlStr != nil {
                iconView.sd_setImage(with: URL(string: XHImageBaseURL + (shopSettingModel?.iconUrlStr)!), placeholderImage: UIImage(named: XHPlaceholdImage), options: .progressiveDownload)
            }else {
                iconView.image = UIImage(named: "loding_icon")
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
