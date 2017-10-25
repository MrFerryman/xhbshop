//
//  XHBussFirstSectionCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/3.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHBussFirstSectionCell: UITableViewCell {

    @IBOutlet weak var shopIcon: UIImageView! // 店铺图片
    
    @IBOutlet weak var shopName: UILabel! // 店铺名称
    
    @IBOutlet weak var returnL: UILabel!  // 返利
    
    @IBOutlet weak var collectionBtn: UIButton! // 收藏按钮
    
    @IBOutlet weak var styleL: UILabel! // 店铺类型
    
    @IBOutlet weak var mainL: UILabel!  // 主营
    
    @IBOutlet weak var timeL: UILabel!  // 营业时间
    
    @IBOutlet weak var locationL: UILabel!  // 位置
    
    @IBOutlet weak var phoneNumL: UILabel!  // 电话号码
    
    var collectionButtonClickedClosure: ((_ sender: UIButton) -> ())?
    /// 打电话按钮点击事件
    var callPhoneNumberClickedClosure: ((_ shopModel: XHShopDetailModel) -> ())?
    /// 图片的点击事件回调
    var iconViewClickedClosure: ((_ iconView: UIImageView, _ iconString: String) -> ())?
    
    var shopModel: XHShopDetailModel? {
        didSet {
            if shopModel?.icon != nil {
                shopIcon.sd_setImage(with: URL(string: XHImageBaseURL + (shopModel?.icon)!), placeholderImage: UIImage(named: "loding_icon"))
            }
            
            var imgName: String?
            if shopModel?.shopStyle == "品牌店" {
                imgName = "coalition_brand"
            }else {
                imgName = "coalition_personal_01"
            }
            if shopModel?.name != nil {
                 shopName.attributedText = shopName.richLabelWithBrandImage(contentStr: (shopModel?.name)!, brandImage: imgName)
            }
            
            if shopModel?.scale != nil {
                returnL.attributedText = returnL.richLableWithRedImage("消费满100送\(String(describing: (shopModel?.scale)!))", fontSize: 11, imgName: "shop_yuanbao", imageStyle: .back)
            }
            
            if shopModel?.isCollected == 1 {
                collectionBtn.isSelected = true
            }else {
                collectionBtn.isSelected = false
            }
            collectionBtn.layoutButtonTitleImageEdge(style: .styleBottom, titleImageSpace: 6)
            
            styleL.text = shopModel?.className
            
            if shopModel?.mainBusy != nil {
                mainL.text = "主营：" + (shopModel?.mainBusy)!
            }
            
            if shopModel?.busyTime != nil {
                timeL.text = "时间：" + (shopModel?.busyTime)!
            }
            
            if shopModel?.address != nil {
                locationL.text = "位置：" + (shopModel?.address)!
            }
           
            if shopModel?.phoneNum != nil {
                phoneNumL.text = "电话：" + (shopModel?.phoneNum)!
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        
        collectionBtn.addTarget(self, action: #selector(collectionButtonClicked(_:)), for: .touchUpInside)
        let tap = UITapGestureRecognizer(target: self, action: #selector(shopIconViewClicked))
        shopIcon.addGestureRecognizer(tap)
    }
    
    @objc private func collectionButtonClicked(_ sender: UIButton) {
        collectionButtonClickedClosure?(sender)
    }

    // MARK:- 电话号码按钮点击事件
    @IBAction func phoneNumberClicked(_ sender: UIButton) {
        if shopModel != nil {
            callPhoneNumberClickedClosure?(shopModel!)
        }
    }
    
    @objc private func shopIconViewClicked() {
        iconViewClickedClosure?(shopIcon, XHImageBaseURL + (shopModel?.icon ?? ""))
    }
}
