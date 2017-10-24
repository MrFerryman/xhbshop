//
//  XHIntegralCollectionCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/9/6.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHIntegralCollectionCell: UICollectionViewCell {

    @IBOutlet weak var iconView: UIImageView!
    
    @IBOutlet weak var nameL: UILabel!
    
    @IBOutlet weak var integralL: UILabel!
    
    @IBOutlet weak var priceL: UILabel!
    
    @IBOutlet weak var heightCon: NSLayoutConstraint!
    
    var integralModel: XHIntegralGoodsModel? {
        didSet {
            
            if integralModel?.icon != nil {
                iconView.sd_setImage(with: URL(string: XHImageBaseURL + (integralModel?.icon)!), placeholderImage: UIImage(named: XHPlaceholdImage), options: .progressiveDownload)
            }
            
            nameL.text = integralModel?.title
            
            if integralModel?.integral != nil {
                 let integral = NSString(string: (integralModel?.integral)!).floatValue
                integralL.text = String(format: "%.2f", integral)
            }
            
            
            if integralModel?.price != nil {
                let price_f = NSString(string: (integralModel?.price)!).floatValue
                if price_f == 0.0 {
                    priceL.text = ""
                }else {
                    priceL.text = "+￥" + String(format: "%.2f", price_f)
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        heightCon.constant = (kUIScreenWidth - 12 * 2 - 7) / 2
        priceL.layer.cornerRadius = 3
        priceL.layer.masksToBounds = true
    }

}
