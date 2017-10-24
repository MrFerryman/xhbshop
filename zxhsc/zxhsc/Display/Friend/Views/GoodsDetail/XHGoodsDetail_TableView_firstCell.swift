//
//  XHGoodsDetail_TableView_firstCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/4.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHGoodsDetail_TableView_firstCell: UITableViewCell {

    @IBOutlet weak var productNameL: UILabel!
    @IBOutlet weak var priceL: UILabel!
    @IBOutlet weak var returnL: UILabel!
    @IBOutlet weak var brandImgView: UIImageView!
    
    @IBOutlet weak var integralPriceL: UILabel!
    
    
    var isIntegralGoods: Bool = false {
        didSet {
            integralPriceL.isHidden = !isIntegralGoods
        }
    }
    
    var detailModel: XHGoodsListModel? {
        didSet {
            productNameL.text = detailModel?.title
            
            var bei: CGFloat = 1
            
            if detailModel?.price != nil {
                priceL.text = "￥" + (detailModel?.price)!
                
                let xhbF = CGFloat((detailModel?.xhb)!)
                let priceF = ((detailModel?.price)! as NSString).floatValue
                bei = xhbF / CGFloat(priceF) * 100.0
            }
            
            if detailModel?.xhb != nil {
                returnL.attributedText = returnL.richLableWithRedImage(" \(String(describing: (detailModel?.xhb)!))(\(String(format: "%.1f", bei))倍)", fontSize: 10, imgName: "shop_yuanbao")
            }
            
            if isIntegralGoods == true {
                integralPriceL.isHidden = false
                if detailModel?.integral != nil {
                    priceL.text = "积分(循环宝):" + "\((detailModel?.integral)!)"
                }else {
                    priceL.text = "积分(循环宝):"
                }
                
                if detailModel?.price != nil {
                    let price = NSString(string: (detailModel?.price)!).floatValue
                    if price == 0.0 {
                        integralPriceL.text = ""
                    }else {
                        integralPriceL.text = "+￥" + "\(price)"
                    }
                }
                returnL.text = ""
            }
        }
    }
    
    var bussinessShop: XHBussinessShopModel? {
        didSet {
            if bussinessShop?.isBranch == "1" {
                brandImgView.isHidden = false
            }else {
                brandImgView.isHidden = true
            }
        }
    }
        
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        integralPriceL.layer.cornerRadius = 3
        integralPriceL.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
