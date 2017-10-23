//
//  XHMarketFirstSectionCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/7/18.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHMarketFirstSectionCell: UITableViewCell {

    @IBOutlet weak var rankView: UIView! // 指数排行
    
    @IBOutlet weak var specialView: UIView! // 特惠专区
    
    @IBOutlet weak var carView: UIView! // 汽车
    
    @IBOutlet weak var houseView: UIView!
    
    
    @IBOutlet weak var scaleImgView: UIImageView!
    
    @IBOutlet weak var favImgView: UIImageView!
    
    @IBOutlet weak var carImgView: UIImageView!
    
    @IBOutlet weak var houseImgView: UIImageView!
    
    /// 分类/5倍专区/汽车/房产按钮点击回调
    var buttonClickedClosure: ((_ sender: UIView) -> ())?
    
    var tabbarModel: XHTabbarIconModel? {
        didSet {
            if tabbarModel?.scale_icon != nil {
                scaleImgView.sd_setImage(with: URL(string: XHImageBaseURL + (tabbarModel?.scale_icon)!), placeholderImage: UIImage(named: "home_rank"), options: .progressiveDownload)
            }
            
            if tabbarModel?.fav_icon != nil {
                favImgView.sd_setImage(with: URL(string: XHImageBaseURL + (tabbarModel?.fav_icon)!), placeholderImage: UIImage(named: "market_5area"), options: .progressiveDownload)
            }
            
            if tabbarModel?.car_icon != nil {
                carImgView.sd_setImage(with: URL(string: XHImageBaseURL + (tabbarModel?.car_icon)!), placeholderImage: UIImage(named: "market_car"), options: .progressiveDownload)
            }
            
            if tabbarModel?.house_icon != nil {
                houseImgView.sd_setImage(with: URL(string: XHImageBaseURL + (tabbarModel?.house_icon)!), placeholderImage: UIImage(named: "market_house"), options: .progressiveDownload)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        let rankTap = UITapGestureRecognizer(target: self, action: #selector(buttonClicked(_:)))
        rankView.addGestureRecognizer(rankTap)
        
        let specialTap = UITapGestureRecognizer(target: self, action: #selector(buttonClicked(_:)))
        specialView.addGestureRecognizer(specialTap)
        
        let carTap = UITapGestureRecognizer(target: self, action: #selector(buttonClicked(_:)))
        carView.addGestureRecognizer(carTap)
        
        let houseTap = UITapGestureRecognizer(target: self, action: #selector(buttonClicked(_:)))
        houseView.addGestureRecognizer(houseTap)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    @objc private func buttonClicked(_ sender: UITapGestureRecognizer) {
        buttonClickedClosure?(sender.view!)
    }
    
}
