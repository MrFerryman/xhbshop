//
//  XHPersonalOrder_ProductCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/14.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHPersonalOrder_ProductCell: UITableViewCell {

    @IBOutlet weak var productIconView: UIImageView! // 产品图片
    
    @IBOutlet weak var productNameL: UILabel! // 产品名称
    
    @IBOutlet weak var propertyL: UILabel! // 属性
    
    @IBOutlet weak var productCountL: UILabel! // 产品数量
    
    @IBOutlet weak var priceL: UILabel! // 价格
    
    @IBOutlet weak var returnL: UILabel! // 返利
    
    var orderModel: XHMyOrderModel? {
        didSet {
            if orderModel?.icon != nil {
                productIconView.sd_setImage(with: URL(string: XHImageBaseURL + (orderModel?.icon)!), placeholderImage: UIImage(named: XHPlaceholdImage), options: .progressiveDownload)
            }
            
            productNameL.text = orderModel?.title
            
            if orderModel?.property != nil {
                propertyL.text = "属性: " + (orderModel?.property)!
            }
            
            if orderModel?.number != nil {
                productCountL.text = "x" + (orderModel?.number)!
            }
            
            if orderModel?.price != nil {
                priceL.text = "￥" + (orderModel?.price)!
            }
            
            if orderModel?.xhb != nil {
                returnL.attributedText = returnL.richLableWithOrderImage(" \((orderModel?.xhb)!)")
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
