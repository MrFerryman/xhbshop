//
//  XHConfirmOrderCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/9.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHConfirmOrderCell: UITableViewCell {

    @IBOutlet weak var iconView: UIImageView! // 商品图片
    @IBOutlet weak var nameL: UILabel! // 商品名称
    
    @IBOutlet weak var priceL: UILabel! // 价格
    
    @IBOutlet weak var returnL: UILabel! // 返利
    
    @IBOutlet weak var propertyL: UILabel! // 属性
    
    @IBOutlet weak var countL: UILabel! // 数量
    
    @IBOutlet weak var CommitmentL: UILabel!
    
    @IBOutlet weak var integralL: UILabel!
    
    var isIntegralGoods: Bool = false
    
    var shoppingCartModel: XHShoppingCartModel? {
        didSet {
            
            if shoppingCartModel?.icon != nil {
                iconView.sd_setImage(with: URL(string: XHImageBaseURL + (shoppingCartModel?.icon)!), placeholderImage: UIImage(named: XHPlaceholdImage), options: .progressiveDownload)
            }
            
            nameL.text = shoppingCartModel?.name
            
            if isIntegralGoods == true {
                priceL.isHidden = true
                returnL.isHidden = true
                integralL.isHidden = false
                if shoppingCartModel?.price != nil {
                    integralL.text = "+￥" + (shoppingCartModel?.price)!
                }
                if NSString(string: shoppingCartModel?.price ?? "0").floatValue == 0.0 {
                    integralL.isHidden = true
                }else {
                    integralL.isHidden = false
                }
            }else {
                if shoppingCartModel?.price != nil {
                    priceL.text = "￥" + (shoppingCartModel?.price)!
                }
                priceL.isHidden = false
                returnL.isHidden = false
                integralL.isHidden = true
            }
            
            returnL.attributedText = returnL.richLableWithOrderImage(" \((shoppingCartModel?.xhb)!)")
            
            if isIntegralGoods == true {
                propertyL.text = "积分(循环宝):" + (shoppingCartModel?.integral)!
            }else {
                propertyL.text = "属性：" + (shoppingCartModel?.property1 ?? "")
            }
            
            
            if shoppingCartModel?.buyCount != nil {
                countL.text = "x" + String(describing: (shoppingCartModel?.buyCount)!)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
//        CommitmentL.isHidden = true
        integralL.layer.cornerRadius = 3
        integralL.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
}
