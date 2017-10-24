//
//  XHSpecialFavCollCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/24.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHSpecialFavCollCell: UICollectionViewCell {

    @IBOutlet weak var iconView: UIImageView!
    
    @IBOutlet weak var titleL: UILabel!
    
    @IBOutlet weak var xhbL: UILabel!
    
    @IBOutlet weak var timesL: UILabel!
    
    @IBOutlet weak var priceL: UILabel!
    
    var specialModel: XHSpecialFavModel? {
        didSet {
            if specialModel?.icon != nil {
                iconView.sd_setImage(with: URL(string: XHImageBaseURL + (specialModel?.icon)!), placeholderImage: UIImage(named: XHPlaceholdImage), options: .progressiveDownload)
            }
            
            titleL.text = specialModel?.title
            
            xhbL.attributedText = XHRichLabel(frame: CGRect.zero).richLableWithImage(" \(String(describing: (specialModel?.xhb)!))", fontSize: 10, isShowColor: false)
            
            timesL.text = String(describing: (specialModel?.times)!) + "倍"
            
            if specialModel?.price != nil {
                priceL.text = "￥" + (specialModel?.price)!
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
