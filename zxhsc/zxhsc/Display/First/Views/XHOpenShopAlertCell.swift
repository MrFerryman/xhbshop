//
//  XHOpenShopAlertCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/16.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHOpenShopAlertCell: UITableViewCell {
    
    @IBOutlet weak var firstLineL: UILabel!
    
    @IBOutlet weak var secondLineL: UILabel!
    
    @IBOutlet weak var thirdLineL: UILabel!
    
    @IBOutlet weak var accountL: UILabel!
    
    var userModel: XHUserModel? {
        didSet {
            if userModel?.account != nil, userModel?.nickname != nil {
                
                accountL.text = "账号：\(String(describing: (userModel?.account)!))（\(String(describing: (userModel?.nickname)!))）"
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        firstLineL.attributedText = richLableWithContent("1、开通个人店铺需上传身份证，收益为让利额的一倍")
        secondLineL.attributedText = richLableWithContent("2、开通或升级成为品牌店铺，当让利额大于或等于15%，收益为让利额的二倍")
        thirdLineL.attributedText = richFirstLableWithContent(thirdLineL.text!)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    private func richLableWithContent(_ contentStr: String) -> NSAttributedString {
        // 创建一个富文本
        let attriStr = NSMutableAttributedString(string: contentStr)
        // 修改富文本中不同文字的样式
        let strLength = NSString(string: contentStr).length
        
        attriStr.addAttribute(NSAttributedStringKey.foregroundColor, value: XHRgbColorFromHex(rgb: 0xea2000), range: NSRange(location: strLength - 2, length: 2))
    
        return attriStr
    }
    
    private func richFirstLableWithContent(_ contentStr: String) -> NSAttributedString {
        // 创建一个富文本
        let attriStr = NSMutableAttributedString(string: contentStr)
        // 修改富文本中不同文字的样式
        let strLength = NSString(string: contentStr).length
        
        attriStr.addAttribute(NSAttributedStringKey.foregroundColor, value: XHRgbColorFromHex(rgb: 0xea2000), range: NSRange(location: 2, length: strLength - 2))
        
        return attriStr
    }
    
}
