//
//  XHClassifyCollCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/7/20.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHClassifyCollCell: UICollectionViewCell {

    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var titleL: UILabel!
    
    var recomModel: XHClassifyRecommendModel? {
        didSet {
            if recomModel?.icon != nil {
                imgView.sd_setImage(with: URL(string: XHImageBaseURL + (recomModel?.icon)!), placeholderImage: UIImage(named: XHPlaceholdImage), options: .progressiveDownload)
            }
            
            titleL.text = recomModel?.title
        }
    }
    
    var hotModel: XHClassifyHotModel? {
        didSet {
            if hotModel?.icon != nil {
                imgView.sd_setImage(with: URL(string: XHImageBaseURL + (hotModel?.icon)!), placeholderImage: UIImage(named: XHPlaceholdImage), options: .progressiveDownload)
            }
            
            titleL.text = hotModel?.title
        }
    }
    
    var childModel: XHClassifyChildModel? {
        didSet {
            if childModel?.icon != nil {
                imgView.sd_setImage(with: URL(string: XHImageBaseURL + (childModel?.icon)!), placeholderImage: UIImage(named: XHPlaceholdImage), options: .progressiveDownload)
            }
            
            titleL.text = childModel?.title
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
