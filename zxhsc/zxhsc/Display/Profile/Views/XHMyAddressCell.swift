//
//  XHMyAddressCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/7/28.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHMyAddressCell: UITableViewCell {

    
    @IBOutlet weak var nameL: UILabel!
    
    @IBOutlet weak var phoneNumL: UILabel!
    
    @IBOutlet weak var addressL: UILabel!
    
    @IBOutlet weak var defaultBtn: UIButton!
    
    /// 删除按钮点击事件回调
    var deleteButtonClickedClosure: ((_ addressModel: XHMyAdressModel) -> ())?
    
    /// 编辑按钮点击事件回调
    var editButtonClickedClosure: ((_ addressModel: XHMyAdressModel) -> ())?
    
    /// 默认地址按钮点击事件回调
    var defaultAddressButtonClosure: ((_ addressModel: XHMyAdressModel) -> ())?
    
    /// 模型
    var addressModel: XHMyAdressModel? {
        didSet {
            nameL.text = addressModel?.addressee
            phoneNumL.text = addressModel?.phoneNum
            addressL.text = (addressModel?.city)! + (addressModel?.street)!
            
            defaultBtn.isSelected = addressModel?.isDefault == "1" ? true : false
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    @IBAction func defaultAddressButtonClicked(_ sender: UIButton) {
        defaultAddressButtonClosure?(addressModel!)
    }
   
    
    @IBAction func deleteButtonClicked(_ sender: UIButton) {
        deleteButtonClickedClosure?(addressModel!)
    }
    
    @IBAction func editButtonClicked(_ sender: UIButton) {
        editButtonClickedClosure?(addressModel!)
    }
    
    
}
