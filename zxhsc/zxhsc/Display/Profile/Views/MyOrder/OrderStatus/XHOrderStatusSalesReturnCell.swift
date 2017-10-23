//
//  XHOrderStatusSalesReturnCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/9/6.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHOrderStatusSalesReturnCell: UITableViewCell {

    @IBOutlet weak var reasonL: UILabel!
    
    @IBOutlet weak var detailL: UILabel!
    
    @IBOutlet weak var timeL: UILabel!
    
    
    @IBOutlet weak var confirmReturnBtn: UIButton!
    
    /// 确认退货按钮点击事件回调
    var confirmReturnButtonClickedClosure: (() -> ())?
    
    var orderModel: XHMyOrderModel? {
        didSet {
            reasonL.text = orderModel?.salesReturn_reason
            detailL.text = orderModel?.salesReturn_ReaDetail
            timeL.text = orderModel?.salesReturn_time
        }
    }
    
    var isShopOrder: Bool = false {
        didSet {
            confirmReturnBtn.isHidden = !isShopOrder
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        confirmReturnBtn.isHidden = !isShopOrder
    }

    @IBAction func confirmReturnButtonClicked(_ sender: UIButton) {
        confirmReturnButtonClickedClosure?()
    }
   
    
}
