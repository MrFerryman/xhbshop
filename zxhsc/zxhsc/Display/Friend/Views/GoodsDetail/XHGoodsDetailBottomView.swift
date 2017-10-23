//
//  XHGoodsDetailBottomView.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/4.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHGoodsDetailBottomView: UIView {

    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var addToBuyCarBtn: UIButton!
    @IBOutlet weak var buyCarButton: UIButton!
    @IBOutlet weak var collectionButton: UIButton!
    
    @IBOutlet weak var nowBuyButtonCon: NSLayoutConstraint!
    @IBOutlet weak var addToBuycarCon: NSLayoutConstraint!
    /// 立即购买按钮点击事件回调
    var nowBuyButtonClickedClosure: ((_ sender: UIButton) -> ())?
    /// 添加至购物车按钮点击事件回调
    var addToBuyCarButtonClickedClosure: ((_ sender: UIButton) -> ())?
    /// 购物车按钮点击事件回调
    var buyCarButtonClickedClosure: ((_ sender: UIButton) -> ())?
    /// 收藏按钮点击事件回调
    var collectionButtonClickedClosure: ((_ sender: UIButton) -> ())?
    
    var goodsModel: XHGoodsListModel? {
        didSet {
            if goodsModel?.isCollected == 1 {
                collectionButton.isSelected = true
            }else {
                collectionButton.isSelected = false
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        buyCarButton.layoutButtonTitleImageEdge(style: .styleBottom, titleImageSpace: 3)
        collectionButton.layoutButtonTitleImageEdge(style: .styleBottom, titleImageSpace: 3)
        
        if kUIScreenWidth == 320 {
            nowBuyButtonCon.constant = 114 * 320 / 375
            addToBuycarCon.constant = 133 * 320 / 375
        }
        
        if shoppingCartGoodsNum != 0 {
            buyCarButton.imageView?.layer.masksToBounds = false
            buyCarButton.imageView?.showBadge(with: .redDot, value: 4, animationType: .scale)
        }
    }
    
    @IBAction func nowBuyButtonClicked(_ sender: UIButton) {
        nowBuyButtonClickedClosure?(sender)
    }
    
    @IBAction func addToBuyCarButtonClicked(_ sender: UIButton) {
        addToBuyCarButtonClickedClosure?(sender)
    }
    
    @IBAction func buyCarButtonClicked(_ sender: UIButton) {
        buyCarButtonClickedClosure?(sender)
    }
    
    @IBAction func collectionButtonClicked(_ sender: UIButton) {
        collectionButtonClickedClosure?(sender)
    }
    

}
