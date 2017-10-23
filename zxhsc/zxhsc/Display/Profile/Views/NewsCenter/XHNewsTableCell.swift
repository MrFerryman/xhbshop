//
//  XHNewsTableCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/21.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHNewsTableCell: UITableViewCell {

    
    @IBOutlet weak var iconView: UIImageView!
    
    @IBOutlet weak var titleL: UILabel!
    
    
    @IBOutlet weak var timeL: UILabel!
    
    var newsModel: XHNewsModel? {
        didSet {
            if newsModel?.icon != nil {
                iconView.sd_setImage(with: URL(string: XHImageBaseURL + (newsModel?.icon)!), placeholderImage: UIImage(named: "loding_icon"))
            }else {
                iconView.image = UIImage(named: "loding_icon")
            }
            
            titleL.text = newsModel?.title
            timeL.text = newsModel?.time
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
