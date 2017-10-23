//
//  XHOpenAmbassadorCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/30.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHOpenAmbassadorCell: UITableViewCell {

    @IBOutlet weak var accountL: UILabel!
    
    var userModel: XHUserModel? {
        didSet {
            accountL.text = "账号：\(String(describing: (userModel?.account)!))（\(String(describing: (userModel?.nickname)!))）"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
