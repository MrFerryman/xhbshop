//
//  XHConfirmOrderHeaderView.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/9.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHConfirmOrderHeaderView: UIView {

    @IBOutlet weak var getterL: UILabel! // 收货人
    
    @IBOutlet weak var phoneNumL: UILabel! // 收货人电话
    @IBOutlet weak var detailAddressL: UILabel! // 详细地址
    
    var addressModel: XHMyAdressModel? {
        didSet {
            getterL.text = addressModel?.addressee
            phoneNumL.text = addressModel?.phoneNum
           detailAddressL.text = (addressModel?.city ?? "") + " " + (addressModel?.street ?? "")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

}
