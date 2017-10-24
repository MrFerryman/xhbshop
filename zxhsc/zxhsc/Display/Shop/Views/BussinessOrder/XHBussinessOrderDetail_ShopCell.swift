//
//  XHBussinessOrderDetail_ShopCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/11.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHBussinessOrderDetail_ShopCell: UITableViewCell {

    @IBOutlet weak var shopNameL: UILabel! // 店铺名称
    
    @IBOutlet weak var shopPhoneL: UILabel! // 店铺电话
    
    @IBOutlet weak var moneyL: UILabel! // 交易金额
    
    @IBOutlet weak var retrunL: UILabel! // 循环宝
    
    var orderModel: XHMyShopOrderDetailModel? {
        didSet {
            shopNameL.text = orderModel?.shop_name
            
            shopPhoneL.text = orderModel?.customer
            
            moneyL.text = orderModel?.money
            
            retrunL.text = "\((orderModel?.shop_get_xhb)!)"
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
