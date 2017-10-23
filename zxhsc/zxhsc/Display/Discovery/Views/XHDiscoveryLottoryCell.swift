//
//  XHDiscoveryLottoryCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/9/18.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHDiscoveryLottoryCell: UITableViewCell {

    
    @IBOutlet weak var iconView: UIImageView!
    
    @IBOutlet weak var levelL: UILabel!
    
    @IBOutlet weak var titleL: UILabel!
    
    @IBOutlet weak var priceL: UILabel!
    
    var lottoryModel: XHLottoryModel? {
        didSet {
            if lottoryModel?.icon != nil {
                iconView.sd_setImage(with: URL(string: XHImageBaseURL + (lottoryModel?.icon)!), placeholderImage: UIImage(named: XHPlaceholdImage), options: .progressiveDownload)
            }
            
            levelL.text = lottoryModel?.content
            
            titleL.text = lottoryModel?.title
            
            if lottoryModel?.value != nil {
                priceL.text = "市场参考价: " + (lottoryModel?.value)!
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
