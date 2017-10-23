//
//  XHHomeSellCollCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/7/16.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHHomeSellCollCell: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!

    @IBOutlet weak var titleL: UILabel!
    
    
    @IBOutlet weak var priceL: UILabel!
    
    @IBOutlet weak var incomL: UILabel!
    
    @IBOutlet weak var imgHeightCon: NSLayoutConstraint!
    
    @IBOutlet weak var imgWidth: NSLayoutConstraint!
    
    var goodsModel: XHSpecialFavModel? {
        didSet {
            if goodsModel?.icon != nil {
                imgView.sd_setImage(with: URL(string: XHImageBaseURL + (goodsModel?.icon)!), placeholderImage: UIImage(named: XHPlaceholdImage), options: .progressiveDownload)
            }
           
            titleL.text = goodsModel?.title
            
            priceL.attributedText = priceL.stringWithTwoSize("￥\(String(describing: (goodsModel?.price)!))", 15, 12)
            
             incomL.attributedText = XHRichLabel(frame: CGRect.zero).richLableWithImage(" \(String(describing: (goodsModel?.xhb)!))", fontSize: 12)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        incomL.layer.cornerRadius = 2
        incomL.clipsToBounds = true
        
        imgWidth.constant = (kUIScreenWidth - 3 * 10) / 2
        imgHeightCon.constant = imgWidth.constant
    }

}
