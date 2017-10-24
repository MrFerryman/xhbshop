//
//  XHShoppingCartEdittingCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/9.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHShoppingCartEdittingCell: UITableViewCell {

    @IBOutlet weak var selectButton: UIButton! // 选中按钮
    
    @IBOutlet weak var productIconView: UIImageView! // 产品图标
    
    @IBOutlet weak var countL: UILabel! // 数量
    
    @IBOutlet weak var propertyL: UILabel! // 属性
    
    @IBOutlet weak var propertyView: UIView! // 属性视图
    
    @IBOutlet weak var minusButton: UIButton! // 减号按钮
    
    /// 可选按钮点击事件回调
    var selectedButtonClickedClosure: ((_ shoppingCartModel: XHShoppingCartModel, _ sender: UIButton) -> ())?
    /// 属性视图手势点击事件回调
    var propertyViewClickedGestureClosure: ((_ shoppingCartModel: XHShoppingCartModel) -> ())?
    /// 图片手势点击事件回调
    var productIconClickedGestureClosure: ((_ shoppingCartModel: XHShoppingCartModel) -> ())?
    /// 删除按钮点击事件回调
    var deleteButtonClickedClosure: ((_ shoppingCartModel: XHShoppingCartModel, _ idx: Int) -> ())?
    /// 收藏按钮点击事件回调
    var collectionButtonClickedClosure: ((_ shoppingCartModel: XHShoppingCartModel) -> ())?
    /// 商品数量编辑事件回调
    var productNumberEditClosure: (() -> ())?
    
    var shoppingCartModel: XHShoppingCartModel? {
        didSet {
            selectButton.isSelected = (shoppingCartModel?.isSelected)!
            minusButton.isEnabled = shoppingCartModel?.buyCount == "1" ? false : true
            if shoppingCartModel?.buyCount != nil {
                countL.text = String(describing: (shoppingCartModel?.buyCount)!)
            }
            
            if shoppingCartModel?.icon != nil {
                productIconView.sd_setImage(with: URL(string: XHImageBaseURL + (shoppingCartModel?.icon)!), placeholderImage: UIImage(named: XHPlaceholdImage), options: .progressiveDownload)
            }
        }
    }
    
    /// 用来方便外边删除
    var goodsIdx: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        let tap = UITapGestureRecognizer(target: self, action: #selector(propertyViewClicked))
        propertyView.addGestureRecognizer(tap)
        
        // 给商品图片添加手势
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(iconViewClickGesture))
        productIconView.addGestureRecognizer(tap1)
        propertyView.isHidden = true
    }
    
    // MARK:- 图片点击手势事件
    @objc private func iconViewClickGesture() {
        productIconClickedGestureClosure?(shoppingCartModel!)
    }
    
    // MARK:- 可选按钮点击事件
    @IBAction func selectedButtonClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        shoppingCartModel?.isSelected = sender.isSelected
        selectedButtonClickedClosure?(shoppingCartModel!, sender)
    }
    
    // MARK:- 属性视图的手势点击事件
    @objc private func propertyViewClicked() {
        propertyViewClickedGestureClosure?(shoppingCartModel!)
    }

   /// MARK:- 减号 按钮点击事件
    @IBAction func minusButtonClicked(_ sender: UIButton) {
        minusButton.isEnabled = shoppingCartModel?.buyCount == "2" ? false : true
        var count = NSString(string: (shoppingCartModel?.buyCount)!).integerValue
        count -= 1
        shoppingCartModel?.buyCount = "\(count)"
        countL.text = String(describing: (shoppingCartModel?.buyCount)!)
        productNumberEditClosure?()
    }
    
    // MARK:- 加号 按钮点击事件
    @IBAction func plusButtonClick(_ sender: UIButton) {
        var count = NSString(string: (shoppingCartModel?.buyCount)!).integerValue
        count += 1
        countL.text = String(describing: (shoppingCartModel?.buyCount)!)
        shoppingCartModel?.buyCount = "\(count)"
        minusButton.isEnabled = shoppingCartModel?.buyCount == "1" ? false : true
        productNumberEditClosure?()
    }
    
    // MARK:- 删除按钮点击事件
    @IBAction func deleteButtonClicked(_ sender: UIButton) {
        deleteButtonClickedClosure?(shoppingCartModel!, goodsIdx!)
    }
    // MARK:- 收藏按钮点击事件
    @IBAction func collectButtonClicked(_ sender: UIButton) {
        collectionButtonClickedClosure?(shoppingCartModel!)
    }
    
    
}
