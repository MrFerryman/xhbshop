//
//  XHShoppingCartNormalCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/9.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHShoppingCartNormalCell: UITableViewCell {

    
    @IBOutlet weak var selectButton: UIButton! // 可选按钮
    
    @IBOutlet weak var iconView: UIImageView! // 商品图片
    
    @IBOutlet weak var productNameL: UILabel! // 商品名称
    
    @IBOutlet weak var productPriceL: UILabel! // 商品价格
    
    @IBOutlet weak var returnL: UILabel! // 返宝
    
    @IBOutlet weak var productCountL: UILabel! // 商品数量
    
    @IBOutlet weak var productPropertyL: UILabel! // 商品属性
    
    /// 选中按钮的点击事件回调
    var selectedButtonClickedClosure: ((_ shoppingCartModel: XHShoppingCartModel, _ sender: UIButton) -> ())?
    /// 图片点击手势事件回调
    var iconViewClickGestureClosure: ((_ shoppingCartModel: XHShoppingCartModel) -> ())?
    
    var shoppingCartModol: XHShoppingCartModel? {
        didSet {
            if shoppingCartModol?.icon != nil {
                iconView.sd_setImage(with: URL(string: XHImageBaseURL + (shoppingCartModol?.icon)!), placeholderImage: UIImage(named: XHPlaceholdImage), options: .progressiveDownload)
            }
            
            if shoppingCartModol?.buyCount != nil {
                productCountL.text = "x\(String(describing: (shoppingCartModol?.buyCount)!))"
            }
            
            productNameL.text = shoppingCartModol?.name
            
            if shoppingCartModol?.price != nil {
                productPriceL.text = "￥" + (shoppingCartModol?.price)!
            }
            
            
            returnL.attributedText = returnL.richLableWithRedImage(" \(String(describing: (shoppingCartModol?.xhb)!))", fontSize: 12)
            
            let sthStr = "属性：" + (shoppingCartModol?.property1 ?? "") + " " + (shoppingCartModol?.property2 ?? "")
            productPropertyL.text = sthStr
            selectButton.isSelected = (shoppingCartModol?.isSelected)!
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        
        // 给商品图片添加手势
        let tap = UITapGestureRecognizer(target: self, action: #selector(iconViewClickGesture))
        iconView.addGestureRecognizer(tap)
    }
    
    // MARK:- 图片点击手势事件
    @objc private func iconViewClickGesture() {
        iconViewClickGestureClosure?(shoppingCartModol!)
    }

    @IBAction func selectButtonClicked(_ sender: UIButton) {
         sender.isSelected = !sender.isSelected
        shoppingCartModol?.isSelected = sender.isSelected
        selectedButtonClickedClosure?(shoppingCartModol!, sender)
    }

    
}
