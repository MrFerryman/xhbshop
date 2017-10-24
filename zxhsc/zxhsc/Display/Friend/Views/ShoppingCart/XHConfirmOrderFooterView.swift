//
//  XHConfirmOrderFooterView.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/9.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHConfirmOrderFooterView: UIView {

    @IBOutlet weak var cycleBaoL: UILabel! // 循环宝
    
    @IBOutlet weak var totalPriceL: UILabel! // 总计
    
    @IBOutlet weak var countL: UILabel! // 商品件数
    
    var goodsArr: [XHShoppingCartModel] = [] {
        didSet {
            countL.text = "共\(String(describing: goodsArr.count))件商品 合计："
            
            var totalPrice: CGFloat = 0.0
            var totalXhb: CGFloat = 0.0
            for model in goodsArr {
                let price = NSString(string: model.price ?? "0").floatValue
                let count = NSString(string: (model.buyCount)!).floatValue
                let totleP = CGFloat(price) * CGFloat(count)
                let totalX = model.xhb * CGFloat(count)
                totalPrice += totleP
                totalXhb += totalX
            }
            
            totalPriceL.text = "￥\(String(format: "%.2f", totalPrice))"
            cycleBaoL.attributedText = cycleBaoL.richLableWithRedImage(" \((totalXhb))", fontSize: 12)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }

}
