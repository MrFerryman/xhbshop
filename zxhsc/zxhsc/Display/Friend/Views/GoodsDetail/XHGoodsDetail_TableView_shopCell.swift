//
//  XHGoodsDetail_TableView_shopCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/4.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHGoodsDetail_TableView_shopCell: UITableViewCell {
    
    
    @IBOutlet weak var iconView: UIImageView!
    
    @IBOutlet weak var titleL: UILabel!
    
    @IBOutlet weak var countL: UILabel!
    
    @IBOutlet weak var phoneNumL: UILabel!
    
    var shopModel: XHBussinessShopModel? {
        didSet {
            if shopModel?.icon != nil {
                iconView.sd_setImage(with: URL(string: XHImageBaseURL + (shopModel?.icon)!), placeholderImage: UIImage(named: XHPlaceholdImage))
            }
            
            titleL.text = shopModel?.name
            
            if shopModel?.productNum != nil {
                countL.text = String(describing: (shopModel?.productNum)!)
            }
            
            if shopModel?.telephone != nil {
                phoneNumL.text = "电话：" + (shopModel?.telephone)!
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
