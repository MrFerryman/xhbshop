//
//  XHDiscoveryIntegralCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/9/18.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHDiscoveryIntegralCell: UITableViewCell {

    @IBOutlet weak var iconView: UIImageView!
    
    @IBOutlet weak var titleL: UILabel!
    
    @IBOutlet weak var xhbL: UILabel!
    
    @IBOutlet weak var moneyL: UILabel!
    
    var goodsModel: XHDiscoveryGoodsModel? {
        didSet {
            if goodsModel?.icon != nil {
                iconView.sd_setImage(with: URL(string: XHImageBaseURL + (goodsModel?.icon)!), placeholderImage: UIImage(named: XHPlaceholdImage), options: .progressiveDownload)
            }
            
            titleL.text = goodsModel?.title
            
            if goodsModel?.gift != nil {
                xhbL.text = (goodsModel?.gift)! + "积分(循环宝)"
            }
            
            if goodsModel?.price != nil {
                let price = NSString(string: (goodsModel?.price)!).floatValue
                if price != 0.0 {
                    moneyL.isHidden = false
                    moneyL.text = "+￥" + (goodsModel?.price)!
                }else {
                    moneyL.isHidden = true
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        moneyL.isHidden = true
        selectionStyle = .none
        moneyL.layer.cornerRadius = 4
        moneyL.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
