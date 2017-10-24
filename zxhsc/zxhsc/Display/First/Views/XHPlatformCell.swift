//
//  XHPlatformCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/7/16.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHPlatformCell: UITableViewCell {

    /// 按钮的点击事件回调
    var startButtonClickedClosure: ((_ platformModel: XHPlatformModel) -> ())?
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleL: UILabel!
    @IBOutlet weak var subtitleL: UILabel!
    
    @IBOutlet weak var openButton: UIButton!
    
    var platformModel: XHPlatformModel? {
        didSet {
            
            if platformModel?.icon != nil {
                imgView.sd_setImage(with: URL(string: "http://appback.zxhshop.cn/" + (platformModel?.icon)!), placeholderImage: UIImage(named: XHPlaceholdImage))
            }
            
            titleL.text = platformModel?.title
            subtitleL.text = platformModel?.subtitle
            
            if platformModel?.status_name != nil {
                openButton.setTitle(platformModel?.status_name, for: .normal)
            }
            
            if platformModel?.status_name == "已开通" {
                openButton.isSelected = true
            }else {
                openButton.isSelected = false
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    @IBAction func buttonClicked(_ sender: UIButton) {
        if sender.isSelected == false {
            startButtonClickedClosure?(platformModel!)
        }
    }
        
}
