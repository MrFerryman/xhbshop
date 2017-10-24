//
//  XHPersonalOrder_logisticsNumCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/14.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHPersonalOrder_logisticsNumCell: UITableViewCell {

    @IBOutlet weak var numberTF: UITextField!
    
    /// 确认订单按钮点击事件回调
    var confirmSendButtonClickedClosure: ((_ numberTF: UITextField) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func confirmSendButtonClicked(_ sender: UIButton) {
        confirmSendButtonClickedClosure?(numberTF)
    }
    
}
