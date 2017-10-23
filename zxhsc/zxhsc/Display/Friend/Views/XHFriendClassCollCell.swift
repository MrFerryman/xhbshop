//
//  XHFriendClassCollCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/7/27.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit


class XHFriendClassCollCell: UICollectionViewCell {

    @IBOutlet weak var icon_view: UIImageView!
    
    @IBOutlet weak var titleL: UILabel!
    
    
    var classModel: XHFriendClassModel? {
        didSet {
            icon_view.sd_setImage(with: URL(string: XHImageBaseURL + (classModel?.cl_icon)!), placeholderImage: UIImage(named: "loding_icon"))
            titleL.text = classModel?.cl_title
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()

    }

}
