//
//  XHWillBeEvaluatedCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/2.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHWillBeEvaluatedCell: UITableViewCell {

    @IBOutlet weak var iconView: UIImageView!
    
    @IBOutlet weak var titleL: UILabel!
    
    
    @IBOutlet weak var priceL: UILabel!
    
    /// 评价按钮的点击事件回调
    var evaluationButtonClickedClosure: (() -> ())?
    
    var evaluationModel: XHMyValuationModel? {
        didSet {
            if evaluationModel?.pro_icon != nil {
                iconView.sd_setImage(with: URL(string: XHImageBaseURL + (evaluationModel?.pro_icon)!), placeholderImage: UIImage(named: XHPlaceholdImage), options: .progressiveDownload)
            }
            
            titleL.text = evaluationModel?.pro_name
            
            priceL.text = "￥" + (evaluationModel?.pro_price ?? "0")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    @IBAction func evaluationButtonClicked(_ sender: UIButton) {
        evaluationButtonClickedClosure?()
    }
}
