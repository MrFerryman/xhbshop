//
//  XHMyShop_QRCoderDetailCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/9/26.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHMyShop_QRCoderDetailCell: UITableViewCell {

    @IBOutlet weak var nameL: UILabel!
    
    @IBOutlet weak var mainL: UILabel!
    
    @IBOutlet weak var addressL: UILabel!
    
    var shopModel: XHMyShop_settingModel? {
        didSet {
            nameL.text = shopModel?.name
            mainL.text = shopModel?.mainBusy
            addressL.text = (shopModel?.city ?? "") + (shopModel?.detailAddress ?? "")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
