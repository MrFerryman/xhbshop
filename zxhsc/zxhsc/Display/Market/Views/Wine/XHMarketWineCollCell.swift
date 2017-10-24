//
//  XHMarketWineCollCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/7/19.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHMarketWineCollCell: UICollectionViewCell {

    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var titleL: UILabel!
    
    @IBOutlet weak var priceL: UILabel!
    
    @IBOutlet weak var rebackL: UILabel!
    
    var goodsModel: XHSpecialFavModel? {
        didSet {
            if goodsModel?.icon != nil {
                imgView.sd_setImage(with: URL(string: XHImageBaseURL + (goodsModel?.icon)!), placeholderImage: UIImage(named: XHPlaceholdImage), options: .progressiveDownload)
            }
            
            titleL.text = goodsModel?.title
            
            if goodsModel?.price != nil {
                priceL.text = "￥" + (goodsModel?.price)!
            }
            
            if goodsModel?.xhbStr != nil {
                rebackL.attributedText = XHRichLabel().richLableWithRedImage(" \((goodsModel?.xhbStr)!)", fontSize: 11)
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .white
        
    }
}
