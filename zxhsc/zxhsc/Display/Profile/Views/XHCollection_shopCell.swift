//
//  XHCollection_shopCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/4.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import SDWebImage

class XHCollection_shopCell: UITableViewCell {

    @IBOutlet weak var iconView: UIImageView! // 店铺图片
    
    @IBOutlet weak var nameL: UILabel! // 店铺名称
    
    @IBOutlet weak var phoneNumL: UILabel! // 电话
    
    @IBOutlet weak var contentL: UILabel! // 主营
    
    
    var shopModel: XHCollection_shopModel? {
        didSet {
            if shopModel?.icon != nil {
                let url = URL(string: XHImageBaseURL + (shopModel?.icon)!)
                iconView.sd_setImage(with: url, placeholderImage: UIImage(named: "loding_icon"))
            }else {
                iconView.image = UIImage(named: "loding_icon")
            }
            
            nameL.text = shopModel?.name
            if shopModel?.phoneNum != nil {
                phoneNumL.text = "电话：" + (shopModel?.phoneNum)!
            }
            
            if shopModel?.main_buss != nil {
                contentL.text = "主营：" + (shopModel?.main_buss)!
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
