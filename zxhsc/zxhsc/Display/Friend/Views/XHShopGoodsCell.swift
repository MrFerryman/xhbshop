//
//  XHShopGoodsCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/3.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHShopGoodsCell: UITableViewCell {

    @IBOutlet weak var goodsIconView: UIImageView!
    
    @IBOutlet weak var nameL: UILabel!
    
    @IBOutlet weak var brandImgView: UIImageView!
    
    @IBOutlet weak var stockL: UILabel!
    
    @IBOutlet weak var priceL: UILabel!
    
    @IBOutlet weak var backL: UILabel!
    
    @IBOutlet weak var branchWidthCon: NSLayoutConstraint!
    
    @IBOutlet weak var stockLeftCon: NSLayoutConstraint!
    
    var goodsModel: XHGoodsListModel? {
        didSet {
            if goodsModel?.icon != nil {
                goodsIconView.sd_setImage(with: URL(string: XHImageBaseURL + (goodsModel?.icon)!), placeholderImage: UIImage(named: XHPlaceholdImage))
            }
            
            nameL.text = goodsModel?.title
            
            if goodsModel?.stock != nil {
                stockL.text = "库存：" + (goodsModel?.stock)!
            }
            
            var bei: CGFloat = 1
            
            if goodsModel?.price != nil {
                priceL.text = "￥" + (goodsModel?.price)!
                
                let xhbF = (goodsModel?.xhb)!
                let priceF = ((goodsModel?.price)! as NSString).floatValue
                bei = CGFloat(xhbF) / CGFloat(priceF) * 100.0
            }
            
            if goodsModel?.xhb != nil {
                
                backL.attributedText = backL.richLableWithRedImage(" \(String(describing: (goodsModel?.xhb)!))(\(String(format: "%.1f", bei))倍)", fontSize: 12, imgName: "shop_yuanbao")
            }
        }
    }
    
    var shopModel: XHShopDetailModel? {
        didSet {
            if shopModel?.shopStyle == "品牌店" {
                branchWidthCon.constant = 28
                stockLeftCon.constant = 10
            }else {
                branchWidthCon.constant = 0
                stockLeftCon.constant = 0
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        backL.attributedText = backL.richLableWithRedImage(" 3.00(5倍)", fontSize: 12, imgName: "shop_yuanbao")
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
