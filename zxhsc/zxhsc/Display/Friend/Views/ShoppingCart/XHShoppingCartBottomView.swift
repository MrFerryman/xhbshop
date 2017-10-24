//
//  XHShoppingCartBottomView.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/9.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit



class XHShoppingCartBottomView: UIView {

    @IBOutlet weak var allSelectButton: UIButton! // 全选
    
    @IBOutlet weak var totalProceL: UILabel! // 总价
    
    @IBOutlet weak var goToSettle: UIButton! // 去结算
    
    /// 全选按钮点击事件回调
    var allSelectedButtonClickedClosure: ((_ sender: UIButton) -> ())?
    /// 去结算按钮点击事件回调
    var goToSettleButtonClickedClosure: (() -> ())?
    
    var shoppingModelsArr: [XHShoppingCartModel]? {
        didSet {
            if (shoppingModelsArr?.count)! > 0 {
                goToSettle.setTitle("去结算(\((shoppingModelsArr?.count)!))", for: .normal)
            }else {
                goToSettle.setTitle("去结算", for: .normal)
            }
            
            var totalPrice: CGFloat = 0.0
            for model in shoppingModelsArr! {
                let count = NSString(string: (model.price)!).floatValue
                let num = NSString(string: (model.buyCount)!).integerValue
                let result = CGFloat(count) * CGFloat(num)
                totalPrice = totalPrice + CGFloat(result)
            }
            
            totalProceL.text = "￥" + "\(String(format: "%.2f", totalPrice))"
        }
    }
    
    
    /// 控制全选按钮是否被选中
    var isAllSelectedBtnSelected: Bool = false {
        didSet {
            if isAllSelectedBtnSelected == false {
                allSelectButton.isSelected = false
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    // MARK:- 全选按钮点击事件
    @IBAction func allSelectedButtonClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        allSelectedButtonClickedClosure?(sender)
    }
    
    
    // MARK:- 去结算按钮点击事件
    @IBAction func goToSettleButtonClicked(_ sender: UIButton) {
        goToSettleButtonClickedClosure?()
    }
    
}
