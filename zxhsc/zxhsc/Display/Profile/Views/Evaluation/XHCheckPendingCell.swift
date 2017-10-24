//
//  XHCheckPendingCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/2.
//  Copyright © 2017年 zxhsc. All rights reserved.
//  待审核

import UIKit

class XHCheckPendingCell: UITableViewCell {

    @IBOutlet weak var iconView: UIImageView!  // 产品图片
    
    @IBOutlet weak var productTitleL: UILabel! // 产品标题
    
    @IBOutlet weak var evaluationL: UILabel!   // 评价
    
    @IBOutlet weak var imagesView: XHCheckPendingImageView! // 评价图片视图
    
    @IBOutlet weak var checkImagesViewHeightCon: NSLayoutConstraint! // 评价图片视图的高度
    @IBOutlet weak var valueIconView: UIImageView! // 好评等级图片
    
    @IBOutlet weak var checkL: UILabel! // 待审核
    
    @IBOutlet weak var valueL: UILabel! // 好评等级文字
    
    /// 是否是已评价
    var isComplete: Bool = false {
        didSet {
            if isComplete == true {
                checkL.isHidden = true
            }else {
                checkL.isHidden = false
            }
        }
    }
    
    var checkModel: XHMyElavation_CheckPendingModel? {
        didSet {
            if checkModel?.pro_icon != nil {
                iconView.sd_setImage(with: URL(string: XHImageBaseURL + (checkModel?.pro_icon)!), placeholderImage: UIImage(named: XHPlaceholdImage), options: .progressiveDownload)
            }
            
            productTitleL.text = checkModel?.title
            
            evaluationL.text = checkModel?.content
            
//            if checkModel?.pictures is [String] {
//                checkImagesViewHeightCon.constant = 0
//            }else {
//                checkImagesViewHeightCon.constant = 76
//                imagesView.imagesArr = imagesArr
//            }
            switch checkModel?.level ?? "0" {
            case "0":
                valueIconView.image = UIImage(named: "")
                valueL.textColor = XHRgbColorFromHex(rgb: 0x4c5055)
                valueL.text = "未知"
            case "3":
                valueIconView.image = UIImage(named: "comment_negative1")
                valueL.textColor = XHRgbColorFromHex(rgb: 0x4c5055)
                valueL.text = "差评"
            case "2":
                valueIconView.image = UIImage(named: "evaluation_medium")
                valueL.textColor = XHRgbColorFromHex(rgb: 0xff8a00)
                valueL.text = "中评"
            case "1":
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
        selectionStyle = .none
        checkImagesViewHeightCon.constant = 0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
