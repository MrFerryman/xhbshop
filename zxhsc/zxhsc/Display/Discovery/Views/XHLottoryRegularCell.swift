//
//  XHLottoryRegularCell.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/9/18.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHLottoryRegularCell: UITableViewCell {

    @IBOutlet weak var contentL: UILabel!
    
    var regularStr: String? {
        didSet {
            if regularStr != nil {
                let attribstr = try? NSAttributedString.init(data:(regularStr?.data(using: String.Encoding.unicode))! , options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
                contentL.attributedText = attribstr
            }
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
