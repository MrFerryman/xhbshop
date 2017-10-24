//
//  XHCollectionDetailCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/4.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHCollectionDetailCell: UITableViewCell {

    @IBOutlet weak var iconView: UIImageView!
    
    @IBOutlet weak var nameL: UILabel!
    
    @IBOutlet weak var priceL: UILabel!
    
    @IBOutlet weak var returnL: UILabel!
    
    var goodsModel: XHCollection_goodsModel? {
        didSet {
            if goodsModel?.icon != nil {
                let url = URL(string: XHImageBaseURL + (goodsModel?.icon)!)
                iconView.sd_setImage(with: url, placeholderImage: UIImage(named: "loding_icon"))
            }
            
            nameL.text = goodsModel?.title
            if goodsModel?.price != nil {
                priceL.text = "￥" + (goodsModel?.price)!
            }
            
            returnL.attributedText = returnL.richLableWithRedImage(" " + "\((goodsModel?.xhb)!)", fontSize: 12)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        returnL.attributedText = returnL.richLableWithRedImage(" 2.28", fontSize: 12)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
