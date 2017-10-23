//
//  XHHomeAlertView.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/10/13.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHHomeAlertView: UIView {

    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var confirmButton: UIButton!
    
    @IBOutlet weak var bgView: UIView!
    
    /// 朕知道了 按钮点击事件回调
    var confirmButtonClickedClosure: (() -> ())?
    
    var alertString: String? {
        didSet {
             let attribstr = try! NSAttributedString(data: (alertString?.data(using: String.Encoding.unicode))! , options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
            textView.attributedText = attribstr
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        confirmButton.layer.cornerRadius = 6
        confirmButton.layer.masksToBounds = true
        bgView.layer.cornerRadius = 10
        bgView.layer.masksToBounds = true
    }
    
    @IBAction func confirmButtonClicked(_ sender: UIButton) {
        confirmButtonClickedClosure?()
    }
    
}
