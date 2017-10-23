//
//  XHOrderStatusSalesCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/7.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHOrderStatusSalesCell: UITableViewCell {

    @IBOutlet weak var shopNameL: UILabel! // 店铺名称
    
    @IBOutlet weak var productIconView: UIImageView! // 商品图片
    
    @IBOutlet weak var productNameL: UILabel! // 商品名称
    
    @IBOutlet weak var priceL: UILabel! // 商品价格
    
    @IBOutlet weak var singleReturnL: UILabel! // 单个商品返利
    
    @IBOutlet weak var propertyL: UILabel! // 属性
    
    @IBOutlet weak var productCountL: UILabel! // 产品个数
    
    @IBOutlet weak var orderCodeL: UILabel! // 订单识别码
    
    @IBOutlet weak var totalProceL: UILabel! // 总共价格
    
    @IBOutlet weak var totalReturnL: UILabel! // 总共返利
    @IBOutlet weak var goodsView: UIView! // 商品视图
    
    var orderModel: XHMyOrderModel? {
        didSet {
            if orderModel?.icon != nil {
                productIconView.sd_setImage(with: URL(string: XHImageBaseURL + (orderModel?.icon)!), placeholderImage: UIImage(named: XHPlaceholdImage), options: .progressiveDownload)
            }
            
            shopNameL.text = orderModel?.shop_name
            
            productNameL.text = orderModel?.title
            
            if orderModel?.price != nil {
                priceL.text = "￥" + (orderModel?.price)!
            }
            
            if orderModel?.gift != nil {
                singleReturnL.attributedText = singleReturnL.richLableWithOrderImage(" \((orderModel?.gift)!)")
            }
            
            if orderModel?.property != "0", orderModel?.property?.isEmpty == false, orderModel?.property2 != "0", orderModel?.property2?.isEmpty == false {
                propertyL.text = "属性：" + (orderModel?.property)! + (orderModel?.property2)!
            }else if  orderModel?.property != "0", orderModel?.property?.isEmpty == false {
                propertyL.text = "属性：" + (orderModel?.property)!
            }else if orderModel?.property2 != "0", orderModel?.property2?.isEmpty == false {
                propertyL.text = "属性：" + (orderModel?.property2)!
            }
            
            if orderModel?.number != nil {
                productCountL.text = "x" + (orderModel?.number)!
            }
            
            if orderModel?.number != nil, orderModel?.price != nil {
                let count = NSString(string: (orderModel?.number)!).integerValue
                let price = NSString(string: (orderModel?.price)!).floatValue
                let result = CGFloat(count) * CGFloat(price)
                totalProceL.text = "￥\(String(format: "%.2f", result))"
            }
            
            if orderModel?.gift != nil, orderModel?.number != nil {
                let count = NSString(string: (orderModel?.number)!).integerValue
                let xhb = NSString(string: (orderModel?.gift)!).floatValue
                let result = CGFloat(count) * CGFloat(xhb)
                
                totalReturnL.attributedText = totalReturnL.richLableWithRedImage(" \(String(format: "%.2f", result))", fontSize: 12)
            }
            
            if orderModel?.id != nil {
                orderCodeL.text = "订单识别码【\((orderModel?.id)!)】"
            }
        }
    }
    
    /// 电话按钮点击回调
    var phoneNumberCallClicked: (() -> ())?
    /// 商品视图点击手势事件回调
    var goodsViewClickedClosure: ((_ orderModel: XHMyOrderModel) -> ())?
    
    /// 商品视图点击手势事件
    @objc private func goodsViewClickedGesture() {
        goodsViewClickedClosure?(orderModel!)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        
        
        // 给商品视图添加手势
        let tap = UITapGestureRecognizer(target: self, action: #selector(goodsViewClickedGesture))
        goodsView.addGestureRecognizer(tap)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func callPhoneClicked(_ sender: UIButton) {
        phoneNumberCallClicked?()
    }
}
