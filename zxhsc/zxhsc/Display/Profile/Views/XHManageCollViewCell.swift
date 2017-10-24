//
//  XHManageCollViewCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/7/13.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHManageCollViewCell: UICollectionViewCell {
    @IBOutlet weak var manageImgView: UIImageView!

    @IBOutlet weak var manageTitleL: UILabel!
    
    // 管理模型
    var manageModel: XHProfileManageModel? {
        didSet {
            if manageModel?.mg_icon != nil {
                manageImgView.image = UIImage(named: (manageModel?.mg_icon)!)
            }
            
            manageTitleL.text = manageModel?.mg_title
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
