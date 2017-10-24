//
//  XHRecommendViewCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/7/27.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHRecommendViewCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var shopNameL: UILabel!
    
    @IBOutlet weak var brandImgView: UIImageView!
    @IBOutlet weak var timeL: UILabel!
    
    @IBOutlet weak var phoneNubL: UILabel!
    
    @IBOutlet weak var contentL: UILabel!
    
    // 是否是品牌店
    var isBrand: Bool = true {
        didSet {
//            if isBrand {
//                brandImgView.image = UIImage(named: "coalition_brand")
//            }else {
//                brandImgView.image = UIImage(named: "coalition_personal_01")
//            }
        }
    }
    
    var shopModel: XHBussinessShopModel? {
        didSet {
            if shopModel?.icon != nil {
                imgView.sd_setImage(with: URL(string: XHImageBaseURL + (shopModel?.icon)!), placeholderImage: UIImage(named: "loding_icon"))
            }else {
                imgView.image = UIImage(named: "loding_icon")
            }
            
            shopNameL.text = shopModel?.name
            
            if shopModel?.shopType == "1" {
                brandImgView.image = UIImage(named: "coalition_brand")
            }else {
                brandImgView.image = UIImage(named: "coalition_personal_01")
            }
            if shopModel?.busyTime != nil {
                timeL.text = "营业时间：" + (shopModel?.busyTime)!
            }
            
            if shopModel?.phoneNum != nil {
                phoneNubL.text = "手机：" + (shopModel?.phoneNum)!
            }
            
            if shopModel?.mainBusy != nil {
                contentL.text = (shopModel?.mainBusy)!
            }
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
//        imgView.backgroundColor = RandomColor()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
