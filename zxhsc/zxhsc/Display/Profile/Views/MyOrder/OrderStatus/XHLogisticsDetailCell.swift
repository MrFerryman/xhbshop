//
//  XHLogisticsDetailCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/9/6.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHLogisticsDetailCell: UITableViewCell {

    @IBOutlet weak var titleL: UILabel!
    
    @IBOutlet weak var timeL: UILabel!
    
    @IBOutlet weak var iconView: UIImageView!
    
    @IBOutlet weak var widthCon: NSLayoutConstraint!
    var index: Int? {
        didSet {
            if index == 0 {
                iconView.image = UIImage(named: "logistics_new")
                titleL.textColor = XHRgbColorFromHex(rgb: 0x333333)
                widthCon.constant = 11
            }else {
                iconView.image = UIImage(named: "logistics")
                titleL.textColor = XHRgbColorFromHex(rgb: 0x999999)
                widthCon.constant = 5
            }
        }
    }
    
    var model: XHLogisticsModel? {
        didSet {
            titleL.text = model?.status
            timeL.text = model?.time
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
