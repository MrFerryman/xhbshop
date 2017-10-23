//
//  XHJudgeImageAlertView.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/10/18.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHJudgeImageAlertView: UIView {

    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var codeImageView: UIImageView!
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var centerYCon: NSLayoutConstraint!
    
    var urlString: String? {
        didSet {
            codeImageView.sd_setImage(with: URL(string: urlString!))
        }
    }
    
    /// 换一张按钮点击事件
    var nextButtonClickedClosure: (() -> ())?
    /// 确定按钮点击事件
    var confirmButtonClickedClosure: ((_ code: String) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.layer.cornerRadius = 6
        bgView.layer.masksToBounds = true
    }
    
    func showWithImageUrlString(_ urlString: String) {
        self.alpha = 1
        textField.text = ""
        if kUIScreenWidth == 320 {
            centerYCon.constant = -60
        }
        codeImageView.sd_setImage(with: URL(string: urlString))
        UIApplication.shared.keyWindow?.addSubview(self)
        self.snp.makeConstraints { (make) in
            make.edges.equalTo(UIApplication.shared.keyWindow!)
        }
    }
    
    @IBAction func nextButtonClicked(_ sender: UIButton) {
        nextButtonClickedClosure?()
    }
    
    @IBAction func confirmButtonClicked(_ sender: UIButton) {
        if textField.text?.isEmpty == true {
            UIApplication.shared.keyWindow?.rootViewController?.showHint(in: self, hint: "请输入验证码")
            return
        }
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.codeImageView.bounds.size = CGSize.zero
            self?.alpha = 0
        }) { [weak self] (finished) in
            self?.removeFromSuperview()
            self?.confirmButtonClickedClosure?((self?.textField.text)!)
        }
    }
    
}
