//
//  XHMyOrderTableViewCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/7.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHMyOrderTableViewCell: UITableViewCell {

    @IBOutlet weak var orderNumberL: UILabel! // 订单编号
    
    @IBOutlet weak var statusL: UILabel! // 状态
    
    @IBOutlet weak var productView: UIView! // 产品视图
    
    @IBOutlet weak var productIconView: UIImageView! // 产品图标
    
    @IBOutlet weak var productNameL: UILabel! // 产品名称
    
    @IBOutlet weak var priceL: UILabel! // 产品价格
    
    @IBOutlet weak var returnL: UILabel! // 返利
    
    @IBOutlet weak var productPropertyL: UILabel! // 产品属性
  
    @IBOutlet weak var productCountL: UILabel! // 产品个数
    
    @IBOutlet weak var orderProductCodeL: UILabel! // 订单识别号
    
    @IBOutlet weak var timeL: UILabel! // 时间
    
    @IBOutlet weak var totalCountL: UILabel! // 总计个数
    
    @IBOutlet weak var totalPriceL: UILabel! // 总计价格
    
    @IBOutlet weak var lineView: UIView!
    
    
    /// 按钮点击事件
    var cellButtonClickedClosure:((_ sender: UIButton, _ model: XHMyOrderModel) -> ())?
    
    /// 订单模型
    var orderModel: XHMyOrderModel? {
        didSet {
            if orderModel?.orderNum != nil {
                orderNumberL.text = "订单编号：" + (orderModel?.orderNum)!
            }
            
            statusL.text = orderModel?.status
            
            if orderModel?.icon != nil {
                productIconView.sd_setImage(with: URL(string: XHImageBaseURL + (orderModel?.icon)!), placeholderImage: UIImage(named: XHPlaceholdImage), options: .progressiveDownload)
            }
            
            productNameL.text = orderModel?.title
            
            if orderModel?.price != nil {
                priceL.text = "￥" + (orderModel?.price)!
            }
            
            if orderModel?.gift != nil {
                returnL.attributedText = returnL.richLableWithOrderImage(" \((orderModel?.gift)!)")
            }
            
            if orderModel?.number != nil {
                productCountL.text = "x" + (orderModel?.number)!
                totalCountL.text = "共" + (orderModel?.number)! + "件商品 合计："
            }
            
            if orderModel?.id != nil {
                orderProductCodeL.text = "订单识别码【\(String(describing: (orderModel?.id)!))】"
            }
            
            if orderModel?.number != nil, orderModel?.price != nil {
                let count = NSString(string: (orderModel?.number)!).integerValue
                let price = NSString(string: (orderModel?.price)!).floatValue
                let result = CGFloat(count) * CGFloat(price)
                let xhbStr = orderModel?.gift ?? "0"
                let xhb = NSString(string: xhbStr).floatValue
                let xhbResult = CGFloat(count) * CGFloat(xhb)
                if xhbResult == 0.0 {
                    totalPriceL.text = "￥\(result)"
                }else {
                    totalPriceL.text = "￥\(result) + \(xhbResult)循环宝"
                }
            }
            
            timeL.text = orderModel?.time
            
            if orderModel?.property != "0", orderModel?.property?.isEmpty == false, orderModel?.property2 != "0", orderModel?.property2?.isEmpty == false {
                productPropertyL.text = "属性：" + (orderModel?.property)! + (orderModel?.property2)!
            }else if  orderModel?.property != "0", orderModel?.property?.isEmpty == false {
                productPropertyL.text = "属性：" + (orderModel?.property)!
            }else if orderModel?.property2 != "0", orderModel?.property2?.isEmpty == false {
                productPropertyL.text = "属性：" + (orderModel?.property2)!
            }
            
            if orderModel?.status == "待付款" {
                buttonsView.cellType = .obligation
            }else if orderModel?.status == "待发货" {
                buttonsView.cellType = .shipments
            }else if orderModel?.status == "已发货" {
                buttonsView.cellType = .shipped
            }else if orderModel?.status == "已完成" {
                buttonsView.cellType = .finished
            }else {
                buttonsView.cellType = .canceled
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        
        addSubview(buttonsView)
        buttonsView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.top.equalTo(lineView.snp.bottom)
            make.height.equalTo(52)
        }
        
        
        
        /// 按钮点击事件
        buttonsView.buttonClickedClosure = { [weak self] sender in
            self?.cellButtonClickedClosure?(sender, (self?.orderModel)!)
        }
    }
    
    private lazy var buttonsView: XHMyOrderButtonView = XHMyOrderButtonView()
}
