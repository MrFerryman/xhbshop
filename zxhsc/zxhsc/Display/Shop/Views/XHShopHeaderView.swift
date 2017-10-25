//
//  XHShopHeaderView.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/9.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHShopHeaderView: UIView {

    @IBOutlet weak var iconView: UIImageView!
    
    @IBOutlet weak var shopNameL: UILabel!
    
    @IBOutlet weak var phoneNumL: UILabel!
    
    @IBOutlet weak var timeL: UILabel!
    
    @IBOutlet weak var upShopBtn: UIButton!
    
    @IBOutlet weak var personalOrBussinessView: UIImageView!
    
    var shopModel: XHMyShopModel? {
        didSet {
            if shopModel?.logo != nil {
                iconView.sd_setImage(with: URL(string: XHImageBaseURL + (shopModel?.logo)!), placeholderImage: UIImage(named: XHPlaceholdImage), options: .progressiveDownload)
            }
            
            shopNameL.text = shopModel?.name
            
            if shopModel?.shopType == "品牌" {
                personalOrBussinessView.image = UIImage(named: "coalition_brand")
                upShopBtn.isHidden = true
            }else {
                personalOrBussinessView.image = UIImage(named: "coalition_personal_01")
                upShopBtn.isHidden = false
            }
            
            if shopModel?.busyTime != nil {
                phoneNumL.text = "营业时间: " + (shopModel?.busyTime)!
            }
            
            if shopModel?.mainBusy != nil {
                timeL.text = "主营: " + (shopModel?.mainBusy)!
            }
        }
    }
    
    /// 升级店铺按钮点击事件回调
    var upShopButtonClickedClosure: (() -> ())?
    /// 店铺图片点击事件回调
    var shopIconViewClickedClosure: ((_ iconView: UIImageView, _ iconString: String) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(shopIconViewClicked))
        iconView.isUserInteractionEnabled = true
        iconView.addGestureRecognizer(tap)
    }
    
    // MARK:- 升级店铺按钮点击事件
    @IBAction func upShopButtonClicked(_ sender: UIButton) {
        if shopModel?.shop_status == 1 {
            upShopButtonClickedClosure?()
        }
    }
    
    // MARK:- 店铺图标的点击事件
    @objc private func shopIconViewClicked() {
        let logo = XHPlaceholdImage + (shopModel?.logo ?? "")
        shopIconViewClickedClosure?(iconView, logo)
    }

}
