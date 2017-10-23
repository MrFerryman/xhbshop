//
//  XHScaleRankCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/29.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHScaleRankCell: UITableViewCell {

    @IBOutlet weak var titleL: UILabel!
    
    @IBOutlet weak var subTitleL: UILabel!
    
    @IBOutlet weak var bgImgView: UIImageView!
    
    var scaleModel: XHScaleRankModel? {
        didSet {
            titleL.text = scaleModel?.title
            subTitleL.text = scaleModel?.scale
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
