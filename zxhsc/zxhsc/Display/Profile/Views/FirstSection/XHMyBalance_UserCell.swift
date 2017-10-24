//
//  XHMyBalance_UserCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/10/13.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHMyBalance_UserCell: UITableViewCell {

    @IBOutlet weak var iconView: UIImageView!
    
    @IBOutlet weak var nicknameL: UILabel!
    
    @IBOutlet weak var phoneL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        iconView.layer.cornerRadius = 35
        iconView.layer.masksToBounds = true
        
        if NSKeyedUnarchiver.unarchiveObject(withFile:userAccountPath) != nil {
            
            let userModel = NSKeyedUnarchiver.unarchiveObject(withFile: userAccountPath) as? XHUserModel
            if userModel?.iconName != nil {
                iconView.sd_setImage(with: URL(string: XHImageBaseURL + (userModel?.iconName)!), completed: nil)
            }
            
            nicknameL.text = userModel?.nickname
            
            phoneL.text = userModel?.account
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
