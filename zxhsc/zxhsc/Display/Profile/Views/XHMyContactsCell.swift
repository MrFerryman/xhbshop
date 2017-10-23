//
//  XHMyContactsCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/7/28.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHMyContactsCell: UITableViewCell {

    
    @IBOutlet weak var iconView: UIImageView!
    
    @IBOutlet weak var identifierL: UILabel!
    
    @IBOutlet weak var numberL: UILabel!
    
    @IBOutlet weak var dateL: UILabel!
    
    
    var contactModel: XHMyContactsModel? {
        didSet {
            if contactModel?.iconStr != nil {
                 iconView.sd_setImage(with: URL(string: XHImageBaseURL + (contactModel?.iconStr)!), placeholderImage: UIImage(named: "profile_headerImg_icon"))
            }
            identifierL.text = contactModel?.level == "" ? "传递使者" : contactModel?.level
            numberL.text = contactModel?.user
            dateL.text = contactModel?.time
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        iconView.layer.cornerRadius = 17.5
        iconView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
