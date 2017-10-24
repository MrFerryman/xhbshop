//
//  XHCustomerOrderCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/11.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHCustomerOrderCell: UITableViewCell {

    @IBOutlet weak var orderNumL: UILabel! // 订单编号
    
    @IBOutlet weak var statusL: UILabel! // 订单编号
    
    @IBOutlet weak var productIconView: UIImageView! // 商品图片
    
    @IBOutlet weak var producePriceL: UILabel! // 商品价格
    
    @IBOutlet weak var productNameL: UILabel! // 商品名称
    
    @IBOutlet weak var productIdL: UILabel! // 商品识别号
    
    @IBOutlet weak var timeL: UILabel! // 时间
    
    @IBOutlet weak var productPropertyL: UILabel! // 商品属性
    
    @IBOutlet weak var productCountL: UILabel! // 商品数量
    
    @IBOutlet weak var totalL: UILabel! // 总价
    
    
    var model: XHShop_customerOrdersModel? {
        didSet {
            if model?.orderNumber != nil {
                orderNumL.text = "订单编号: " + (model?.orderNumber)!
            }
            
            statusL.text = model?.status
            
            if model?.goods_icon != nil {
                productIconView.sd_setImage(with: URL(string: XHImageBaseURL + (model?.goods_icon)!), placeholderImage: UIImage(named: XHPlaceholdImage), options: .progressiveDownload)
            }
            
            productNameL.text = model?.goods_name
            
            if model?.goods_price != nil {
                producePriceL.text = "￥" + (model?.goods_price)!
            }
            
            if model?.id != nil {
                productIdL.text = "订单识别码【\(String(describing: (model?.id)!))】"
            }
            
            timeL.text = model?.time
            
            if model?.goods_pro01 != nil {
                productPropertyL.text = "属性: " + (model?.goods_pro01)!
            }
            
            if model?.buy_count != nil {
                productCountL.text = "x" + (model?.buy_count)!
            }
            
            if model?.goods_price != nil, model?.buy_count != nil {
                let price = NSString(string: (model?.goods_price)!).floatValue
                let count = NSString(string: (model?.buy_count)!).floatValue
                let totalPrice = price * count
                totalL.text = "￥\(totalPrice)"
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
