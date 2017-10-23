//
//  XHHome_Digital_collCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/15.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHHome_Digital_collCell: UICollectionViewCell {

    @IBOutlet weak var titleL: UILabel! // 标题
    
    @IBOutlet weak var iconView: UIImageView! // 图片
    
    @IBOutlet weak var subIconView: UIImageView!
    
    @IBOutlet weak var priceL: UILabel! // 价格
    
    @IBOutlet weak var iconViewHeightCon: NSLayoutConstraint!
    
    var goodsModel: XHSpecialFavModel? {
        didSet {
            titleL.text = goodsModel?.title
            
            if goodsModel?.icon != nil {
                iconView.sd_setImage(with: URL(string: XHImageBaseURL + (goodsModel?.icon)!), placeholderImage: UIImage(named: XHPlaceholdImage), options: .progressiveDownload)
            }
            
            if goodsModel?.price != nil {
                priceL.text = "￥" + (goodsModel?.price)!
            }
        }
    }
    
    var bannerModel: XHHomeBannerGoodsModel? {
        didSet {
            if bannerModel?.sub_img != nil {
                subIconView.sd_setImage(with: URL(string: XHImageBaseURL + (bannerModel?.sub_img)!), placeholderImage: UIImage(named: "home_digitil_price"), options: .progressiveDownload)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        contentView.backgroundColor = RandomColor()
         iconViewHeightCon.constant = 82 * kUIScreenWidth / 375
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        iconViewHeightCon.constant = 82 * kUIScreenWidth / 375
    }

}
