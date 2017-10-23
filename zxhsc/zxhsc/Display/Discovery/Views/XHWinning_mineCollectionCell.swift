//
//  XHWinning_mineCollectionCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/9/19.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHWinning_mineCollectionCell: UICollectionViewCell {

    @IBOutlet weak var timeL: UILabel!
    
    @IBOutlet weak var contentL: UILabel!
    
    var model: XHMyWinningModel? {
        didSet {
            timeL.text = model?.time
            
            contentL.text = model?.message
        }
    }
    
    var luckyModel: XHLuckyModel? {
        didSet {
            timeL.text = luckyModel?.user
            
            contentL.text = luckyModel?.bonus
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
