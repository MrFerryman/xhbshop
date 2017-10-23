//
//  XHCommentTableViewCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/7.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHCommentTableViewCell: UITableViewCell {

    @IBOutlet weak var userIconView: UIImageView!
    
    @IBOutlet weak var userNameL: UILabel!
    
    @IBOutlet weak var dateL: UILabel!
    
    @IBOutlet weak var commentDetailL: UILabel!
    
    @IBOutlet weak var imagesView: XHCheckPendingImageView!
    
    @IBOutlet weak var valueIconView: UIImageView!
    
    @IBOutlet weak var valueL: UILabel!
    
    @IBOutlet weak var imgsViewHeightCon: NSLayoutConstraint!
    
    var commentModel: XHGoods_commentModel? {
        didSet {
            userNameL.text = commentModel?.name
            dateL.text = commentModel?.time
            commentDetailL.text = commentModel?.content
            switch (commentModel?.star)! {
            case "差评":
                valueIconView.image = UIImage(named: "comment_negative1")
                valueL.textColor = XHRgbColorFromHex(rgb: 0x4c5055)
                valueL.text = "差评"
            case "中评":
                valueIconView.image = UIImage(named: "evaluation_medium")
                valueL.textColor = XHRgbColorFromHex(rgb: 0xff8a00)
                valueL.text = "中评"
            case "好评":
                valueIconView.image = UIImage(named: "reputation_good1")
                valueL.textColor = XHRgbColorFromHex(rgb: 0xea2000)
                valueL.text = "好评"
            default:
                break
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userIconView.layer.cornerRadius = 20
        userIconView.layer.masksToBounds = true
        
        imagesView.imagesArr = ["loding_icon", "loding_icon", "loding_icon"]
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
